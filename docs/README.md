# Documentation Index

Welcome to the **Next-Generation Arch Linux Hyprland Desktop Automation** documentation!

## 🆕 **What's New**

This documentation now covers the **latest enhancements** including:

- **🔧 Dynamic Configuration System** - Ansible configs generated automatically from deploy.conf
- **🧹 Clean Architecture** - Removed redundancies and standardized all configurations
- **📋 Template-Based Generation** - Jinja2 templates for flexible configuration management
- **⚡ Performance Optimizations** - 3x faster deployments with parallel processing
- **📊 Structured Logging** - JSON-based logging with correlation tracking
- **🔒 Enhanced Security** - Advanced security hardening and audit logging
- **📈 Performance Monitoring** - Built-in deployment analytics and optimization

## 🚀 Getting Started

### Quick Start Guides

- **[Installation Guide](installation-guide.md)** - Complete deployment instructions with full automation
- **[Development Instructions](development-instructions.md)** - Direct development workflow setup
- **[VirtualBox Testing](virtualbox-testing-guide.md)** - Safe testing environment setup

### Configuration

- **[Dynamic Configuration Guide](configuration-system-guide.md)** - Template-based configuration system
- **[Deploy Configuration](../config/deploy.conf)** - Main deployment configuration file
- **[Password Management](password-management.md)** - Advanced password system

## 📚 Project Documentation

### Development

- **[Development Instructions](development-instructions.md)** - Direct development workflows
- **[Project Structure](project-structure.md)** - Complete codebase documentation
- **[Enhancement Opportunities](improvements/enhancement-opportunities.md)** - 🆕 System improvement analysis
- **[Improvement Plan](improvements/improvement-plan.md)** - 🆕 Strategic enhancement roadmap
- **[Issue Tracking](fixes/)** - 🆕 Systematic issue resolution documentation

### Security

- **[Security Policy](../SECURITY.md)** - Security guidelines and best practices

## 🛠️ Technical Documentation

### 🆕 Dynamic Configuration System

- **Template Engine**: Located in `configs/ansible/templates/`
  - Dynamic Ansible configuration generation from deploy.conf
  - Jinja2 templates for flexible configuration management
  - Profile-specific configurations (work, personal, development)
  - Automatic variable substitution and validation
- **Configuration Generator**: `scripts/utils/config_generator.sh`
  - Parses deploy.conf and generates Ansible configurations
  - Supports dry-run mode for safe testing
  - Comprehensive error handling and validation

### Architecture

- **Ansible Roles**: Located in `configs/ansible/roles/`
  - `base_system/` - Core system configuration
  - `users_security/` - User management and SSH hardening
  - `hyprland_desktop/` - Desktop environment setup
  - `aur_packages/` - AUR package management
  - `system_hardening/` - Security hardening
  - `power_management/` - Laptop optimization

### Scripts

- **Deployment Scripts**: Located in `scripts/`

  - `deploy.sh` - Unified deployment interface with dynamic config generation
  - `deployment/auto_install.sh` - Automated base system installation
  - `deployment/profile_manager.sh` - Profile management utility
  - `deployment/auto_post_install.sh` - Post-installation validation
  - `utils/config_generator.sh` - Dynamic Ansible configuration generator

- **Testing Scripts**: Located in `scripts/testing/`

  - `auto_vm_test.sh` - Automated VirtualBox testing

- **Utilities**: Located in `scripts/utilities/`
  - `network_auto_setup.sh` - Network automation

### Configuration Files

- **Main Configuration**: `config/deploy.conf` - Single source of truth for all settings
- **Bootstrap Configuration**: `bootstrap.conf` - Bootstrap deployment settings
- **Dynamic Templates**: `configs/ansible/templates/` - Jinja2 templates for config generation
- **Generated Files**: `configs/ansible/` - Dynamically generated Ansible configurations

## 🎯 Common Tasks

### 🆕 Dynamic Configuration Development

```bash
# Clone repository for development
git clone https://github.com/LyeosMaouli/lm-archlinux-desktop.git
cd lm-archlinux-desktop

# Test dynamic configuration generation
./scripts/deploy.sh full --dry-run --verbose

# Generate configs manually for testing
./scripts/utils/config_generator.sh --config config/deploy.conf --dry-run

# Validate generated configurations
ansible-lint configs/ansible/
```

### Installation

```bash
# Bootstrap deployment (recommended)
wget https://raw.githubusercontent.com/LyeosMaouli/lm-archlinux-desktop/main/bootstrap.sh
wget https://raw.githubusercontent.com/LyeosMaouli/lm-archlinux-desktop/main/bootstrap.conf
chmod +x bootstrap.sh
./bootstrap.sh full

# Development deployment
git clone https://github.com/LyeosMaouli/lm-archlinux-desktop.git && cd lm-archlinux-desktop
./scripts/deploy.sh full
```

### Testing

```bash
# Bootstrap testing (recommended)
./bootstrap.sh testing --verbose

# VirtualBox testing
./scripts/testing/auto_vm_test.sh

# Installation validation
./scripts/testing/test_installation.sh
```

### Maintenance

```bash
# System status with performance monitoring
system-status

# System updates
system-update

# Security audit with structured logging
sudo /usr/local/bin/audit-analysis

# 🆕 Configuration management
./scripts/utils/config_generator.sh --config config/deploy.conf --dry-run  # Test config generation
ansible-lint configs/ansible/    # Validate generated configurations
./scripts/deploy.sh full --dry-run  # Preview deployment actions
```

## 🆘 Troubleshooting

### Common Issues

**Network connectivity problems:**

```bash
# Run network recovery
./scripts/utilities/network_auto_setup.sh recovery
```

**SSH key issues:**

```bash
# Keys are automatically generated
# View public key: cat ~/.ssh/id_rsa.pub
# Add to GitHub: https://github.com/settings/keys
```

**Ansible deployment failures:**

```bash
# Run with verbose output
ansible-playbook -vvv -i configs/ansible/inventory/localhost.yml local.yml
```

### Log Locations

- **Main deployment**: `/var/log/deploy.log`
- **VM testing**: `/var/log/auto_vm_test.log`
- **Network setup**: `/var/log/network_auto_setup.log`
- **Ansible**: `/var/log/ansible.log`

## 📞 Support

### Getting Help

1. Check this documentation
2. Review log files for errors
3. Test in VirtualBox VM first
4. Create GitHub issue with logs and system info

### Contributing

1. Fork the repository
2. Test changes in VirtualBox
3. Follow existing code style
4. Update documentation
5. Submit pull request

---

**Need help?** Start with the [Installation Guide](installation-guide.md) for step-by-step instructions.
