#!/bin/bash
#
# config_generator.sh - Dynamic Ansible Configuration Generator
#
# This script generates Ansible configuration files from deploy.conf templates
# using environment variable substitution with envsubst.
#
# Usage:
#   ./config_generator.sh [--config CONFIG_FILE] [--profile PROFILE] [--dry-run] [--verbose]
#
# Options:
#   --config FILE    Configuration file to use (default: config/deploy.conf)
#   --profile NAME   Profile to use (work/personal/development)
#   --dry-run       Show what would be generated without creating files
#   --verbose       Enable verbose output
#   --help, -h      Show this help message
#

set -euo pipefail

# Script metadata
SCRIPT_NAME="Dynamic Ansible Configuration Generator"
SCRIPT_VERSION="1.0.0"

# Default configuration
DEFAULT_CONFIG_FILE="config/deploy.conf"
TEMPLATES_DIR="configs/ansible/templates"
OUTPUT_DIR="configs/ansible"

# Runtime variables
CONFIG_FILE=""
PROFILE=""
DRY_RUN=false
VERBOSE=false
USE_BASH_ENVSUBST=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

log_verbose() {
    if [[ "$VERBOSE" == "true" ]]; then
        echo -e "${CYAN}[VERBOSE]${NC} $*"
    fi
}

# Help function
show_help() {
    cat << EOF
$SCRIPT_NAME v$SCRIPT_VERSION

Generates Ansible configuration files dynamically from deploy.conf templates.

USAGE:
    $0 [OPTIONS]

OPTIONS:
    --config FILE      Configuration file (default: $DEFAULT_CONFIG_FILE)
    --profile NAME     Profile to use (work/personal/development)
    --dry-run         Show what would be generated without creating files
    --verbose         Enable verbose output
    --help, -h        Show this help

EXAMPLES:
    # Generate configs from default deploy.conf
    $0

    # Generate configs with specific profile
    $0 --profile work

    # Preview what would be generated
    $0 --dry-run --verbose

    # Use custom config file
    $0 --config /path/to/custom.conf

TEMPLATE FILES:
    $TEMPLATES_DIR/group_vars.yml.j2    -> $OUTPUT_DIR/group_vars/all/vars.yml
    $TEMPLATES_DIR/host_vars.yml.j2     -> $OUTPUT_DIR/host_vars/localhost/vars.yml
    $TEMPLATES_DIR/inventory.yml.j2     -> $OUTPUT_DIR/inventory/localhost.yml

CONFIGURATION VARIABLES:
    Variables from deploy.conf are exported as environment variables and
    substituted into templates using envsubst. Missing variables use defaults.

EOF
}

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --config)
                CONFIG_FILE="$2"
                shift 2
                ;;
            --profile)
                PROFILE="$2"
                shift 2
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --verbose)
                VERBOSE=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                echo "Use --help for usage information."
                exit 1
                ;;
        esac
    done
}

# Find script directory and project root
get_script_paths() {
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Try to find project root
    local project_root=""
    local current_dir="$script_dir"
    
    # Look for project root indicators
    while [[ "$current_dir" != "/" ]]; do
        if [[ -f "$current_dir/local.yml" && -d "$current_dir/configs/ansible" ]]; then
            project_root="$current_dir"
            break
        fi
        current_dir="$(dirname "$current_dir")"
    done
    
    if [[ -z "$project_root" ]]; then
        log_error "Could not find project root (looking for local.yml and configs/ansible)"
        exit 1
    fi
    
    echo "$project_root"
}

# Validate paths and files
validate_environment() {
    local project_root="$1"
    
    log_verbose "Validating environment..."
    log_verbose "Project root: $project_root"
    log_verbose "Templates directory: $project_root/$TEMPLATES_DIR"
    
    # Check if templates directory exists
    if [[ ! -d "$project_root/$TEMPLATES_DIR" ]]; then
        log_error "Templates directory not found: $project_root/$TEMPLATES_DIR"
        exit 1
    fi
    
    # Check if required template files exist
    local required_templates=(
        "group_vars.yml.j2"
        "host_vars.yml.j2"
        "inventory.yml.j2"
    )
    
    for template in "${required_templates[@]}"; do
        if [[ ! -f "$project_root/$TEMPLATES_DIR/$template" ]]; then
            log_error "Required template not found: $project_root/$TEMPLATES_DIR/$template"
            exit 1
        fi
    done
    
    # Set default config file if not specified
    if [[ -z "$CONFIG_FILE" ]]; then
        CONFIG_FILE="$project_root/$DEFAULT_CONFIG_FILE"
    fi
    
    # Make config file path absolute if it's relative
    if [[ ! "$CONFIG_FILE" = /* ]]; then
        CONFIG_FILE="$project_root/$CONFIG_FILE"
    fi
    
    # Check if config file exists
    if [[ ! -f "$CONFIG_FILE" ]]; then
        log_error "Configuration file not found: $CONFIG_FILE"
        exit 1
    fi
    
    log_verbose "Using configuration file: $CONFIG_FILE"
    
    # Check if envsubst is available, or use bash alternative
    if ! command -v envsubst >/dev/null 2>&1; then
        log_warning "envsubst not found, using bash-based variable substitution"
        USE_BASH_ENVSUBST=true
    else
        USE_BASH_ENVSUBST=false
    fi
    
    log_verbose "Environment validation completed"
}

# Parse deploy.conf and export variables
parse_deploy_conf() {
    local config_file="$1"
    
    log_info "Parsing configuration file: $config_file"
    
    # Validate config file format
    if ! grep -q "=" "$config_file"; then
        log_error "Configuration file does not appear to be in KEY=VALUE format"
        exit 1
    fi
    
    # Source the configuration file safely
    # First, create a temporary file with only valid variable assignments
    local temp_config
    temp_config=$(mktemp)
    
    # Extract valid variable assignments, keeping quotes for values with spaces
    # Filter out comments, empty lines, and clean variable assignments
    sed -n '/^[[:space:]]*[A-Z_][A-Z0-9_]*=/p' "$config_file" | \
    sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | \
    sed 's/="\(.*\)"$/="\1"/' | \
    sed "s/='\(.*\)'$/='\1'/" > "$temp_config"
    
    # Debug: show temp config content if verbose
    if [[ "$VERBOSE" == "true" ]]; then
        log_verbose "Temp config content:"
        cat "$temp_config" | while IFS= read -r line; do
            log_verbose "  $line"
        done
    fi
    
    # Source the cleaned configuration
    set -a  # Automatically export all variables
    # shellcheck source=/dev/null
    source "$temp_config"
    set +a
    
    # Clean up
    rm -f "$temp_config"
    
    # Apply profile-specific settings if profile is specified
    if [[ -n "$PROFILE" ]]; then
        log_info "Applying profile-specific settings: $PROFILE"
        export PROFILE
        
        # Profile-specific variable overrides
        case "$PROFILE" in
            work)
                export ENABLE_DEVELOPMENT=${ENABLE_DEVELOPMENT:-true}
                export ENABLE_GAMING=${ENABLE_GAMING:-false}
                export FIREWALL_STRICT=${FIREWALL_STRICT:-true}
                ;;
            personal)
                export ENABLE_DEVELOPMENT=${ENABLE_DEVELOPMENT:-false}
                export ENABLE_GAMING=${ENABLE_GAMING:-true}
                export FIREWALL_STRICT=${FIREWALL_STRICT:-false}
                ;;
            development)
                export ENABLE_DEVELOPMENT=${ENABLE_DEVELOPMENT:-true}
                export ENABLE_GAMING=${ENABLE_GAMING:-false}
                export FIREWALL_STRICT=${FIREWALL_STRICT:-true}
                export GENERATE_SSH_KEYS=${GENERATE_SSH_KEYS:-true}
                ;;
        esac
    fi
    
    # Log parsed variables if verbose
    if [[ "$VERBOSE" == "true" ]]; then
        log_verbose "Parsed configuration variables:"
        env | grep -E "^[A-Z_]+=" | sort | while IFS= read -r var; do
            log_verbose "  $var"
        done
    fi
    
    log_success "Configuration parsed successfully"
}

# Bash-based envsubst alternative
bash_envsubst() {
    local input_file="$1"
    local output_file="$2"
    
    # Check if input file exists
    if [[ ! -f "$input_file" ]]; then
        log_error "Template file not found: $input_file"
        return 1
    fi
    
    # Use a simpler approach - process the entire file at once
    # Read the template content
    local template_content
    template_content=$(cat "$input_file")
    
    # Use envsubst-like behavior by exporting all our variables and using eval
    # Remove quotes from HERE document to allow variable expansion
    {
        # Export all configuration variables for the template
        set -a
        # Process template content with variable substitution (no quotes around EOF)
        eval "cat << TEMPLATE_EOF
$template_content
TEMPLATE_EOF"
        set +a
    } > "$output_file" 2>/dev/null || {
        log_error "Failed to process template: $input_file"
        return 1
    }
    
    return 0
}

# Generate a single configuration file from template
generate_config_file() {
    local template_file="$1"
    local output_file="$2"
    local project_root="$3"
    
    log_verbose "Generating $output_file from $template_file"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY-RUN] Would generate: $output_file"
        log_verbose "[DRY-RUN] Template: $template_file"
        return 0
    fi
    
    # Create output directory if it doesn't exist
    local output_dir
    output_dir="$(dirname "$output_file")"
    mkdir -p "$output_dir"
    
    # Process template with envsubst or bash alternative
    if [[ "$USE_BASH_ENVSUBST" == "true" ]]; then
        if bash_envsubst "$template_file" "$output_file"; then
            log_success "Generated: $output_file"
        else
            log_error "Failed to generate: $output_file"
            return 1
        fi
    else
        if envsubst < "$template_file" > "$output_file"; then
            log_success "Generated: $output_file"
        else
            log_error "Failed to generate: $output_file"
            return 1
        fi
    fi
}

# Generate all configuration files
generate_configs() {
    local project_root="$1"
    
    log_info "Generating Ansible configuration files..."
    
    # Define template to output mappings
    local -A file_mappings=(
        ["$project_root/$TEMPLATES_DIR/group_vars.yml.j2"]="$project_root/$OUTPUT_DIR/group_vars/all/vars.yml"
        ["$project_root/$TEMPLATES_DIR/host_vars.yml.j2"]="$project_root/$OUTPUT_DIR/host_vars/${HOSTNAME:-localhost}/vars.yml"
        ["$project_root/$TEMPLATES_DIR/inventory.yml.j2"]="$project_root/$OUTPUT_DIR/inventory/${HOSTNAME:-localhost}.yml"
    )
    
    # Debug: show all mappings if verbose
    if [[ "$VERBOSE" == "true" ]]; then
        log_verbose "File mappings to process:"
        for template_file in "${!file_mappings[@]}"; do
            log_verbose "  $template_file -> ${file_mappings[$template_file]}"
        done
    fi
    
    local success_count=0
    local total_count=${#file_mappings[@]}
    
    # Generate each configuration file
    # Temporarily disable exit on error for this loop
    set +e
    for template_file in "${!file_mappings[@]}"; do
        local output_file="${file_mappings[$template_file]}"
        
        log_verbose "Processing: $template_file"
        
        if generate_config_file "$template_file" "$output_file" "$project_root"; then
            ((success_count++))
            log_verbose "Success count: $success_count"
        else
            log_error "Failed to generate: $output_file"
            # Continue with other files even if one fails
        fi
    done
    # Re-enable exit on error
    set -e
    
    # Report results
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY-RUN] Would generate $total_count configuration files"
    else
        log_success "Generated $success_count/$total_count configuration files"
        
        if [[ $success_count -eq $total_count ]]; then
            log_success "All configuration files generated successfully!"
        else
            log_error "Some configuration files failed to generate"
            exit 1
        fi
    fi
}

# Validate generated files
validate_generated_files() {
    local project_root="$1"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        return 0
    fi
    
    log_info "Validating generated configuration files..."
    
    # Check YAML syntax of generated files
    local yaml_files=(
        "$project_root/$OUTPUT_DIR/group_vars/all/vars.yml"
        "$project_root/$OUTPUT_DIR/host_vars/${HOSTNAME:-localhost}/vars.yml"
        "$project_root/$OUTPUT_DIR/inventory/${HOSTNAME:-localhost}.yml"
    )
    
    local validation_errors=0
    
    for yaml_file in "${yaml_files[@]}"; do
        if [[ -f "$yaml_file" ]]; then
            # Try to parse YAML with python if available
            if command -v python3 >/dev/null 2>&1; then
                if ! python3 -c "import yaml; yaml.safe_load(open('$yaml_file'))" 2>/dev/null; then
                    log_error "YAML validation failed: $yaml_file"
                    ((validation_errors++))
                else
                    log_verbose "YAML validation passed: $yaml_file"
                fi
            else
                log_verbose "Python3 not available, skipping YAML validation"
            fi
        else
            log_error "Generated file not found: $yaml_file"
            ((validation_errors++))
        fi
    done
    
    if [[ $validation_errors -eq 0 ]]; then
        log_success "All generated files passed validation"
    else
        log_error "$validation_errors validation errors found"
        exit 1
    fi
}

# Main function
main() {
    log_info "$SCRIPT_NAME v$SCRIPT_VERSION"
    
    # Parse command line arguments
    parse_arguments "$@"
    
    # Get project paths
    local project_root
    project_root=$(get_script_paths)
    
    # Validate environment
    validate_environment "$project_root"
    
    # Parse configuration file
    parse_deploy_conf "$CONFIG_FILE"
    
    # Generate configuration files
    generate_configs "$project_root"
    
    # Validate generated files
    validate_generated_files "$project_root"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "Dry-run completed. No files were modified."
    else
        log_success "Configuration generation completed successfully!"
        log_info "Generated files are ready for Ansible deployment."
    fi
}

# Run main function with all arguments
main "$@"