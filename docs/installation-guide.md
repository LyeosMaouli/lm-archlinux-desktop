# Installation Guide

🚀 **Enterprise-grade Arch Linux Hyprland desktop automation** - Complete, secure, modern desktop in one command.

## Quick Start

### Single Command Deployment

```bash
# Complete deployment
./scripts/deploy.sh full

# Step-by-step
./scripts/deploy.sh install   # Base system
./scripts/deploy.sh desktop   # Desktop environment  
./scripts/deploy.sh security  # Security hardening
```

## System Overview

Transforms minimal Arch Linux into fully-configured Hyprland desktop:

- **Desktop**: Hyprland, Waybar, Wofi, Mako, Kitty, SDDM
- **Security**: UFW firewall, fail2ban, audit logging, SSH hardening
- **Applications**: VS Code, Firefox, Discord, development tools
- **Power**: PipeWire audio, TLP power management, Intel GPU optimization

## Configuration

```bash
# Edit main configuration
nano config/deploy.conf

# Key settings:
USER_NAME="yourusername"
HOSTNAME="your-hostname" 
PASSWORD_MODE="generate"    # env|file|generate|interactive
PROFILE="work"              # work|personal|development
ENCRYPTION_ENABLED=true
```

## Prerequisites

- **Hardware**: 8GB+ RAM, 60GB storage, Intel GPU recommended
- **Software**: Arch Linux ISO, internet connection
- **Dependencies**: Auto-installed (ansible, cryptsetup, parted)

## Installation Methods

### Method 1: USB Deployment (Recommended)

**Zero typing errors** - Edit config on main PC, deploy with no console typing.

```bash
# 1. Download usb-deployment folder to USB
# 2. Edit usb-deploy.sh configuration:
USER_NAME="your_username"
HOST_NAME="your_hostname"
PASSWORD_MODE="generate"
ENABLE_ENCRYPTION="true"

# 3. Boot target computer from Arch ISO
# 4. Mount USB and run:
mount /dev/sdX1 /mnt/usb && cd /mnt/usb
./usb-deploy.sh
```

### Method 2: Direct Installation

**3 questions = Complete desktop**

```bash
# 1. Boot from Arch ISO
# 2. Clone and deploy:
git clone https://github.com/LyeosMaouli/lm-archlinux-desktop.git
cd lm-archlinux-desktop
./scripts/deploy.sh full

# 3. Answer 3 questions:
#    - Username
#    - Hostname  
#    - Enable encryption?
```

**Auto-detects**: Timezone, keyboard, hardware, mirrors, networking

### Method 3: Enterprise CI/CD

```bash
# Store in GitHub Secrets:
# DEPLOY_USER_PASSWORD, DEPLOY_ROOT_PASSWORD, etc.

# Deploy with environment variables:
export DEPLOY_USER_PASSWORD="secure_password"
./scripts/deploy.sh full --password env
```

See `examples/ci-cd/github-actions.yml` and [GitHub Password Storage](github-password-storage.md).

## Password Management

**4 secure methods:**

```bash
# Environment variables (CI/CD)
export DEPLOY_USER_PASSWORD="secure_password"
./scripts/deploy.sh full --password env

# Encrypted file (AES-256)
./scripts/utils/passwords.sh create-file passwords.enc
./scripts/deploy.sh full --password file

# Auto-generated (recommended)
./scripts/deploy.sh full --password generate

# Interactive prompts
./scripts/deploy.sh full --password interactive
```

See [Password Management](password-management.md) for details.

### Method 4: Traditional Manual

```bash
# Customize configuration
cp config/deploy.conf my_deploy.conf
nano my_deploy.conf

# Deploy with custom config
./scripts/deploy.sh full --config my_deploy.conf
```

## What You Get

**Complete, secure, modern desktop:**

- **Desktop**: Hyprland + Waybar + Wofi + Mako + Kitty + SDDM
- **Security**: UFW firewall, fail2ban, LUKS encryption, SSH hardening, audit logging
- **Apps**: Firefox, VS Code, Discord, development tools (Git, Docker, Python, Node.js)
- **Performance**: TLP power management, Intel GPU optimization, PipeWire audio, Zram swap

## Post-Installation

**First boot:** Login at SDDM with your credentials

**Key bindings:**
- `Super + Return` - Terminal (Kitty)
- `Super + D` - App launcher (Wofi)  
- `Super + E` - File manager (Thunar)
- `Super + L` - Lock screen

**Verification:**
```bash
./tools/system_info.sh        # System health
./tools/hardware_checker.sh   # Hardware check
sudo ufw status               # Firewall status
```

## Troubleshooting

**Network issues:**
```bash
nmcli device status
nmcli device wifi connect "SSID" password "password"
```

**Desktop issues:**
```bash
journalctl -u sddm
systemctl --user restart pipewire
```

**Performance:**
```bash
htop
dmesg | grep -i error
```

**Help:**
- Logs: `/var/log/`
- Config: `~/.config/hypr/`
- Tools: `./tools/`

---

**Total time:** 30-60 minutes depending on internet speed.
