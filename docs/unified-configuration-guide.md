# Dynamic Configuration System

The Arch Linux Desktop Automation project now uses a **revolutionary dynamic configuration system** that generates Ansible configurations automatically from a single source of truth using template-based generation.

## Overview

The new dynamic system features:
- **Single Source of Truth**: `config/deploy.conf` - All deployment settings
- **Template Engine**: `configs/ansible/templates/` - Jinja2 templates for config generation
- **Configuration Generator**: `scripts/utils/config_generator.sh` - Dynamic config generation
- **Generated Files**: Ansible configurations are generated automatically from templates

### Configuration Flow

1. **Deploy Configuration**: Edit `config/deploy.conf` with all deployment settings
2. **Template Processing**: Generator processes Jinja2 templates with variables from deploy.conf
3. **File Generation**: Creates inventory, group_vars, and host_vars files
4. **Ansible Deployment**: Uses generated configurations for deployment

## Master Configuration File

The master configuration file `config/deploy.conf` contains all configuration parameters organized into logical sections:

### Core System Settings
```bash
HOSTNAME="phoenix"                    # Computer name
USERNAME="lyeosmaouli"               # Primary user
TIMEZONE="Europe/Paris"              # System timezone
LOCALE="en_US.UTF-8"                # System language
KEYMAP="fr"                          # Keyboard layout
DEPLOYMENT_PROFILE="work"            # Profile: work|personal|development
```

### Security Configuration
```bash
DISK_ENCRYPTION=true                 # Enable LUKS encryption
PASSWORD_MODE="generate"             # Password handling
ENABLE_FIREWALL=true                 # Enable UFW firewall
ENABLE_FAIL2BAN=true                # Enable intrusion prevention
ENABLE_AUDIT=true                   # Enable security auditing
```

### Desktop Environment
```bash
DESKTOP_SESSION="hyprland"          # Desktop environment
DISPLAY_MANAGER="sddm"              # Login manager
AUDIO_SYSTEM="pipewire"             # Audio system
DESKTOP_THEME="catppuccin-mocha"    # Color theme
```

### Hardware & Performance
```bash
FILESYSTEM="ext4"                    # Root filesystem
BOOTLOADER="systemd-boot"           # Boot manager
ENABLE_HARDWARE_ACCEL=true          # GPU acceleration
PARALLEL_JOBS=0                     # Auto-detect CPU cores
```

## Configuration Manager

The configuration manager script handles all configuration file generation:

### Commands

```bash
# Generate all configuration files from master config
./scripts/utils/config_manager.sh generate

# Validate master configuration
./scripts/utils/config_manager.sh validate

# Remove all generated configuration files
./scripts/utils/config_manager.sh clean

# Show help
./scripts/utils/config_manager.sh help
```

### Makefile Integration

```bash
# Configuration management
make config-generate    # Generate all config files
make config-validate    # Validate master config
make config-clean       # Remove generated files
```

## Generated Configuration Files

The configuration manager automatically generates the following files:

### 1. Bootstrap Configuration (`bootstrap.conf`)
```bash
# Generated for bootstrap.sh script
HOSTNAME=phoenix
USERNAME=lyeosmaouli
TIMEZONE=Europe/Paris
PROFILE=work
ENABLE_ENCRYPTION=true
```

### 2. Deployment Configuration (`config/deploy.conf`)
```bash
# Generated for deploy.sh script
USER_NAME="lyeosmaouli"
PASSWORD_MODE="generate"
HOSTNAME="phoenix"
ENCRYPTION_ENABLED=true
DESKTOP_SESSION="hyprland"
```

### 3. Ansible Variables (`configs/ansible/group_vars/all/vars.yml`)
```yaml
# Generated for Ansible playbooks
system:
  hostname: "phoenix"
  timezone: "Europe/Paris"
  locale: "en_US.UTF-8"
desktop:
  environment: hyprland
  display_manager: sddm
```

### 4. Profile Variables (`configs/profiles/work/ansible/vars.yml`)
```yaml
# Generated for profile-specific Ansible variables
profile_name: "work"
system:
  hostname: "phoenix"
security:
  firewall:
    enabled: true
```

### 5. Archinstall Configuration (`configs/profiles/work/archinstall/user_configuration.json`)
```json
{
    "hostname": "phoenix",
    "!users": [{"username": "lyeosmaouli", "sudo": true}],
    "timezone": "Europe/Paris",
    "bootloader": "systemd-bootctl"
}
```

### 6. Example Deployment YAML (`example_deployment_config.yml`)
```yaml
# Generated example configuration
system:
  hostname: "phoenix"
  timezone: "Europe/Paris"
user:
  username: "lyeosmaouli"
```

## Usage Workflow

### 1. Edit Master Configuration
Edit `config/deployment.conf` with your preferred settings:
```bash
# Edit the master configuration
nano config/deployment.conf

# Set your hostname, username, timezone, etc.
HOSTNAME="mycomputer"
USERNAME="myuser"
TIMEZONE="America/New_York"
```

### 2. Generate Configuration Files
Generate all configuration files from the master:
```bash
# Using the configuration manager directly
./scripts/utils/config_manager.sh generate

# Or using the Makefile
make config-generate
```

### 3. Deploy System
Use any deployment method - all will use the consistent configuration:
```bash
# Bootstrap deployment
./bootstrap.sh full

# Direct deployment
./scripts/deploy.sh full

# Ansible deployment
make full-install
```

## Validation

The configuration manager includes built-in validation:

### Automatic Validation
```bash
# Validation is automatically run during generation
make config-generate
```

### Manual Validation
```bash
# Validate configuration only
make config-validate

# Example output:
# [INFO] Loading master configuration
# [SUCCESS] Configuration validation passed
```

### Validation Checks
- **Required Fields**: Ensures all mandatory parameters are set
- **Profile Validation**: Verifies profile is work|personal|development
- **Password Mode**: Validates password mode is env|file|generate|interactive
- **Boolean Values**: Checks all boolean parameters are true|false
- **Format Validation**: Ensures proper parameter formats

## Configuration Profiles

The system supports three deployment profiles:

### Work Profile
- Security-focused configuration
- Business applications (Teams, Slack, etc.)
- Enhanced security settings
- Power management optimized for laptops

### Personal Profile
- Multimedia-focused configuration
- Entertainment applications
- Balanced security and usability
- Gaming support optional

### Development Profile
- Development tools and IDEs
- Container support (Docker, Podman)
- Multiple programming language support
- Advanced terminal and editor configurations

## Migration from Old System

### Automatic Migration
If you have existing configuration files, the system will detect conflicts:

```bash
# The deploy.sh script will warn about outdated configs
[WARNING] Master configuration detected but current config is outdated
[INFO] Run './scripts/utils/config_manager.sh generate' to update
```

### Manual Migration
1. **Backup existing configurations**:
   ```bash
   make backup
   ```

2. **Clean old generated files**:
   ```bash
   make config-clean
   ```

3. **Edit master configuration**:
   ```bash
   nano config/deployment.conf
   ```

4. **Generate new configurations**:
   ```bash
   make config-generate
   ```

## Development Integration

### Pre-commit Hook
Add configuration validation to your git pre-commit hook:
```bash
#!/bin/bash
# .git/hooks/pre-commit
make config-validate || exit 1
```

### CI/CD Integration
Include configuration validation in your CI pipeline:
```yaml
# .github/workflows/test.yml
- name: Validate Configuration
  run: make config-validate
```

## Benefits

### Eliminated Redundancy
- **Before**: 42 duplicate parameters across 6+ files
- **After**: 1 master configuration file

### Single Source of Truth
- All configuration in `config/deployment.conf`
- No more inconsistencies between files
- Easy to understand and maintain

### Automatic Consistency
- All generated files are always in sync
- No possibility of configuration drift
- Validation ensures correctness

### Simplified Maintenance
- Update configuration in one place
- Regenerate all files with one command
- Clear documentation and validation

## Troubleshooting

### Configuration Not Taking Effect
```bash
# Check if configuration files are up to date
make config-validate

# Regenerate all configuration files
make config-generate
```

### Validation Errors
```bash
# Check validation output
make config-validate

# Common issues:
# - Missing required fields
# - Invalid boolean values (use true/false, not yes/no)
# - Invalid profile name (must be work/personal/development)
```

### Generated Files Missing
```bash
# Regenerate all files
make config-generate

# Check for errors in master configuration
make config-validate
```

## Advanced Usage

### Custom Configuration Files
To add support for additional configuration files, edit `scripts/utils/config_manager.sh`:

1. Add a new generate function
2. Call it from `generate_all_configs()`
3. Update the clean function to remove the new file

### Environment-Specific Overrides
You can override specific parameters for different environments:
```bash
# Override for CI/CD
export CI_MODE=true
make config-generate
```

### Template Customization
The configuration manager uses bash heredoc templates. You can customize the generated file formats by editing the generate functions in `config_manager.sh`.

## Security Considerations

### Sensitive Information
- Passwords and keys are never stored in plain text
- Master configuration supports empty values for interactive prompts
- Generated files exclude sensitive data where appropriate

### File Permissions
- Master configuration should be readable only by owner: `chmod 600 config/deployment.conf`
- Generated files maintain appropriate permissions
- Sensitive files are automatically excluded from git

### Validation Security
- Configuration validation prevents common security misconfigurations
- Boolean validation prevents injection attacks
- Path validation ensures safe file locations

## Summary

The unified configuration system provides:
- ✅ **Single source of truth** - All configuration in one file
- ✅ **Eliminated redundancy** - No more duplicate parameters
- ✅ **Automatic consistency** - Generated files always match
- ✅ **Built-in validation** - Prevents configuration errors
- ✅ **Easy maintenance** - Update once, deploy everywhere
- ✅ **Developer friendly** - Clear structure and documentation

This system significantly improves the reliability and maintainability of the Arch Linux Desktop Automation project while reducing the complexity for users and developers.