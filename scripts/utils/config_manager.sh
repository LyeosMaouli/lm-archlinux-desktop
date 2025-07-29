#!/bin/bash
#
# Configuration Manager - Two-File Configuration System
#
# This script manages the simplified two-file configuration system:
# 1. bootstrap.conf - Pre-download configuration (minimal)
# 2. config/deploy.conf - Post-download detailed deployment settings
#
# Usage:
#   ./config_manager.sh validate-bootstrap    # Validate bootstrap configuration
#   ./config_manager.sh validate-deploy      # Validate deployment configuration
#   ./config_manager.sh validate-all         # Validate both configurations
#   ./config_manager.sh sync-settings        # Sync common settings between files
#   ./config_manager.sh generate-profiles    # Generate profile-specific configs
#   ./config_manager.sh clean-generated      # Remove generated profile files
#

set -euo pipefail

# Script directory and paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONFIG_DIR="$PROJECT_ROOT/config"

# Configuration files
BOOTSTRAP_CONFIG="$PROJECT_ROOT/bootstrap.conf"
DEPLOY_CONFIG="$CONFIG_DIR/deploy.conf"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Load configuration file safely
load_config() {
    local config_file="$1"
    
    if [[ ! -f "$config_file" ]]; then
        log_error "Configuration file not found: $config_file"
        return 1
    fi
    
    log_info "Loading configuration: $config_file"
    
    # Source the configuration file safely
    while IFS='=' read -r key value; do
        # Skip comments and empty lines
        [[ $key =~ ^[[:space:]]*# ]] && continue
        [[ -z $key ]] && continue
        
        # Remove quotes, comments, and whitespace
        key=$(echo "$key" | tr -d ' ')
        value=$(echo "$value" | sed 's/[[:space:]]*#.*//' | sed 's/^["'"'"']\|["'"'"']$//g' | xargs)
        
        # Export the variable
        export "$key"="$value"
    done < "$config_file"
}

# Validate bootstrap configuration
validate_bootstrap_config() {
    log_info "Validating bootstrap configuration..."
    
    if ! load_config "$BOOTSTRAP_CONFIG"; then
        return 1
    fi
    
    local errors=0
    
    # Check required bootstrap fields
    local required_fields=(
        "REPO_URL" "BRANCH" "HOSTNAME" "USER_NAME" "PROFILE" "PASSWORD_MODE"
    )
    
    for field in "${required_fields[@]}"; do
        if [[ -z "${!field:-}" ]]; then
            log_error "Required bootstrap field $field is empty or not set"
            ((errors++))
        fi
    done
    
    # Validate profile
    if [[ ! "${PROFILE:-}" =~ ^(work|personal|development)$ ]]; then
        log_error "Invalid PROFILE: ${PROFILE:-}. Must be: work, personal, or development"
        ((errors++))
    fi
    
    # Validate repository URL format
    if [[ -n "${REPO_URL:-}" ]] && [[ ! "${REPO_URL}" =~ ^https?:// ]]; then
        log_error "Invalid REPO_URL format: ${REPO_URL}. Must start with http:// or https://"
        ((errors++))
    fi
    
    # Validate hostname format
    if [[ -n "${HOSTNAME:-}" ]] && [[ ! "${HOSTNAME}" =~ ^[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]$|^[a-zA-Z0-9]$ ]]; then
        log_error "Invalid HOSTNAME format: ${HOSTNAME}. Must contain only letters, numbers, and hyphens"
        ((errors++))
    fi
    
    # Validate username format
    if [[ -n "${USER_NAME:-}" ]] && [[ ! "${USER_NAME}" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
        log_error "Invalid USER_NAME format: ${USER_NAME}. Must start with lowercase letter or underscore"
        ((errors++))
    fi
    
    # Validate password mode
    if [[ ! "${PASSWORD_MODE:-}" =~ ^(env|file|generate|interactive)$ ]]; then
        log_error "Invalid PASSWORD_MODE: ${PASSWORD_MODE:-}. Must be: env, file, generate, or interactive"
        ((errors++))
    fi
    
    if [[ $errors -eq 0 ]]; then
        log_success "Bootstrap configuration validation passed"
        return 0
    else
        log_error "Bootstrap configuration validation failed with $errors errors"
        return 1
    fi
}

# Validate deployment configuration
validate_deploy_config() {
    log_info "Validating deployment configuration..."
    
    if ! load_config "$DEPLOY_CONFIG"; then
        return 1
    fi
    
    local errors=0
    
    # Check required deployment fields
    local required_fields=(
        "USER_NAME" "PROFILE" "HOSTNAME" 
        "DESKTOP_SESSION" "DISPLAY_MANAGER" "AUDIO_SYSTEM"
    )
    
    for field in "${required_fields[@]}"; do
        if [[ -z "${!field:-}" ]]; then
            log_error "Required deployment field $field is empty or not set"
            ((errors++))
        fi
    done
    
    # Validate boolean values
    local boolean_fields=(
        "ENCRYPTION_ENABLED" "ENABLE_FIREWALL" "ENABLE_FAIL2BAN" "ENABLE_AUDIT"
        "ENABLE_SSH" "ENABLE_AUR" "AUTO_LOGIN" "AUTO_REBOOT" "ENABLE_DEVELOPMENT"
        "ENABLE_GAMING" "SKIP_CONFIRMATIONS" "CONTINUE_ON_ERROR" "DEBUG"
    )
    
    for field in "${boolean_fields[@]}"; do
        if [[ -n "${!field:-}" ]] && [[ ! "${!field}" =~ ^(true|false)$ ]]; then
            log_error "Invalid boolean value for $field: ${!field}. Must be: true or false"
            ((errors++))
        fi
    done
    
    # Validate desktop session
    if [[ -n "${DESKTOP_SESSION:-}" ]] && [[ ! "${DESKTOP_SESSION}" =~ ^(hyprland|gnome|kde|xfce)$ ]]; then
        log_error "Invalid DESKTOP_SESSION: ${DESKTOP_SESSION}. Must be: hyprland, gnome, kde, or xfce"
        ((errors++))
    fi
    
    # Validate numeric values
    local numeric_fields=("LOG_LEVEL" "PARALLEL_JOBS" "DOWNLOAD_TIMEOUT" "NETWORK_TIMEOUT")
    
    for field in "${numeric_fields[@]}"; do
        if [[ -n "${!field:-}" ]] && [[ ! "${!field}" =~ ^[0-9]+$ ]]; then
            log_error "Invalid numeric value for $field: ${!field}. Must be a positive integer"
            ((errors++))
        fi
    done
    
    if [[ $errors -eq 0 ]]; then
        log_success "Deployment configuration validation passed"
        return 0
    else
        log_error "Deployment configuration validation failed with $errors errors"
        return 1
    fi
}

# Sync common settings between bootstrap and deploy configs
sync_common_settings() {
    log_info "Syncing common settings between bootstrap and deployment configurations..."
    
    # Load bootstrap config to get current values
    if ! load_config "$BOOTSTRAP_CONFIG"; then
        log_error "Failed to load bootstrap configuration"
        return 1
    fi
    
    # Store bootstrap values
    local bootstrap_hostname="${HOSTNAME:-}"
    local bootstrap_username="${USER_NAME:-}"
    local bootstrap_profile="${PROFILE:-}"
    
    # Create backup of deploy config
    cp "$DEPLOY_CONFIG" "$DEPLOY_CONFIG.bak.$(date +%s)" 2>/dev/null || true
    
    # Update deployment config with bootstrap values
    sed -i "s/^HOSTNAME=.*/HOSTNAME=\"$bootstrap_hostname\"/" "$DEPLOY_CONFIG"
    sed -i "s/^USER_NAME=.*/USER_NAME=\"$bootstrap_username\"/" "$DEPLOY_CONFIG"
    sed -i "s/^PROFILE=.*/PROFILE=\"$bootstrap_profile\"/" "$DEPLOY_CONFIG"
    
    log_success "Common settings synchronized:"
    log_info "  HOSTNAME: $bootstrap_hostname"
    log_info "  USER_NAME: $bootstrap_username"
    log_info "  PROFILE: $bootstrap_profile"
}

# Generate profile-specific configuration files
generate_profile_configs() {
    log_info "Generating profile-specific configuration files..."
    
    # Load current deployment config
    if ! load_config "$DEPLOY_CONFIG"; then
        log_error "Failed to load deployment configuration"
        return 1
    fi
    
    local profiles=("work" "personal" "development")
    
    for profile in "${profiles[@]}"; do
        local profile_ansible_dir="$PROJECT_ROOT/configs/profiles/$profile/ansible"
        local profile_archinstall_dir="$PROJECT_ROOT/configs/profiles/$profile/archinstall"
        
        mkdir -p "$profile_ansible_dir"
        mkdir -p "$profile_archinstall_dir"
        
        # Generate Ansible variables for this profile
        generate_ansible_vars "$profile" "$profile_ansible_dir/vars.yml"
        
        # Generate archinstall configuration for this profile
        generate_archinstall_config "$profile" "$profile_archinstall_dir/user_configuration.json"
    done
    
    log_success "Profile-specific configurations generated"
}

# Generate Ansible variables for a specific profile
generate_ansible_vars() {
    local profile="$1"
    local output_file="$2"
    
    log_info "Generating Ansible variables for $profile profile: $output_file"
    
    cat > "$output_file" << EOF
---
# $profile Profile Configuration
# Generated from config/deploy.conf - DO NOT EDIT MANUALLY

profile_name: "$profile"
profile_type: "${profile^^}"

# System Configuration
system:
  hostname: "${HOSTNAME:-phoenix}"
  timezone: "${TIMEZONE:-Europe/Paris}"
  locale: "${LOCALE:-en_US.UTF-8}"
  keymap: "${KEYMAP:-fr}"

# User Configuration  
user:
  username: "${USER_NAME:-user}"
  shell: "/bin/bash"
  groups:
    - wheel
    - audio
    - video
    - network
    - storage

# Desktop Configuration
desktop:
  environment: "${DESKTOP_SESSION:-hyprland}"
  display_manager: "${DISPLAY_MANAGER:-sddm}"
  theme: "${DESKTOP_THEME:-catppuccin-mocha}"
  auto_login: ${AUTO_LOGIN:-false}

# Security Configuration
security:
  firewall:
    enabled: ${ENABLE_FIREWALL:-true}
    default_policy: "deny"
  fail2ban:
    enabled: ${ENABLE_FAIL2BAN:-true}
  audit:
    enabled: ${ENABLE_AUDIT:-true}
  ssh:
    port: ${SSH_PORT:-22}
    password_auth: false
    root_login: false
    key_types: ["${SSH_KEY_TYPE:-ed25519}"]

# Development Configuration
development:
  git:
    username: "${GIT_USERNAME:-}"
    email: "${GIT_EMAIL:-}"
  ssh_keys:
    generate: ${GENERATE_SSH_KEYS:-true}
    type: "${SSH_KEY_TYPE:-ed25519}"
  tools_enabled: ${ENABLE_DEVELOPMENT:-true}

# Hardware Configuration
hardware:
  bootloader: "${BOOTLOADER:-systemd-boot}"
  filesystem: "${FILESYSTEM:-ext4}"
  encryption: ${ENCRYPTION_ENABLED:-true}
  bluetooth: ${ENABLE_BLUETOOTH:-true}
  printing: ${ENABLE_PRINTING:-true}

# Package Configuration
packages:
  aur_enabled: ${ENABLE_AUR:-true}
  custom_packages: "${CUSTOM_PACKAGES:-}"
  parallel_downloads: ${PARALLEL_DOWNLOADS:-5}

# Automation Configuration
automation:
  skip_confirmations: ${SKIP_CONFIRMATIONS:-false}
  auto_reboot: ${AUTO_REBOOT:-false}
  continue_on_error: ${CONTINUE_ON_ERROR:-false}
  log_level: "${LOG_LEVEL:-3}"
  debug: ${DEBUG:-false}
EOF
}

# Generate archinstall configuration for a specific profile
generate_archinstall_config() {
    local profile="$1"
    local output_file="$2"
    
    log_info "Generating archinstall configuration for $profile profile: $output_file"
    
    cat > "$output_file" << EOF
{
    "!users": [
        {
            "username": "${USER_NAME:-user}",
            "!password": null,
            "sudo": true
        }
    ],
    "archinstall-language": "English",
    "audio_config": {
        "audio": "${AUDIO_SYSTEM:-pipewire}"
    },
    "bootloader": "systemd-bootctl",
    "config_version": "2.6.0",
    "debug": ${DEBUG:-false},
    "disk_config": {
        "config_type": "manual_partitioning",
        "device_modifications": []
    },
    "hostname": "${HOSTNAME:-phoenix}",
    "kernels": [
        "linux",
        "linux-lts"
    ],
    "locale_config": {
        "kb_layout": "${KEYMAP:-fr}",
        "sys_enc": "UTF-8",
        "sys_lang": "$(echo ${LOCALE:-en_US.UTF-8} | cut -d'.' -f1)"
    },
    "mirror_config": {
        "custom_mirrors": [],
        "mirror_regions": {
            "Worldwide": [
                "https://mirror.rackspace.com/archlinux/\$repo/os/\$arch",
                "https://mirror.leaseweb.net/archlinux/\$repo/os/\$arch"
            ]
        }
    },
    "network_config": {
        "type": "nm"
    },
    "no_pkg_lookups": false,
    "ntp": true,
    "offline": false,
    "packages": [
        "base-devel",
        "git",
        "openssh",
        "reflector",
        "networkmanager",
        "sudo",
        "neovim",
        "htop",
        "curl",
        "wget",
        "tmux"
    ],
    "parallel downloads": ${PARALLEL_DOWNLOADS:-5},
    "profile_config": null,
    "script": "guided",
    "silent": false,
    "swap": ${ENABLE_SWAP:-true},
    "timezone": "${TIMEZONE:-Europe/Paris}",
    "version": "2.6.0"
}
EOF
}

# Clean generated profile files
clean_generated_files() {
    log_info "Cleaning generated profile configuration files..."
    
    local files_to_clean=(
        "$PROJECT_ROOT/configs/profiles/*/ansible/vars.yml"
        "$PROJECT_ROOT/configs/profiles/*/archinstall/user_configuration.json"
        "$PROJECT_ROOT/configs/ansible/group_vars/all/vars.yml"
    )
    
    for file_pattern in "${files_to_clean[@]}"; do
        if [[ "$file_pattern" == *"*"* ]]; then
            # Handle glob patterns
            for file in $file_pattern; do
                if [[ -f "$file" ]]; then
                    rm "$file"
                    log_info "Removed: $file"
                fi
            done
        else
            # Handle exact file paths
            if [[ -f "$file_pattern" ]]; then
                rm "$file_pattern"
                log_info "Removed: $file_pattern"
            fi
        fi
    done
    
    log_success "Generated files cleanup complete"
}

# Check configuration consistency
check_consistency() {
    log_info "Checking configuration consistency between bootstrap and deployment configs..."
    
    # Load both configurations
    local bootstrap_vars=()
    local deploy_vars=()
    
    # Extract variables from bootstrap config
    while IFS='=' read -r key value; do
        [[ $key =~ ^[[:space:]]*# ]] && continue
        [[ -z $key ]] && continue
        key=$(echo "$key" | tr -d ' ')
        bootstrap_vars+=("$key")
    done < "$BOOTSTRAP_CONFIG"
    
    # Extract variables from deploy config  
    while IFS='=' read -r key value; do
        [[ $key =~ ^[[:space:]]*# ]] && continue
        [[ -z $key ]] && continue
        key=$(echo "$key" | tr -d ' ')
        deploy_vars+=("$key")
    done < "$DEPLOY_CONFIG"
    
    # Check for common variables that might be duplicated
    local common_vars=("HOSTNAME" "USER_NAME" "PROFILE")
    local inconsistencies=0
    
    for var in "${common_vars[@]}"; do
        if [[ " ${bootstrap_vars[*]} " =~ " $var " ]] && [[ " ${deploy_vars[*]} " =~ " $var " ]]; then
            log_warning "Variable $var exists in both bootstrap and deployment configs"
            log_info "Consider using sync-settings to synchronize common values"
            ((inconsistencies++))
        fi
    done
    
    if [[ $inconsistencies -eq 0 ]]; then
        log_success "No configuration inconsistencies detected"
    else
        log_warning "Found $inconsistencies potential inconsistencies"
    fi
}

# Show usage information
show_usage() {
    cat << EOF
Configuration Manager - Two-File Configuration System

USAGE:
    $(basename "$0") COMMAND

COMMANDS:
    validate-bootstrap   Validate bootstrap configuration (bootstrap.conf)
    validate-deploy      Validate deployment configuration (config/deploy.conf)
    validate-all         Validate both configuration files
    sync-settings        Sync common settings from bootstrap to deployment config
    generate-profiles    Generate profile-specific configuration files
    clean-generated      Remove all generated profile configuration files
    check-consistency    Check for configuration inconsistencies
    help                 Show this help message

DESCRIPTION:
    This script manages a two-file configuration system:
    
    1. bootstrap.conf - Contains ONLY information needed before downloading
       the repository (repo URL, basic identity, network, profile selection)
       
    2. config/deploy.conf - Contains detailed deployment settings used after
       the repository is downloaded (security, packages, desktop, etc.)
       
    This eliminates redundancy while maintaining clear separation of concerns.

EXAMPLES:
    $(basename "$0") validate-all       # Validate both config files
    $(basename "$0") sync-settings      # Sync common settings
    $(basename "$0") generate-profiles  # Generate profile configs

WORKFLOW:
    1. Edit bootstrap.conf with basic settings
    2. Edit config/deploy.conf with detailed deployment settings  
    3. Run validate-all to check configuration
    4. Use sync-settings to keep common values synchronized
    5. Generate profile-specific configs as needed

EOF
}

# Main function
main() {
    case "${1:-}" in
        validate-bootstrap)
            validate_bootstrap_config
            ;;
        validate-deploy)
            validate_deploy_config
            ;;
        validate-all)
            local bootstrap_valid=true
            local deploy_valid=true
            
            validate_bootstrap_config || bootstrap_valid=false
            validate_deploy_config || deploy_valid=false
            
            if [[ "$bootstrap_valid" == true ]] && [[ "$deploy_valid" == true ]]; then
                log_success "All configuration validation passed"
                exit 0
            else
                log_error "Configuration validation failed"
                exit 1
            fi
            ;;
        sync-settings)
            sync_common_settings
            ;;
        generate-profiles)
            generate_profile_configs
            ;;
        clean-generated)
            clean_generated_files
            ;;
        check-consistency)
            check_consistency
            ;;
        help|--help|-h)
            show_usage
            ;;
        "")
            log_error "No command specified"
            show_usage
            exit 1
            ;;
        *)
            log_error "Unknown command: $1"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi