#!/bin/bash
# Arch Linux Hyprland Desktop Automation Bootstrap Script
# This script downloads, verifies, and runs the complete automation system
# Usage: ./bootstrap.sh [full|testing|install|desktop|security] [options]

set -euo pipefail

# Script metadata
BOOTSTRAP_VERSION="1.0.0"
SCRIPT_NAME="Arch Linux Hyprland Bootstrap"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
DEFAULT_REPO_URL="https://github.com/LyeosMaouli/lm-archlinux-desktop.git"
DEFAULT_BRANCH="main"
WORK_DIR="/tmp/arch_automation_$$"
CONFIG_FILE="bootstrap.conf"
LOG_FILE="/var/log/bootstrap.log"

# Runtime variables
REPO_URL=""
BRANCH=""
DEPLOYMENT_TYPE=""
VERBOSE=false
DRY_RUN=false
SKIP_VERIFICATION=false

# Logging setup
setup_logging() {
    mkdir -p "$(dirname "$LOG_FILE")"
    exec > >(tee -a "$LOG_FILE")
    exec 2> >(tee -a "$LOG_FILE" >&2)
    echo "=== Bootstrap started: $(date) ===" >> "$LOG_FILE"
}

# Logging functions
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    log "ERROR: $1"
    exit 1
}

success() {
    echo -e "${GREEN}[OK] $1${NC}"
    log "SUCCESS: $1"
}

info() {
    echo -e "${CYAN}INFO: $1${NC}"
    log "INFO: $1"
}

warn() {
    echo -e "${YELLOW}WARNING: $1${NC}"
    log "WARNING: $1"
}

# Show banner
show_banner() {
    echo -e "${BLUE}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════╗
║             Arch Linux Hyprland Desktop Automation              ║
║                      Bootstrap Script v1.0.0                    ║
╚══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo "Streamlined deployment with automated repository management"
    echo
}

# Show usage
show_usage() {
    cat << EOF
Usage: $0 [DEPLOYMENT_TYPE] [OPTIONS]

DEPLOYMENT TYPES:
  full        Complete system deployment (default)
  testing     VirtualBox testing deployment (uses 'full' command)
  install     Base system installation only
  desktop     Desktop environment only
  security    Security hardening only

OPTIONS:
  --config FILE     Use custom configuration file (default: bootstrap.conf)
  --repo URL        Override repository URL
  --branch NAME     Override branch name (default: main)
  --dry-run         Preview actions without executing
  --verbose         Enable verbose output
  --skip-verify     Skip repository verification (not recommended)
  --help           Show this help message

EXAMPLES:
  $0 full                          # Complete deployment with default config
  $0 testing --verbose             # VirtualBox testing with verbose output
  $0 desktop --config custom.conf # Desktop only with custom config
  $0 --dry-run full               # Preview full deployment

QUICK START:
  1. Download this script and bootstrap.conf
  2. Edit bootstrap.conf with your preferences
  3. Run: ./bootstrap.sh full

EOF
}

# Load configuration
load_config() {
    local config_file="${1:-$CONFIG_FILE}"
    
    if [[ ! -f "$config_file" ]]; then
        warn "Configuration file not found: $config_file"
        info "Creating default configuration file..."
        create_default_config "$config_file"
    fi
    
    info "Loading configuration from: $config_file"
    
    # Source the configuration file safely
    while IFS='=' read -r key value; do
        # Skip comments and empty lines
        [[ $key =~ ^[[:space:]]*# ]] && continue
        [[ -z $key ]] && continue
        
        # Remove quotes and whitespace
        key=$(echo "$key" | tr -d ' ')
        value=$(echo "$value" | sed 's/^["'"'"']\|["'"'"']$//g' | tr -d ' ')
        
        case "$key" in
            REPO_URL)
                REPO_URL="$value"
                ;;
            BRANCH)
                BRANCH="$value"
                ;;
            HOSTNAME)
                export DEPLOY_HOSTNAME="$value"
                ;;
            USERNAME)
                export DEPLOY_USERNAME="$value"
                ;;
            TIMEZONE)
                export DEPLOY_TIMEZONE="$value"
                ;;
            LOCALE)
                export DEPLOY_LOCALE="$value"
                ;;
            KEYMAP)
                export DEPLOY_KEYMAP="$value"
                ;;
            PROFILE)
                export DEPLOY_PROFILE="$value"
                ;;
            ENABLE_ENCRYPTION)
                export DEPLOY_ENCRYPTION="$value"
                ;;
            AUTO_REBOOT)
                export DEPLOY_AUTO_REBOOT="$value"
                ;;
        esac
    done < "$config_file"
    
    # Set defaults if not specified
    REPO_URL="${REPO_URL:-$DEFAULT_REPO_URL}"
    BRANCH="${BRANCH:-$DEFAULT_BRANCH}"
    
    if [[ "$VERBOSE" == true ]]; then
        info "Configuration loaded:"
        info "  Repository: $REPO_URL"
        info "  Branch: $BRANCH"
        info "  Hostname: ${DEPLOY_HOSTNAME:-default}"
        info "  Profile: ${DEPLOY_PROFILE:-work}"
    fi
}

# Create default configuration file
create_default_config() {
    local config_file="$1"
    
    cat > "$config_file" << 'EOF'
# Arch Linux Hyprland Desktop Automation Configuration
# Edit these values according to your preferences

# Repository Settings
REPO_URL=https://github.com/LyeosMaouli/lm-archlinux-desktop.git
BRANCH=main

# System Configuration
HOSTNAME=phoenix
USERNAME=lyeosmaouli
TIMEZONE=Europe/Paris
LOCALE=en_US.UTF-8
KEYMAP=fr

# Deployment Profile (work, personal, development)
PROFILE=work

# Security Settings
ENABLE_ENCRYPTION=true

# Automation Settings
AUTO_REBOOT=true

# Password Management
# Leave empty to use interactive prompts or auto-generation
USER_PASSWORD=
ROOT_PASSWORD=
ENCRYPTION_PASSPHRASE=

# Network Configuration (usually auto-detected)
WIFI_SSID=
WIFI_PASSWORD=

# Optional: Custom package lists (comma-separated)
EXTRA_PACKAGES=
AUR_PACKAGES=

# VirtualBox Testing Options (when using 'testing' deployment type)
VM_MEMORY=8192
VM_DISK_SIZE=60G
VM_OPTIMIZATION=true
EOF
    
    success "Created default configuration file: $config_file"
    info "Please edit this file with your preferences before running the deployment"
}

# Verify system prerequisites
verify_prerequisites() {
    info "Verifying system prerequisites..."
    
    # Check if running as root when needed for installation
    if [[ "$DEPLOYMENT_TYPE" == "install" || "$DEPLOYMENT_TYPE" == "full" ]] && [[ $EUID -ne 0 ]]; then
        error "Root privileges required for system installation. Run with sudo or as root."
    fi
    
    # Check network connectivity (try curl first, then ping as fallback)
    if command -v curl >/dev/null 2>&1; then
        if ! curl -s --connect-timeout 5 --max-time 10 https://www.google.com >/dev/null 2>&1; then
            error "No network connectivity. Please check your internet connection."
        fi
    elif command -v ping >/dev/null 2>&1; then
        if ! ping -c 1 -W 5 8.8.8.8 >/dev/null 2>&1; then
            error "No network connectivity. Please check your internet connection."
        fi
    else
        warn "Cannot verify network connectivity - no curl or ping available"
    fi
    
    # Check available disk space (at least 2GB for downloads)
    local available_space
    available_space=$(df /tmp --output=avail | tail -1)
    local required_space=2097152  # 2GB in KB
    
    if [[ "$VERBOSE" == true ]]; then
        info "Disk space check: Available: ${available_space}KB, Required: ${required_space}KB"
    fi
    
    if [[ "$available_space" -lt "$required_space" ]]; then
        local available_gb=$((available_space / 1048576))
        error "Insufficient disk space. At least 2GB required in /tmp (currently ${available_gb}GB available)"
    fi
    
    # Check if git is available or can be installed
    if ! command -v git >/dev/null 2>&1; then
        info "Git not found, will be installed automatically"
    fi
    
    success "Prerequisites check passed"
}

# Download and verify repository
download_repository() {
    info "Downloading repository from: $REPO_URL (branch: $BRANCH)"
    
    # Clean work directory
    rm -rf "$WORK_DIR"
    mkdir -p "$WORK_DIR"
    cd "$WORK_DIR"
    
    # Install git if needed
    if ! command -v git >/dev/null 2>&1; then
        info "Installing git..."
        if command -v pacman >/dev/null 2>&1; then
            pacman -Sy --noconfirm git
        else
            error "Cannot install git - pacman not available"
        fi
    fi
    
    # Clone repository
    if [[ "$VERBOSE" == true ]]; then
        git clone --branch "$BRANCH" --depth 1 "$REPO_URL" automation || error "Failed to clone repository"
    else
        git clone --branch "$BRANCH" --depth 1 "$REPO_URL" automation >/dev/null 2>&1 || error "Failed to clone repository"
    fi
    
    cd automation
    success "Repository downloaded successfully"
}

# Verify repository integrity
verify_repository() {
    if [[ "$SKIP_VERIFICATION" == true ]]; then
        warn "Skipping repository verification (not recommended)"
        return
    fi
    
    info "Verifying repository integrity..."
    
    # Check essential files exist
    local essential_files=(
        "scripts/deploy.sh"
        "local.yml"
        "configs/ansible/ansible.cfg"
        "requirements.txt"
    )
    
    for file in "${essential_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            error "Essential file missing: $file"
        fi
    done
    
    # Verify script permissions
    if [[ ! -x "scripts/deploy.sh" ]]; then
        chmod +x scripts/deploy.sh
    fi
    
    # Basic security check - ensure no suspicious files
    local suspicious_patterns=(
        "*.tmp"
        "*.bak"
        "id_rsa"
        "id_ed25519"
        "*.key"
        "password*"
    )
    
    for pattern in "${suspicious_patterns[@]}"; do
        if find . -name "$pattern" -type f | grep -q .; then
            warn "Found potentially suspicious files matching: $pattern"
        fi
    done
    
    # Verify repository origin (basic check)
    local origin_url
    origin_url=$(git remote get-url origin 2>/dev/null || echo "")
    if [[ "$origin_url" != "$REPO_URL" ]]; then
        warn "Repository origin mismatch. Expected: $REPO_URL, Got: $origin_url"
    fi
    
    success "Repository integrity verified"
}

# Run deployment
run_deployment() {
    info "Starting $DEPLOYMENT_TYPE deployment..."
    
    # Map deployment types to deploy.sh commands
    local deploy_command=""
    case "$DEPLOYMENT_TYPE" in
        full)
            deploy_command="full"
            ;;
        testing)
            # For testing, use full deployment with dry-run if not already set
            deploy_command="full"
            info "Testing deployment will use 'full' command"
            ;;
        install)
            deploy_command="install"
            ;;
        desktop)
            deploy_command="desktop"
            ;;
        security)
            deploy_command="security"
            ;;
        *)
            error "Unknown deployment type: $DEPLOYMENT_TYPE"
            ;;
    esac
    
    # Prepare deployment command
    local deploy_cmd="./scripts/deploy.sh $deploy_command"
    
    # Add common options
    if [[ "$DRY_RUN" == true ]]; then
        deploy_cmd="$deploy_cmd --dry-run"
    fi
    
    if [[ "$VERBOSE" == true ]]; then
        deploy_cmd="$deploy_cmd --verbose"
    fi
    
    # Add configuration options from environment variables
    if [[ -n "${DEPLOY_HOSTNAME:-}" ]]; then
        deploy_cmd="$deploy_cmd --hostname '$DEPLOY_HOSTNAME'"
    fi
    
    if [[ -n "${DEPLOY_PROFILE:-}" ]]; then
        deploy_cmd="$deploy_cmd --profile '$DEPLOY_PROFILE'"
    fi
    
    # Set password mode based on configuration
    if [[ -n "${USER_PASSWORD:-}" ]]; then
        export DEPLOY_USER_PASSWORD="$USER_PASSWORD"
        deploy_cmd="$deploy_cmd --password env"
    else
        deploy_cmd="$deploy_cmd --password generate"
    fi
    
    info "Executing: $deploy_cmd"
    
    if [[ "$DRY_RUN" == true ]]; then
        info "DRY RUN - Would execute deployment command"
        info "Working directory: $(pwd)"
        info "Available files: $(ls -la | head -5)"
        return
    fi
    
    # Execute deployment
    eval "$deploy_cmd" || error "Deployment failed"
    
    success "$DEPLOYMENT_TYPE deployment completed successfully"
}

# Cleanup function
cleanup() {
    if [[ -d "$WORK_DIR" ]]; then
        info "Cleaning up temporary files..."
        rm -rf "$WORK_DIR"
    fi
}

# Handle signals
trap cleanup EXIT
trap 'error "Script interrupted"' INT TERM

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            full|testing|install|desktop|security)
                DEPLOYMENT_TYPE="$1"
                shift
                ;;
            --config)
                CONFIG_FILE="$2"
                shift 2
                ;;
            --repo)
                REPO_URL="$2"
                shift 2
                ;;
            --branch)
                BRANCH="$2"
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
            --skip-verify)
                SKIP_VERIFICATION=true
                shift
                ;;
            --help|-h)
                show_usage
                exit 0
                ;;
            *)
                error "Unknown option: $1. Use --help for usage information."
                ;;
        esac
    done
    
    # Set default deployment type
    DEPLOYMENT_TYPE="${DEPLOYMENT_TYPE:-full}"
}

# Main function
main() {
    setup_logging
    show_banner
    
    # Parse arguments
    parse_arguments "$@"
    
    info "Starting $SCRIPT_NAME v$BOOTSTRAP_VERSION"
    info "Deployment type: $DEPLOYMENT_TYPE"
    
    # Load configuration
    load_config "$CONFIG_FILE"
    
    # Run deployment steps
    verify_prerequisites
    download_repository
    verify_repository
    run_deployment
    
    # Final message
    echo
    success "Bootstrap completed successfully!"
    info "Check the logs at: $LOG_FILE"
    
    if [[ "$DEPLOYMENT_TYPE" == "testing" ]]; then
        info "VirtualBox testing deployment complete"
        info "Check ~/vm_test_report.txt for detailed results"
    elif [[ "$DEPLOYMENT_TYPE" == "full" && "${DEPLOY_AUTO_REBOOT:-true}" == "true" ]]; then
        info "System will reboot in 10 seconds..."
        info "Press Ctrl+C to cancel reboot"
        sleep 10 && reboot || true
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi