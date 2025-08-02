# System Tools

Utility tools for system management, monitoring, and maintenance.

## Tools

### system_info.sh
Comprehensive system information display.

**Features:** Hardware info, Hyprland status, network config, services, packages, security status, performance metrics, container detection, JSON output.

```bash
./system_info.sh           # Standard output
./system_info.sh --json    # JSON output
./system_info.sh --dev     # Development environment
```

### package_manager.sh
Unified pacman and AUR package management.

**Features:** Updates, install/remove, search, orphan cleanup, backup/restore, yay installation.

```bash
./package_manager.sh update
./package_manager.sh install firefox code
./package_manager.sh clean
```

### hardware_checker.sh
Hardware compatibility validation.

**Features:** CPU validation, memory check, graphics compatibility, storage requirements, network detection, Wayland compatibility, boot system analysis.

```bash
./hardware_checker.sh
```

### backup_manager.sh
Backup and restore solution.

**Features:** Full/selective backups, compression, verification, restore, cleanup, package lists.

```bash
./backup_manager.sh create full
./backup_manager.sh list
./backup_manager.sh restore 20240101-120000
```

## Integration

**Ansible:** Deployed via `configs/ansible/roles/system_tools/`, configured through variables, called from maintenance playbooks.

**Dependencies:**
```bash
sudo pacman -S --needed jq curl tar gzip findutils coreutils
./package_manager.sh install-yay  # For AUR
```

**Configuration:**
```bash
export AUR_HELPER="yay"
export BACKUP_DIR="$HOME/backups"
export KEEP_BACKUPS="7"
```

## Common Workflows

```bash
# System health check
./hardware_checker.sh
./system_info.sh
./package_manager.sh check

# Maintenance
./package_manager.sh update
./package_manager.sh clean
./backup_manager.sh create full

# Recovery
./backup_manager.sh list
./backup_manager.sh verify BACKUP_ID
./backup_manager.sh restore BACKUP_ID
```

## Troubleshooting

```bash
# Package issues
sudo pacman-key --init && sudo pacman-key --populate archlinux

# Debug mode
export DEBUG=1 && ./tool_name.sh

# Check logs
tail -f /var/log/tool-name.log
```