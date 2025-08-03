# Documentation Index

**Arch Linux Hyprland Desktop Automation** - Enterprise-grade automation for complete, secure desktop environments.

## Quick Start

- **[Installation Guide](installation-guide.md)** - Complete deployment methods
- **[Project Architecture](project-structure.md)** - System architecture and components
- **[Password Management](password-management.md)** - Advanced password system
- **[VirtualBox Testing](virtualbox-testing-guide.md)** - Testing environment

## Advanced Documentation

- **[Development Instructions](development-instructions.md)** - Development workflow
- **[GitHub CI/CD](github-password-storage.md)** - Enterprise deployment
- **[Target Deployment](target-computer-deployment.md)** - Remote deployment
- **[Security Policy](../SECURITY.md)** - Security guidelines

## Technical Overview

### Core Components
- **Dynamic Configuration**: Template-based Ansible generation from `deploy.conf`
- **Unified Interface**: Single `deploy.sh` command for all operations
- **Security Framework**: Multi-layered security with encryption and hardening
- **Profile Support**: Work, personal, development configurations

### Architecture
- **Ansible Roles**: `base_system`, `users_security`, `hyprland_desktop`, `aur_packages`, `system_hardening`, `power_management`
- **Deployment Scripts**: `deploy.sh`, testing utilities, maintenance tools
- **Configuration**: Template-driven dynamic configuration system

## Common Commands

```bash
# Quick deployment
./scripts/deploy.sh full

# Test configuration
./scripts/deploy.sh full --dry-run

# VirtualBox testing
./scripts/testing/auto_vm_test.sh

# System health check
./tools/system_info.sh
```

## Troubleshooting

**Common issues:**
- Network: `./scripts/utilities/network_auto_setup.sh recovery`
- SSH keys: Auto-generated, view with `cat ~/.ssh/id_rsa.pub`
- Deployment: Use `--dry-run` and check logs in `/var/log/`

**Support:**
1. Check documentation and logs
2. Test in VirtualBox first
3. Create GitHub issue with system info

---

**Get started:** [Installation Guide](installation-guide.md)
