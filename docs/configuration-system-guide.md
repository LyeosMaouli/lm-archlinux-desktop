# Dynamic Configuration System Guide

The Arch Linux Desktop Automation project uses a **revolutionary dynamic configuration system** that generates Ansible configurations automatically from a single source of truth.

## Overview

The configuration system is designed around a **template-based approach**:

1. **Bootstrap Phase**: Download repository and basic setup using `bootstrap.conf`
2. **Configuration Generation**: Dynamic Ansible config generation from `deploy.conf`
3. **Deployment Phase**: Automated deployment using generated configurations

This results in **dynamic configuration generation with no redundancy**:

| File | Phase | Purpose | Contains |
|------|-------|---------|----------|
| `bootstrap.conf` | Pre-download | Repository access & basic identity | Repo URL, hostname, username, profile, network |
| `config/deploy.conf` | Config Generation | Single source of truth | All deployment settings and template variables |
| `configs/ansible/templates/` | Generation | Template engine | Jinja2 templates for dynamic config generation |
| `configs/ansible/` | Deployment | Generated configs | Dynamically generated Ansible configurations |

## Configuration Files

### 1. Bootstrap Configuration (`bootstrap.conf`)

**Purpose**: Information needed BEFORE downloading the repository

```bash
# Repository Settings (Required)
REPO_URL=https://github.com/LyeosMaouli/lm_archlinux_desktop.git
BRANCH=main

# Basic System Identity (Required for initial setup)
HOSTNAME=phoenix
USERNAME=lyeosmaouli

# Network Configuration (Optional - for automatic setup)
WIFI_SSID=
WIFI_PASSWORD=

# Deployment Profile Selection (Required)
PROFILE=work

# VirtualBox Testing Options (Optional - only for VM testing)
VM_MEMORY=8192
VM_DISK_SIZE=60G
VM_OPTIMIZATION=true
```

**Used by**: `bootstrap.sh` script before repository download

### 2. Deployment Configuration (`config/deploy.conf`)

**Purpose**: Single source of truth for all deployment settings and template variables

```bash
# User Configuration
USER_NAME="lyeosmaouli"
PASSWORD_MODE="generate"
PROFILE="work"

# System Configuration
HOSTNAME="phoenix"
ENCRYPTION_ENABLED=true
FILESYSTEM="ext4"

# Localization Settings
TIMEZONE="Europe/Paris"
KEYMAP="fr"
LOCALE="en_US.UTF-8"

# Security Configuration
ENABLE_FIREWALL=true
ENABLE_FAIL2BAN=true
ENABLE_AUDIT=true
ENABLE_SSH=false

# Desktop Environment Options
DESKTOP_SESSION="hyprland"
DISPLAY_MANAGER="sddm"
AUDIO_SYSTEM="pipewire"
DESKTOP_THEME="catppuccin-mocha"

# Package Management
ENABLE_AUR=true
CUSTOM_PACKAGES=""

# Development Tools
GIT_USERNAME="Lyeos Maouli"
GIT_EMAIL="lyeos@example.com"
GENERATE_SSH_KEYS=true
SSH_KEY_TYPE="ed25519"

# Automation Settings
AUTO_REBOOT=false
SKIP_CONFIRMATIONS=false
DEBUG=false
```

**Used by**: `scripts/utils/config_generator.sh` to generate dynamic Ansible configurations

### 3. Dynamic Configuration Templates (`configs/ansible/templates/`)

**Purpose**: Jinja2 templates for generating Ansible configurations from deploy.conf

```yaml
# Example from group_vars.yml.j2
ansible_user: ${USER_NAME}
ansible_hostname: ${HOSTNAME}
enable_encryption: ${ENCRYPTION_ENABLED}
desktop_session: ${DESKTOP_SESSION}
timezone: ${TIMEZONE}
keymap: ${KEYMAP}
locale: ${LOCALE}
```

**Used by**: `scripts/utils/config_generator.sh` for dynamic configuration generation

### 4. Generated Configurations (`configs/ansible/`)

**Purpose**: Dynamically generated Ansible configurations ready for deployment

- `inventory/localhost.yml` - Generated host inventory
- `group_vars/all/vars.yml` - Generated global variables  
- `host_vars/{hostname}/vars.yml` - Generated host-specific variables

**Used by**: Ansible playbooks during deployment

## Dynamic Configuration Generator

The `scripts/utils/config_generator.sh` script manages the dynamic configuration system:

### Commands

```bash
# Generate Ansible configurations from deploy.conf
./scripts/utils/config_generator.sh --config config/deploy.conf

# Test configuration generation (dry-run)
./scripts/utils/config_generator.sh --config config/deploy.conf --dry-run

# Generate with verbose output
./scripts/utils/config_generator.sh --config config/deploy.conf --verbose

# Generate for specific profile
./scripts/utils/config_generator.sh --config config/deploy.conf --profile work

# Clean generated files
./scripts/utils/config_generator.sh --clean
```

### Integration with Deploy Script

The configuration generator is automatically called by `deploy.sh`:

```bash
# deploy.sh automatically calls config_generator.sh before Ansible
./scripts/deploy.sh full                    # Auto-generates configs
./scripts/deploy.sh full --dry-run          # Test generation + preview deployment
./scripts/deploy.sh full --verbose          # Generate with verbose output
```

## Information Flow

### Bootstrap Workflow
```
1. User downloads: bootstrap.sh + bootstrap.conf
2. User edits: bootstrap.conf (repository, identity, network, profile)
3. Bootstrap script: Uses bootstrap.conf to download repository
4. Repository available: Contains config/deploy.conf with detailed settings
```

### Dynamic Configuration Workflow
```
1. Deploy script: Loads config/deploy.conf from downloaded repository
2. Config generator: Parses deploy.conf and generates Ansible configurations
3. Template processing: Substitutes variables into Jinja2 templates
4. File generation: Creates inventory, group_vars, and host_vars files
5. Ansible deployment: Uses generated configurations for deployment
```

## Configuration Validation

The dynamic configuration system includes comprehensive validation:

### Bootstrap Validation
- **Required fields**: REPO_URL, BRANCH, HOSTNAME, USERNAME, PROFILE
- **Format validation**: URL format, hostname format, username format
- **Value validation**: Profile must be work|personal|development

### Deploy Configuration Validation
- **Required fields**: USER_NAME, PASSWORD_MODE, DESKTOP_SESSION, etc.
- **Boolean validation**: All boolean values must be true|false
- **Enum validation**: PASSWORD_MODE, DESKTOP_SESSION, etc.
- **Numeric validation**: LOG_LEVEL, timeouts, etc.

### Template Generation Validation
- **Variable substitution**: Ensures all template variables are defined
- **Template syntax**: Validates Jinja2 template syntax
- **Output validation**: Validates generated YAML/INI files
- **Profile consistency**: Ensures profile-specific overrides are valid

## Usage Examples

### Basic Setup
```bash
# 1. Edit bootstrap configuration
nano bootstrap.conf

# 2. Edit deployment configuration (after repository download)
nano config/deploy.conf

# 3. Test configuration generation
./scripts/utils/config_generator.sh --config config/deploy.conf --dry-run

# 4. Deploy system (auto-generates configs)
./bootstrap.sh full
```

### Advanced Configuration Management
```bash
# Manual configuration generation
./scripts/utils/config_generator.sh --config config/deploy.conf --verbose

# Test deployment with generated configs
./scripts/deploy.sh full --dry-run

# Clean generated configurations
./scripts/utils/config_generator.sh --clean

# Generate profile-specific configurations
make config-generate-profiles

# Validate specific configuration
make config-validate-deploy
```

### Profile-Based Deployment
```bash
# Set profile in bootstrap.conf
PROFILE=development

# Deployment automatically uses development-specific settings
./bootstrap.sh full
```

## Profile System

The configuration system supports three profiles:

### Work Profile
- **Security**: Enhanced security settings
- **Applications**: Business applications (Teams, Slack, etc.)
- **Power Management**: Laptop optimization
- **Development**: Basic development tools

### Personal Profile
- **Multimedia**: Media applications and codecs
- **Gaming**: Optional gaming support
- **Customization**: Personal theme and settings
- **Social**: Communication applications

### Development Profile
- **Development Tools**: Full programming environment
- **Containers**: Docker, Podman support
- **Multiple Languages**: Python, Node.js, Rust, Go
- **Advanced Tools**: Advanced terminal and editor setup

## Generated Files

The configuration manager automatically generates:

### Profile-Specific Ansible Variables
- `configs/profiles/work/ansible/vars.yml`
- `configs/profiles/personal/ansible/vars.yml`
- `configs/profiles/development/ansible/vars.yml`

### Profile-Specific Archinstall Configurations
- `configs/profiles/work/archinstall/user_configuration.json`
- `configs/profiles/personal/archinstall/user_configuration.json`
- `configs/profiles/development/archinstall/user_configuration.json`

## Best Practices

### Configuration Management
1. **Edit only source files**: Never edit generated files manually
2. **Validate regularly**: Run `make config-validate` after changes
3. **Check consistency**: Use `make config-check` to detect redundancy
4. **Sync when needed**: Use `make config-sync` to synchronize common values

### File Organization
- **Bootstrap settings**: Keep minimal, only pre-download essentials
- **Deployment settings**: Complete and comprehensive configuration
- **Profile-specific**: Use profile system for environment differences
- **Generated files**: Let the system manage these automatically

### Development Workflow
1. **Modify configuration**: Edit bootstrap.conf or config/deploy.conf
2. **Validate changes**: `make config-validate`
3. **Generate profiles**: `make config-generate-profiles` (if needed)
4. **Test deployment**: Use dry-run mode first
5. **Deploy system**: Run actual deployment

## Troubleshooting

### Configuration Validation Errors
```bash
# Check specific configuration
make config-validate-bootstrap
make config-validate-deploy

# Common issues:
# - Missing required fields
# - Invalid boolean values (use true/false)
# - Invalid profile name (work/personal/development)
# - Invalid hostname format
# - Invalid username format
```

### Consistency Issues
```bash
# Check for redundancy
make config-check

# Fix redundancy
make config-sync

# Example output:
# [WARNING] Variable HOSTNAME exists in both configurations
# [INFO] Consider using sync-settings to synchronize common values
```

### Generated File Issues
```bash
# Clean and regenerate
make config-clean
make config-generate-profiles

# Validate generated files work correctly
make config-validate
```

## Migration from Old System

If you have an existing system with redundant configurations:

1. **Backup existing configurations**:
   ```bash
   make backup
   ```

2. **Clean redundant files**:
   ```bash
   make config-clean
   ```

3. **Edit the two main configuration files**:
   ```bash
   nano bootstrap.conf      # Basic settings only
   nano config/deploy.conf  # Detailed settings only
   ```

4. **Validate new configuration**:
   ```bash
   make config-validate
   ```

5. **Generate profile configurations**:
   ```bash
   make config-generate-profiles
   ```

## Summary

The two-file configuration system provides:

✅ **Clear Separation**: Bootstrap vs deployment concerns clearly separated  
✅ **Zero Redundancy**: Each parameter exists in exactly one place  
✅ **Logical Flow**: Information needed when it's needed  
✅ **Easy Maintenance**: Simple to understand and maintain  
✅ **Profile Support**: Environment-specific configurations  
✅ **Validation**: Built-in error checking and consistency validation  
✅ **Automation**: Generated profile-specific configurations  

This approach eliminates configuration redundancy while maintaining the flexibility and power of the deployment system.