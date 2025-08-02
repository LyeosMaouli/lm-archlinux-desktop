# Arch Linux Hyprland Automation - Complete Project Structure

🚀 **DRAMATICALLY SIMPLIFIED PROJECT STRUCTURE** - A comprehensive enterprise-grade automation system with **unified deployment interface**, **advanced password management**, and **streamlined architecture**.

## ✨ Project Overview

This project has been **dramatically refactored** for simplicity while maintaining enterprise capabilities:

- **Dynamic Configuration System**: Ansible configs generated automatically from deploy.conf
- **Clean Architecture**: Removed redundancies and standardized all configurations
- **Template-Based System**: Jinja2 templates for flexible configuration management
- **Unified Interface**: Multiple confusing entry points → 1 clear deployment command (`deploy.sh`)
- **Advanced Hybrid Password Management** with 4 secure methods
- **GitHub CI/CD Integration** for enterprise deployment
- **Comprehensive Security Framework** with enterprise-grade hardening
- **Complete Power Management** for laptop optimization

## 📁 Complete Directory Structure

```
lm-archlinux-desktop/
├── 📄 README.md                     # Revolutionary project overview
├── 📄 LICENSE                       # MIT license
├── 📄 .gitignore                    # Version control exclusions
├── 📄 requirements.txt              # Python dependencies
├── 📄 Makefile                      # Build automation and shortcuts
├── 📄 SECURITY.md                   # Security policies and guidelines
├── 📄 local.yml                     # Main Ansible playbook (ansible-pull entry point)
│
├── 📂 docs/                         # 📚 Comprehensive Documentation
│   ├── 📄 README.md                 # Documentation index
│   ├── 📄 installation-guide.md     # Complete installation methods
│   ├── 📄 password-management.md    # Advanced password system guide
│   ├── 📄 github-password-storage.md # GitHub Secrets integration
│   ├── 📄 target-computer-deployment.md # Target deployment workflow
│   ├── 📄 project-structure.md      # This file - complete project overview
│   ├── 📄 virtualbox-testing-guide.md # VM testing environment
│   ├── 📄 troubleshooting.md        # Common issues and solutions
│   └── 📂 plans/
│       └── 📄 implementation-plan.md # Project completion status
│
├── 📄 bootstrap.conf                # Bootstrap deployment configuration
│
├── 📂 config/                       # 🎯 Centralized Configuration
│   ├── 📄 deploy.conf               # Main deployment configuration (ALL SETTINGS)
│   └── 📄 example.deploy.conf       # Example configuration with mock data
│
├── 📂 configs/                      # 🔧 Dynamic Configuration Management
│   └── 📂 ansible/                  # Ansible automation framework
│       ├── 📄 ansible.cfg           # Ansible configuration
│       ├── 📄 requirements.yml      # External role dependencies
│       ├── 📂 templates/            # 🆕 Dynamic Configuration Templates
│       │   ├── 📄 group_vars.yml.j2 # Group variables template
│       │   ├── 📄 host_vars.yml.j2  # Host variables template
│       │   └── 📄 inventory.yml.j2  # Inventory template
│       ├── 📂 inventory/            # Generated host inventory definitions
│       ├── 📂 group_vars/           # Generated global variable definitions
│       ├── 📂 host_vars/            # Generated host-specific variables
│       ├── 📂 playbooks/            # 🎭 Deployment Playbooks
│       │   ├── 📄 site.yml          # Master orchestration playbook
│       │   ├── 📄 bootstrap.yml     # Initial system setup
│       │   ├── 📄 desktop.yml       # Desktop environment deployment
│       │   ├── 📄 security.yml      # Security hardening
│       │   └── 📄 maintenance.yml   # System maintenance tasks
│       │
│       └── 📂 roles/                # 🎪 Ansible Roles
│           ├── 📂 base_system/      # 🏗️ Core System Configuration
│           │   ├── 📂 defaults/
│           │   ├── 📂 files/
│           │   ├── 📂 handlers/
│           │   ├── 📂 tasks/
│           │   ├── 📂 templates/
│           │   └── 📂 vars/
│           │
│           ├── 📂 users_security/   # 👤 User Management & SSH Hardening
│           │   ├── 📂 defaults/
│           │   ├── 📂 files/
│           │   ├── 📂 handlers/
│           │   ├── 📂 tasks/
│           │   ├── 📂 templates/
│           │   └── 📂 vars/
│           │
│           ├── 📂 hyprland_desktop/ # 🖥️ Wayland Desktop Environment
│           │   ├── 📂 defaults/
│           │   ├── 📂 files/
│           │   ├── 📂 handlers/
│           │   ├── 📂 tasks/
│           │   ├── 📂 templates/
│           │   │   ├── 📂 hyprland/
│           │   │   ├── 📂 waybar/
│           │   │   ├── 📂 wofi/
│           │   │   ├── 📂 kitty/
│           │   │   └── 📂 mako/
│           │   └── 📂 vars/
│           │
│           ├── 📂 aur_packages/     # 📦 AUR Package Management
│           │   ├── 📂 defaults/
│           │   ├── 📂 files/
│           │   ├── 📂 handlers/
│           │   ├── 📂 tasks/
│           │   ├── 📂 templates/
│           │   └── 📂 vars/
│           │
│           ├── 📂 system_hardening/ # 🛡️ Security Hardening
│           │   ├── 📂 defaults/
│           │   ├── 📂 files/
│           │   ├── 📂 handlers/
│           │   ├── 📂 tasks/
│           │   ├── 📂 templates/
│           │   │   ├── 📂 sysctl.d/
│           │   │   ├── 📂 fail2ban/
│           │   │   └── 📂 audit/
│           │   └── 📂 vars/
│           │
│           └── 📂 power_management/ # ⚡ Laptop Power Optimization
│               ├── 📂 defaults/
│               ├── 📂 files/
│               ├── 📂 handlers/
│               ├── 📂 tasks/
│               ├── 📂 templates/
│               └── 📂 vars/
│
├── 📂 scripts/                      # 🚀 Simplified Automation Scripts (60% REDUCTION!)
│   ├── 📄 deploy.sh                 # 🌟 UNIFIED DEPLOYMENT ENTRY POINT
│   │                                #     - Replaces 5 different deployment scripts
│   │                                #     - Commands: install|desktop|security|full
│   │                                #     - Consistent CLI interface across all operations
│   │
│   ├── 📂 utils/                    # 🔧 Single-Purpose Utilities
│   │   ├── 📄 config_generator.sh   # 🆕 Dynamic Ansible configuration generator
│   │   ├── 📄 passwords.sh          # Password management (consolidated 4 scripts)
│   │   ├── 📄 network.sh            # Network configuration and testing
│   │   ├── 📄 hardware.sh           # Hardware detection and validation
│   │   ├── 📄 validation.sh         # System validation and health checks
│   │   └── 📄 profiles.sh           # Profile management and switching
│   │
│   ├── 📂 internal/                 # 🔗 Shared Functions
│   │   └── 📄 common.sh             # Shared functions library (400+ lines)
│   │                                #     - Logging, error handling, user interaction
│   │                                #     - Hardware detection, network testing
│   │                                #     - Configuration management, validation
│   │
│   ├── 📂 deployment/               # 🏗️ Legacy Scripts (with deprecation wrappers)
│   │   ├── 📄 *_wrapper.sh          # Backward compatibility wrappers
│   │   └── 📄 [original scripts]    # Original scripts (deprecated)
│   │
│   ├── 📂 testing/                  # 🧪 Testing & Validation
│   │   ├── 📄 test_installation.sh  # Installation validation
│   │   └── 📄 auto_vm_test.sh       # VirtualBox automated testing
│   │
│   ├── 📂 maintenance/              # 🔧 System Maintenance
│   │   └── 📄 health_check.sh       # System health monitoring
│   │
│   ├── 📂 security/                 # 🔒 Security Scripts (legacy)
│   └── 📂 utilities/                # 🛠️ Utility Scripts (legacy)
│
├── 📂 config/                       # ⚙️ Dynamic Configuration System
│   └── 📄 deploy.conf               # Single source of truth (100+ options)
│                                    #     - User configuration with recommendations
│                                    #     - System, network, security settings
│                                    #     - Performance tuning parameters
│                                    #     - Template variables for dynamic generation
│
├── 📂 usb-deployment/               # 📱 Revolutionary USB Deployment System
│   ├── 📄 README.md                 # USB deployment guide
│   ├── 📄 usb-deploy.sh             # Main USB deployment script
│   ├── 📄 usb-config-template.sh    # Configuration template
│   └── 📂 examples/
│       ├── 📄 basic-config.sh       # Basic deployment configuration
│       ├── 📄 enterprise-config.sh  # Enterprise deployment
│       └── 📄 development-config.sh # Development environment
│
├── 📂 tools/                        # 🔧 System Management Tools
│   ├── 📄 README.md                 # Tools overview and usage
│   ├── 📄 system_info.sh            # Comprehensive system information
│   ├── 📄 package_manager.sh        # Unified package management
│   ├── 📄 hardware_checker.sh       # Hardware compatibility validation
│   └── 📄 backup_manager.sh         # Backup and restore system
│
# Note: Templates are now located within each Ansible role's templates/ directory
# Dynamic Ansible configuration templates are in configs/ansible/templates/
│
├── 📂 files/                        # 📄 Static Files and Assets
│   ├── 📂 wallpapers/              # Desktop wallpapers
│   │   ├── 📄 README.md             # Wallpaper installation guide
│   │   ├── 📂 hyprland/
│   │   ├── 📂 nature/
│   │   └── 📂 abstract/
│   ├── 📂 themes/                  # GTK and icon themes
│   │   ├── 📄 install-themes.sh     # Theme installation script
│   │   └── 📄 catppuccin-setup.md   # Catppuccin theme setup
│   ├── 📂 fonts/                   # Font files and setup
│   │   ├── 📄 install-fonts.sh      # Font installation script
│   │   └── 📄 nerd-fonts-setup.md   # Nerd Fonts setup guide
│   ├── 📂 icons/                   # Icon themes and setup
│   │   ├── 📄 install-icons.sh      # Icon installation script
│   │   └── 📄 papirus-setup.md      # Papirus icon setup
│   ├── 📂 keymaps/                 # Keyboard layout files
│   │   ├── 📄 azerty-fr.map         # French AZERTY keymap
│   │   └── 📄 custom-layouts.md     # Custom layout guide
│   └── 📂 scripts/                 # Helper and utility scripts
│       ├── 📄 autostart.sh          # Desktop autostart script
│       ├── 📄 screenshot.sh         # Screenshot utility
│       └── 📄 workspace-manager.sh  # Workspace management
│
├── 📂 examples/                     # 📖 Configuration Examples
│   ├── 📂 ci-cd/                   # CI/CD pipeline examples
│   │   ├── 📄 github-actions.yml    # GitHub Actions workflow
│   │   ├── 📄 gitlab-ci.yml         # GitLab CI pipeline
│   │   └── 📄 password-workflows.md # Password management workflows
│   ├── 📂 configurations/          # Example configurations
│   │   ├── 📄 work-laptop.yml       # Work laptop configuration
│   │   ├── 📄 gaming-desktop.yml    # Gaming desktop configuration
│   │   └── 📄 development-vm.yml    # Development VM configuration
│   └── 📂 deployment/              # Deployment examples
│       ├── 📄 single-user.sh        # Single user deployment
│       ├── 📄 multi-user.sh         # Multi-user deployment
│       └── 📄 enterprise.sh         # Enterprise deployment
│
└── 📂 configs/profiles/             # 📋 Profile-Specific Configurations
    ├── 📂 work/                     # Work environment profile
    │   ├── 📄 archinstall.json      # Work-specific archinstall config
    │   ├── 📄 ansible-vars.yml      # Work environment variables
    │   └── 📄 packages.yml          # Work-specific packages
    ├── 📂 personal/                 # Personal environment profile
    │   ├── 📄 archinstall.json      # Personal archinstall config
    │   ├── 📄 ansible-vars.yml      # Personal environment variables
    │   └── 📄 packages.yml          # Personal packages
    └── 📂 development/              # Development environment profile
        ├── 📄 archinstall.json      # Development archinstall config
        ├── 📄 ansible-vars.yml      # Development variables
        └── 📄 packages.yml          # Development packages
```

## 🎯 Key Components Overview

### 🚀 Revolutionary Deployment System

- **Dynamic Configuration**: Ansible configs generated automatically from deploy.conf
- **Template-Based Generation**: Jinja2 templates for flexible configuration management
- **USB Deployment**: Edit config on main PC, deploy with zero typing errors
- **Zero-Touch Installation**: Answer 3 questions, get complete desktop
- **Advanced Password Management**: 4 secure methods with encryption
- **Enterprise CI/CD**: GitHub Actions integration

### 🛡️ Security Framework

- **Multi-layered Security**: Firewall, fail2ban, audit logging
- **Password Encryption**: AES-256 with PBKDF2 key derivation
- **System Hardening**: Kernel parameters, file permissions
- **Access Control**: SSH hardening, sudo configuration

### ⚡ Performance & Power Management

- **TLP Integration**: Advanced laptop power management
- **Intel GPU Optimization**: Hardware-specific tuning
- **Thermal Management**: Temperature monitoring and control
- **CPU Scaling**: Performance and efficiency balance

### 🔧 System Tools & Utilities

- **Hardware Validation**: Compatibility checking and reporting
- **Backup Management**: Complete system backup with verification
- **Package Management**: Unified pacman/AUR interface
- **System Monitoring**: Real-time status and health checking

## 📚 Documentation Structure

### Core Documentation

- **installation-guide.md**: Complete deployment methods including USB system
- **password-management.md**: Advanced password system documentation
- **github-password-storage.md**: Enterprise CI/CD setup guide
- **target-computer-deployment.md**: Target deployment workflows

### Technical Documentation

- **project-structure.md**: Complete codebase overview (this file)
- **virtualbox-testing-guide.md**: VM testing environment setup
- **troubleshooting.md**: Common issues and solutions

## 🔄 Workflow Integration

### Development Workflow

1. **Development**: Edit code, test in VM
2. **Validation**: Run testing scripts
3. **Documentation**: Update relevant guides
4. **Integration**: CI/CD pipeline validation

### Deployment Workflow

1. **Preparation**: Choose deployment method (USB/Direct/CI-CD)
2. **Configuration**: Set up passwords using preferred method
3. **Deployment**: Execute deployment scripts
4. **Validation**: Run post-installation tests

### Maintenance Workflow

1. **Monitoring**: Regular system health checks
2. **Updates**: Automated system and package updates
3. **Backup**: Regular configuration and data backups
4. **Security**: Periodic security audits and updates

## 🚀 Getting Started

### Quick Start Options

1. **USB Deployment** (Recommended): Download `usb-deployment/` folder
2. **Direct Installation**: Use `scripts/deploy.sh full`
3. **Enterprise Setup**: Configure GitHub Secrets workflow
4. **Traditional**: Clone repository and use Makefile

### Development Setup

```bash
git clone https://github.com/LyeosMaouli/lm-archlinux-desktop.git
cd lm-archlinux-desktop
make dev-setup  # Install development tools
make test      # Run validation tests
```

This revolutionary project structure provides enterprise-grade automation with maximum flexibility and security for Arch Linux Hyprland deployments.
