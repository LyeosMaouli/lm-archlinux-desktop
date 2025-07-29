# Makefile for Arch Linux Hyprland Desktop Automation
# Simplified for direct development workflow

.PHONY: help install bootstrap desktop security maintenance test lint clean dev-setup status backup vm-test config-generate config-validate config-clean

# Default target
help:
	@echo "Arch Linux Hyprland Desktop Automation"
	@echo "======================================"
	@echo ""
	@echo "Available targets:"
	@echo ""
	@echo "Configuration Management:"
	@echo "  config-generate  - Generate all config files from master config"
	@echo "  config-validate  - Validate master configuration"
	@echo "  config-clean     - Remove all generated config files"
	@echo ""
	@echo "Installation & Deployment:"
	@echo "  install     - Install Ansible and dependencies"
	@echo "  bootstrap   - Run initial system setup"
	@echo "  desktop     - Install Hyprland desktop environment"
	@echo "  security    - Apply security hardening"
	@echo "  maintenance - Run system maintenance tasks"
	@echo ""
	@echo "Testing & Quality:"
	@echo "  test        - Run validation tests"
	@echo "  vm-test     - Run VirtualBox testing (primary method)"
	@echo "  lint        - Run code quality checks"
	@echo ""
	@echo "Development & Maintenance:"
	@echo "  dev-setup   - Setup development environment"
	@echo "  status      - Check system status"
	@echo "  backup      - Backup configurations"
	@echo "  clean       - Clean temporary files"
	@echo ""

# Install Ansible and dependencies
install:
	@echo "Installing Ansible and dependencies..."
	sudo pacman -Sy --needed python python-pip
	pip install --user --break-system-packages -r requirements.txt
	ansible-galaxy install -r configs/ansible/requirements.yml

# Bootstrap system
bootstrap:
	@echo "Running system bootstrap..."
	ansible-playbook -i configs/ansible/inventory/localhost.yml configs/ansible/playbooks/bootstrap.yml

# Install desktop environment
desktop:
	@echo "Installing Hyprland desktop..."
	ansible-playbook -i configs/ansible/inventory/localhost.yml configs/ansible/playbooks/desktop.yml

# Apply security hardening
security:
	@echo "Applying security hardening..."
	ansible-playbook -i configs/ansible/inventory/localhost.yml configs/ansible/playbooks/security.yml

# Run maintenance tasks
maintenance:
	@echo "Running maintenance tasks..."
	ansible-playbook -i configs/ansible/inventory/localhost.yml configs/ansible/playbooks/maintenance.yml

# Run all configurations
full-install: bootstrap desktop security
	@echo "Full installation completed!"

# Test the installation
test:
	@echo "Running validation tests..."
	@if [ -f scripts/testing/test_installation.sh ]; then \
		bash scripts/testing/test_installation.sh; \
	else \
		echo "Test scripts not found"; \
	fi

# Run VirtualBox testing (primary testing method)
vm-test:
	@echo "Running VirtualBox testing..."
	@echo "This requires a VirtualBox VM with Arch Linux ISO"
	@echo "Follow the guide: docs/virtualbox-testing-guide.md"
	@echo ""
	@echo "Quick test command for VM:"
	@echo "curl -fsSL https://raw.githubusercontent.com/LyeosMaouli/lm-archlinux-desktop/main/scripts/testing/auto_vm_test.sh | bash"

# Lint Ansible files and scripts
lint:
	@echo "Running code quality checks..."
	@command -v ansible-lint >/dev/null 2>&1 && ansible-lint configs/ansible/ || echo "ansible-lint not found, skipping"
	@command -v yamllint >/dev/null 2>&1 && yamllint configs/ansible/ || echo "yamllint not found, skipping"
	@command -v shellcheck >/dev/null 2>&1 && find scripts/ -name "*.sh" -exec shellcheck {} \; || echo "shellcheck not found, skipping"

# Clean temporary files
clean:
	@echo "Cleaning temporary files..."
	find . -name "*.retry" -delete
	find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	find . -name "*.pyc" -delete
	sudo rm -rf /tmp/ansible-* /tmp/yay-* 2>/dev/null || true

# Development helpers
dev-setup:
	@echo "Setting up development environment..."
	@echo "Installing development tools..."
	pip install --user --break-system-packages ansible-lint yamllint
	@echo "Development environment ready!"
	@echo "Run 'make lint' to check code quality"
	@echo "Run 'make vm-test' for VirtualBox testing"

# Check system status
status:
	@echo "System Status:"
	@echo "=============="
	systemctl status sddm --no-pager || true
	systemctl status NetworkManager --no-pager || true
	ufw status || true
	fail2ban-client status || true

# Backup configuration
backup:
	@echo "Creating configuration backup..."
	@mkdir -p backup/$(shell date +%Y%m%d_%H%M%S)
	@cp -r configs backup/$(shell date +%Y%m%d_%H%M%S)/
	@echo "Backup created in backup/$(shell date +%Y%m%d_%H%M%S)/"

# Configuration management targets
config-generate:
	@echo "Generating all configuration files from master config..."
	@./scripts/utils/config_manager.sh generate

config-validate:
	@echo "Validating master configuration..."
	@./scripts/utils/config_manager.sh validate

config-clean:
	@echo "Removing all generated configuration files..."
	@./scripts/utils/config_manager.sh clean