# Direct Development Guide for Arch Linux Desktop Automation

This guide provides instructions for direct development on the Arch Linux Desktop Automation project, using a simplified workflow without containers.

## 🎯 **Development Philosophy**

This project now uses a **direct development approach** that emphasizes simplicity, performance, and ease of use:

- **Direct Host Development**: Work directly on your development machine
- **VirtualBox Testing**: Use VirtualBox VMs for comprehensive testing
- **Simplified Workflow**: Minimal overhead, maximum productivity
- **Native Tools**: Use system-native tools and dependencies

## 🛠️ **Development Environment Setup**

### Prerequisites

#### Required Software

- **Arch Linux** (recommended for development)
- **Git** >= 2.30
- **Python** >= 3.9
- **Ansible** >= 8.0.0
- **VirtualBox** >= 7.0 (for testing)

#### Optional Tools

- **Visual Studio Code** or your preferred editor
- **shellcheck** for shell script validation
- **ansible-lint** for Ansible playbook validation

### Initial Setup

```bash
# 1. Clone the repository
git clone https://github.com/LyeosMaouli/lm-archlinux-desktop.git
cd lm-archlinux-desktop

# 2. Install system dependencies (Arch Linux)
sudo pacman -S ansible python python-pip git shellcheck

# 3. Install Python dependencies
pip install -r requirements.txt

# 4. Install Ansible collections
ansible-galaxy install -r configs/ansible/requirements.yml

# 5. Verify installation
./scripts/deploy.sh --help
ansible --version
```

### Alternative Setup (Non-Arch Systems)

```bash
# For Ubuntu/Debian
sudo apt update
sudo apt install ansible python3 python3-pip git shellcheck

# For macOS (with Homebrew)
brew install ansible python git shellcheck

# Then continue with Python dependencies
pip3 install -r requirements.txt
ansible-galaxy install -r configs/ansible/requirements.yml
```

## 🚀 **Development Workflow**

### Daily Development Process

```bash
# 1. Start development session
cd lm-archlinux-desktop
git status
git pull origin develop

# 2. Make changes to code
# Edit Ansible roles, scripts, documentation, etc.

# 3. Validate changes
ansible-lint configs/ansible/
shellcheck scripts/**/*.sh

# 4. Test deployment configuration
./scripts/deploy.sh full --dry-run

# 5. Test in VirtualBox (see Testing section)

# 6. Commit changes
git add .
git commit -m "feat: your change description"
git push origin develop
```

### Development Commands

#### Core Development Commands

```bash
# Test deployment without execution
./scripts/deploy.sh full --dry-run --verbose

# Validate Ansible configurations
ansible-lint configs/ansible/

# Test specific Ansible roles
ansible-playbook -i configs/ansible/inventory/localhost.yml configs/ansible/playbooks/desktop.yml --check

# Validate shell scripts
find scripts/ -name "*.sh" -exec shellcheck {} \;

# Test password management
./scripts/utils/passwords.sh --help
```

#### Quick Testing Commands

```bash
# Test installation validation script
./scripts/testing/test_installation.sh --dry-run

# Test hardware validation
./scripts/utilities/hardware_validation.sh

# Test network setup
./scripts/utilities/network_auto_setup.sh --check

# Check system health monitoring
./scripts/maintenance/health_check.sh
```

### Code Quality Checks

```bash
# Run all quality checks
make lint

# Individual checks
ansible-lint configs/ansible/           # Ansible validation
shellcheck scripts/**/*.sh             # Shell script validation
yamllint configs/                       # YAML validation
find . -name "*.md" -exec markdownlint {} \;  # Markdown validation
```

## 🧪 **Testing with VirtualBox**

### Primary Testing Method

VirtualBox testing is the **primary and recommended** method for validating changes:

```bash
# 1. Create VirtualBox VM
# - 8GB RAM, 60GB disk
# - EFI enabled, NAT network
# - Boot from Arch Linux ISO

# 2. Run automated testing
curl -fsSL https://raw.githubusercontent.com/LyeosMaouli/lm-archlinux-desktop/main/scripts/testing/auto_vm_test.sh -o auto_vm_test.sh
chmod +x auto_vm_test.sh
./auto_vm_test.sh

# 3. Review test results
cat ~/vm_test_report.txt
```

### Manual Testing Process

```bash
# For detailed control over testing process:

# 1. Boot VM from Arch ISO
# 2. Set up network connectivity
# 3. Clone repository
git clone https://github.com/LyeosMaouli/lm-archlinux-desktop.git
cd lm-archlinux-desktop

# 4. Run specific deployment phases
./scripts/deploy.sh install --config custom_config.yml
./scripts/deploy.sh desktop --profile development
./scripts/deploy.sh security

# 5. Validate installation
./scripts/testing/test_installation.sh
```

### Test Configuration

Create custom test configurations for development:

```bash
# Create development test config
cp example_deployment_config.yml dev_test_config.yml

# Edit for your testing needs
nano dev_test_config.yml

# Test with custom config
./scripts/deploy.sh full --config dev_test_config.yml --dry-run
```

## 📂 **Project Structure for Development**

### Key Development Areas

```
lm-archlinux-desktop/
├── configs/ansible/roles/          # Core development area
│   ├── base_system/                # System configuration
│   ├── hyprland_desktop/          # Desktop environment
│   ├── users_security/            # Security hardening
│   └── ...
├── scripts/                        # Automation scripts
│   ├── deploy.sh                   # Main deployment script
│   ├── testing/                    # Testing scripts
│   └── utils/                      # Utility functions
├── templates/                      # Jinja2 templates
└── docs/                          # Documentation
```

### Development Guidelines

#### Ansible Role Development

```bash
# Create new role
ansible-galaxy init configs/ansible/roles/new_role

# Test role individually
ansible-playbook -i configs/ansible/inventory/localhost.yml \
  --tags "new_role" local.yml --check

# Role structure
configs/ansible/roles/new_role/
├── tasks/main.yml          # Main tasks
├── handlers/main.yml       # Service handlers
├── templates/              # Jinja2 templates
├── defaults/main.yml       # Default variables
└── meta/main.yml          # Role metadata
```

#### Script Development

```bash
# Script location guidelines
scripts/
├── deployment/             # Core deployment logic
├── testing/               # Testing and validation
├── utilities/             # General utilities
├── utils/                 # Core utility functions
└── security/              # Security-related scripts

# Script standards
# - Use set -euo pipefail
# - Include comprehensive error handling
# - Add logging and verbose output
# - Follow shellcheck recommendations
```

#### Documentation Updates

```bash
# Update documentation when making changes
docs/
├── installation-guide.md   # User installation guide
├── virtualbox-testing-guide.md  # Testing procedures
├── password-management.md  # Password system docs
└── development-instructions.md   # This file
```

## 🔧 **Configuration Management**

### Environment Configuration

```bash
# Development configuration
export ANSIBLE_CONFIG="$(pwd)/configs/ansible/ansible.cfg"
export ANSIBLE_ROLES_PATH="$(pwd)/configs/ansible/roles"
export ANSIBLE_INVENTORY="$(pwd)/configs/ansible/inventory"

# Add to your shell profile (.bashrc, .zshrc)
echo 'export ANSIBLE_CONFIG="$PWD/configs/ansible/ansible.cfg"' >> ~/.bashrc
```

### Custom Configurations

```bash
# Create development-specific configs
cp deployment_config.yml dev_deployment_config.yml
cp configs/ansible/inventory/localhost.yml configs/ansible/inventory/dev.yml

# Test with custom configs
./scripts/deploy.sh full --config dev_deployment_config.yml
ansible-playbook -i configs/ansible/inventory/dev.yml local.yml
```

## 🐛 **Debugging and Troubleshooting**

### Ansible Debugging

```bash
# Verbose ansible execution
ansible-playbook -vvv -i configs/ansible/inventory/localhost.yml local.yml

# Debug specific tasks
ansible-playbook -i configs/ansible/inventory/localhost.yml local.yml \
  --tags "desktop" --step

# Check variable values
ansible-playbook -i configs/ansible/inventory/localhost.yml \
  --list-tasks local.yml
```

### Script Debugging

```bash
# Enable script debugging
bash -x scripts/deploy.sh full --dry-run

# Check logs
tail -f /var/log/deployment.log
tail -f /var/log/ansible.log

# Validate configurations
./scripts/utilities/validation.sh --check-config
```

### Common Issues

#### Ansible Collection Issues

```bash
# Reinstall collections
ansible-galaxy collection install --force -r configs/ansible/requirements.yml
```

#### Permission Issues

```bash
# Fix script permissions
find scripts/ -name "*.sh" -exec chmod +x {} \;
```

#### Network Issues During Testing

```bash
# Test network connectivity
ping -c 3 archlinux.org
# Check DNS resolution
nslookup archlinux.org
```

## 📋 **Branch Management**

### Development Branch Strategy

```bash
# Work on develop branch
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/your-feature-name

# Make changes and test
# ... development work ...

# Push feature branch
git push origin feature/your-feature-name

# Create pull request to develop branch
```

### Testing Branch

```bash
# Switch to testing branch for VM testing configurations
git checkout testing

# Merge changes from develop for testing
git merge develop

# Push tested configurations
git push origin testing
```

## 🎯 **Best Practices**

### Code Quality

- **Always** run `ansible-lint` before committing Ansible changes
- **Always** run `shellcheck` on shell scripts
- **Test** all changes in VirtualBox before pushing
- **Document** any new features or significant changes
- **Follow** existing code patterns and conventions

### Testing Standards

- **VM Testing**: All significant changes must be tested in VirtualBox
- **Dry Run**: Always test with `--dry-run` first
- **Validation**: Use provided validation scripts
- **Documentation**: Update documentation for new features

### Security Considerations

- **Never** commit passwords or secrets
- **Use** the password management system
- **Test** security configurations thoroughly
- **Follow** security hardening guidelines

## 🚀 **Performance Tips**

### Development Performance

```bash
# Use Ansible facts caching
export ANSIBLE_CACHE_PLUGIN=memory

# Parallel execution where safe
ansible-playbook -f 10 # 10 parallel forks

# Skip gather_facts when not needed
ansible-playbook --skip-tags "facts" local.yml
```

### VirtualBox Performance

```bash
# Optimize VM settings
# - Enable VT-x/AMD-V
# - Allocate sufficient RAM (8GB+)
# - Use SSD storage
# - Enable 3D acceleration
```

## 📚 **Additional Resources**

### Documentation

- [VirtualBox Testing Guide](virtualbox-testing-guide.md) - Comprehensive testing procedures
- [Installation Guide](installation-guide.md) - End-user installation instructions
- [Password Management](password-management.md) - Password system documentation

### External Resources

- [Ansible Documentation](https://docs.ansible.com/)
- [VirtualBox Documentation](https://www.virtualbox.org/wiki/Documentation)
- [Arch Linux Wiki](https://wiki.archlinux.org/)
- [Hyprland Documentation](https://hyprland.org/)

### Tools and Extensions

#### VS Code Extensions (Recommended)

- **Ansible** - Ansible language support
- **YAML** - YAML language support
- **ShellCheck** - Shell script validation
- **Markdown All in One** - Markdown editing
- **GitLens** - Git integration

#### Command Line Tools

```bash
# Install useful development tools
sudo pacman -S \
  bat \          # Better cat
  exa \          # Better ls
  fd \           # Better find
  ripgrep \      # Better grep
  fzf \          # Fuzzy finder
  tree           # Directory tree view
```

---

This simplified development approach eliminates container complexity while maintaining robust testing capabilities through VirtualBox. The direct development workflow is more straightforward and performs better than container-based alternatives.
