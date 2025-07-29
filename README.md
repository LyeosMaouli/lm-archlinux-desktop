# Arch Linux Hyprland Desktop Automation

![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?logo=arch-linux&logoColor=fff&style=flat)
![Hyprland](https://img.shields.io/badge/Hyprland-58E1FF?logo=wayland&logoColor=000&style=flat)
![Ansible](https://img.shields.io/badge/Ansible-EE0000?logo=ansible&logoColor=fff&style=flat)
![License](https://img.shields.io/badge/License-MIT-green.svg)

**🚀 STREAMLINED ARCH LINUX AUTOMATION** - Transform a minimal Arch Linux installation into a fully-configured Hyprland desktop environment with **enterprise-grade security**, **advanced password management**, **super-simple bootstrap process**, and **zero-touch deployment**. Now with **2-file download setup** and **comprehensive VirtualBox testing**!

## 🎯 Simplified Deployment Interface

### One Command, Complete Desktop

```bash
# Complete deployment with intelligent dependency installation
./scripts/deploy.sh full

# Step-by-step deployment
./scripts/deploy.sh install   # Base system
./scripts/deploy.sh desktop   # Desktop environment
./scripts/deploy.sh security  # Security hardening

# Automatic configuration detection - supports all deployment methods
./scripts/deploy.sh full --config config/deploy.conf
```

### Key Improvements

- ✅ **2-File Bootstrap**: Download only `bootstrap.sh` + `bootstrap.conf` - that's it!
- ✅ **Zero Typing Errors**: No more long curl commands or complex URLs
- ✅ **Auto-Everything**: Automatic dependency installation, repo download, and verification
- ✅ **Edit & Run**: Simple config file editing + single command deployment
- ✅ **Repository Verification**: Automatic integrity checking and security validation
- ✅ **Intelligent Error Handling**: Comprehensive error detection and recovery
- 🆕 **Super Simple Process**: 3 steps total - download, edit, run
- 🆕 **VirtualBox Testing**: Safe VM testing before production deployment
- 🆕 **Direct Development**: Simplified development workflow without container complexity
- 🆕 **Performance Optimizations**: Parallel processing and intelligent caching

## ✨ Key Features

### 🔒 **Advanced Hybrid Password Management System**

- **4 Secure Methods**: Environment variables, encrypted files, auto-generation, interactive
- **Enterprise CI/CD Integration**: GitHub Actions workflow templates
- **AES-256 Encryption**: PBKDF2 key derivation for password files
- **Email & QR Delivery**: Multiple secure password delivery methods
- **Zero-Touch Deployment**: Complete automation from ISO to desktop

### 📱 **USB Deployment System** _(No More Typing Errors!)_

- **Centralized Configuration**: Single `config/deploy.conf` file for all settings
- **Pre-configured Scripts**: Edit settings on your main computer, deploy on target
- **Zero Console Typing**: No long commands to type in Arch Linux console
- **Error-Free Deployment**: Eliminates human error in manual command entry
- **Automatic Setup**: Downloads complete project structure and configuration

## 🚀 Features

### 🧪 **VirtualBox Testing Environment** _(Primary Testing Method)_

Our **comprehensive VirtualBox-based testing platform** ensures reliable automation:

- **🎯 Automated VM Testing** - Complete automation from ISO to desktop with `auto_vm_test.sh`
- **🚀 Full System Validation** - End-to-end testing in isolated VM environment
- **🔧 VM Optimizations** - Guest additions, performance tuning, and VM-specific configurations
- **📊 Comprehensive Reporting** - Detailed test reports and validation results
- **🛡️ Safe Testing** - Isolated environment prevents host system contamination
- **⚡ Performance Monitoring** - Built-in deployment performance tracking
- **📚 Complete Documentation** - Step-by-step testing guide with troubleshooting

**Why VirtualBox Testing?**
- **Safety** - Test without affecting your main system
- **Reliability** - Consistent, reproducible test environment
- **Automation** - Fully automated testing from ISO to desktop
- **Validation** - Comprehensive system validation and reporting

### 📋 **Direct Development Workflow**

Simplified development approach for maximum productivity:

- **🏠 Host-Based Development** - Work directly on your development machine
- **⚡ Native Performance** - No container overhead or complexity
- **🛠️ Standard Tools** - Use familiar system tools and dependencies
- **🧪 VirtualBox Testing** - Comprehensive testing in isolated VMs
- **📝 Code Quality** - ansible-lint, shellcheck, and validation scripts
- **🔄 Simple Workflow** - Straightforward development and testing process

### 🖥️ Desktop Environment

- **Hyprland** - Modern Wayland compositor with intelligent tiling
- **Waybar** - Highly customizable status bar
- **Wofi** - Application launcher with search
- **Mako** - Notification daemon
- **Kitty** - GPU-accelerated terminal emulator
- **SDDM** - Display manager with Wayland support

### 🔒 Security & Hardening

- **UFW Firewall** - Configured with restrictive defaults
- **fail2ban** - Intrusion prevention system
- **Audit System** - Comprehensive security logging
- **Kernel Hardening** - Security-focused kernel parameters
- **File Permissions** - Properly secured system files
- **SSH Hardening** - Secure remote access configuration

### 📦 Package Management

- **Pacman** - Official Arch repositories with fastest mirrors
- **Yay** - Secure AUR helper with verification
- **Security Scanning** - Package integrity verification
- **Auto-Updates** - Optional automated update system

### 🎵 Audio & Media

- **PipeWire** - Modern audio system with low latency
- **Bluetooth** - Full Bluetooth audio support
- **Hardware Acceleration** - Intel GPU optimization

### 🛠️ Development Tools

- **Visual Studio Code** - Modern code editor
- **Git Configuration** - Development workflow setup
- **Language Support** - Python, Node.js, Rust, Go ready
- **Terminal Tools** - Enhanced CLI experience

### ⚡ Power Management & Performance

- **TLP** - Advanced laptop power management
- **Intel GPU Optimization** - Hardware-specific tuning
- **CPU Frequency Scaling** - Performance and power balance
- **Thermal Management** - Temperature monitoring and control

### 🔧 System Tools & Utilities

- **Comprehensive Hardware Validation** - Compatibility checking with detailed reports
- **Backup & Restore System** - Full system backup with verification and rollback capabilities
- **Package Management Tools** - Unified pacman/AUR interface with security scanning
- **System Information Dashboard** - Real-time status monitoring with health checks
- **VirtualBox Testing Framework** - Automated VM testing with comprehensive validation
- **Performance Monitoring** - Built-in performance tracking and optimization suggestions
- **Deployment Analytics** - Comprehensive deployment metrics and insights with correlation tracking

## 📋 System Requirements

### Hardware

- **CPU**: x86_64 architecture (Intel/AMD)
- **RAM**: 8GB minimum, 16GB recommended
- **Storage**: 60GB available space
- **Graphics**: Intel GPU (optimized), others supported
- **Network**: Internet connection for initial setup

### Software

- **Host OS**: Any system for development (Arch Linux recommended)
- **VirtualBox**: >= 7.0 for testing
- **Arch Linux ISO**: Latest release for deployment and testing

## 🚀 Quick Start

### 🎯 **Super Simple 3-Step Process**

#### Step 1: Download Bootstrap Files
```bash
# Download the bootstrap script and configuration
wget https://raw.githubusercontent.com/LyeosMaouli/lm_archlinux_desktop/main/bootstrap.sh
wget https://raw.githubusercontent.com/LyeosMaouli/lm_archlinux_desktop/main/bootstrap.conf
chmod +x bootstrap.sh
```

#### Step 2: Edit Configuration
```bash
# Edit the configuration file with your preferences
nano bootstrap.conf

# Key settings to customize:
# - HOSTNAME=phoenix          # Your computer name
# - USERNAME=lyeosmaouli      # Your username  
# - PROFILE=work              # work/personal/development
# - TIMEZONE=Europe/Paris     # Your timezone
# - KEYMAP=fr                # Your keyboard layout
```

#### Step 3: Run Deployment
```bash
# For VirtualBox testing (recommended first):
./bootstrap.sh testing

# For full production deployment:
./bootstrap.sh full

# For specific components only:
./bootstrap.sh desktop    # Desktop environment only
./bootstrap.sh security   # Security hardening only
```

**That's it!** The bootstrap script handles everything:
- ✅ Downloads and verifies the complete repository
- ✅ Validates system requirements and network connectivity
- ✅ Installs dependencies automatically
- ✅ Runs the deployment with your configuration
- ✅ Provides comprehensive logging and error handling

### 🧪 **VirtualBox Testing (Highly Recommended)**

Test safely in a VM before deploying to your main system:

```bash
# 1. Create VirtualBox VM:
#    - 8GB RAM, 60GB disk
#    - EFI enabled, NAT network
#    - Boot from Arch Linux ISO

# 2. Download and run bootstrap:
wget https://raw.githubusercontent.com/LyeosMaouli/lm_archlinux_desktop/main/bootstrap.sh
wget https://raw.githubusercontent.com/LyeosMaouli/lm_archlinux_desktop/main/bootstrap.conf
chmod +x bootstrap.sh

# 3. Edit configuration for testing:
nano bootstrap.conf  # Set VM_MEMORY=8192, VM_OPTIMIZATION=true

# 4. Run testing deployment:
./bootstrap.sh testing --verbose

# The script handles everything automatically:
# - Network setup and validation
# - Repository download and verification
# - Complete system installation
# - Desktop environment deployment  
# - Security hardening
# - Comprehensive test report generation
```

### 💻 **Development Setup**

For developers who want to modify the automation:

```bash
# Clone repository for development
git clone https://github.com/LyeosMaouli/lm_archlinux_desktop.git
cd lm_archlinux_desktop

# Install development dependencies (Arch Linux)
sudo pacman -S ansible python python-pip git shellcheck
pip install -r requirements.txt
ansible-galaxy install -r configs/ansible/requirements.yml

# Run development commands
make dev-setup    # Setup development tools
make lint         # Check code quality  
make vm-test      # VirtualBox testing guide
```

## 🛠️ Development

### Development Workflow

```bash
# Start development
git checkout develop
git pull origin develop

# Make changes and validate
ansible-lint configs/ansible/
shellcheck scripts/**/*.sh
./scripts/deploy.sh full --dry-run

# Test in VirtualBox VM
# Follow docs/virtualbox-testing-guide.md

# Commit changes
git add .
git commit -m "feat: your changes"
git push origin develop
```

### Available Commands

```bash
# Bootstrap deployment options
./bootstrap.sh full              # Complete deployment
./bootstrap.sh testing           # VirtualBox testing
./bootstrap.sh desktop           # Desktop environment only
./bootstrap.sh security          # Security hardening only
./bootstrap.sh --dry-run full    # Preview actions
./bootstrap.sh --verbose testing # Verbose output

# Development helpers (after cloning repo)
make dev-setup    # Setup development tools
make lint         # Run code quality checks
make vm-test      # VirtualBox testing guide
```

## 🧪 Testing

### Primary Testing Method: VirtualBox

VirtualBox testing is the **primary and recommended** testing method:

1. **Automated Testing**: Use `scripts/testing/auto_vm_test.sh` for complete automation
2. **Manual Testing**: Follow `docs/virtualbox-testing-guide.md` for detailed control
3. **Validation**: Comprehensive test reports and system validation
4. **Safety**: Test without affecting your host system

### Testing Commands

```bash
# Bootstrap testing (recommended)
./bootstrap.sh testing --verbose

# Dry run testing (preview only)
./bootstrap.sh testing --dry-run

# Advanced testing (after repo cloning)
./scripts/testing/test_installation.sh  # Installation validation
./scripts/maintenance/health_check.sh   # System health check
```

## 📚 Documentation

### Core Documentation

- **[Installation Guide](docs/installation-guide.md)** - Complete deployment methods
- **[VirtualBox Testing Guide](docs/virtualbox-testing-guide.md)** - Primary testing method
- **[Development Instructions](docs/development-instructions.md)** - Development setup
- **[Password Management](docs/password-management.md)** - Advanced password system

### Quick Links

- **[Project Structure](docs/project-structure.md)** - Complete codebase overview
- **[Security Guide](SECURITY.md)** - Security policies and practices
- **[Troubleshooting](docs/virtualbox-testing-guide.md#troubleshooting-common-issues)** - Common issues and solutions

## 🎯 Branch Strategy

### Repository Branches

- **`main`** - Stable, production-ready code
- **`develop`** - Active development branch
- **`testing`** - VirtualBox testing configurations

### Workflow

1. **Development** - Work on `develop` branch
2. **Testing** - Validate changes in VirtualBox
3. **Integration** - Merge tested changes to `main`
4. **Release** - Tag stable releases

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch from `develop`
3. Make your changes with tests
4. Validate with VirtualBox testing
5. Submit a pull request to `develop`

### Development Standards

- **Code Quality**: Use `make lint` before committing
- **Testing**: All changes must be tested in VirtualBox
- **Documentation**: Update documentation for new features
- **Security**: Follow security best practices

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Arch Linux Community** - Excellent documentation and support
- **Hyprland Project** - Modern Wayland compositor
- **Ansible Community** - Infrastructure automation platform
- **VirtualBox** - Reliable virtualization platform

---

**Ready to automate your Arch Linux setup?** Start with VirtualBox testing using our comprehensive `auto_vm_test.sh` script, then deploy to your actual system with confidence!