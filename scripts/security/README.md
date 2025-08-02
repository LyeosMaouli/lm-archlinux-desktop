# Security Scripts

Security automation scripts for system hardening, monitoring, and auditing.

## Scripts

### firewall_setup.sh
Configures UFW firewall with secure defaults.

**Features:** Restrictive policies, SSH rate limiting, desktop services, attack blocking, monitoring.

```bash
sudo ./firewall_setup.sh
```

### fail2ban_setup.sh
Intrusion prevention and automated threat response.

**Features:** SSH protection, custom filters, UFW integration, rate limiting, email notifications.

```bash
sudo ./fail2ban_setup.sh
```

### system_hardening.sh
Comprehensive system security hardening.

**Features:** Kernel tuning, SSH hardening, PAM policies, password aging, audit logging, file permissions, SUID/SGID review.

```bash
sudo ./system_hardening.sh
```

### security_audit.sh
Comprehensive security assessment and reporting.

**Features:** User audit, password policies, SSH review, firewall check, file permissions, network assessment, integrity verification.

```bash
sudo ./security_audit.sh
```

## Security Framework

**Defense in depth:** Network (UFW + fail2ban), Access Control (SSH + PAM), System Hardening (kernel + permissions), Monitoring (audit + checks), Assessment (regular audits).

**Ansible Integration:** `configs/ansible/roles/system_hardening/`, `configs/ansible/playbooks/security.yml`

**Key Files:**
- `/etc/sysctl.d/99-security-hardening.conf`
- `/etc/ssh/sshd_config.d/99-hardening.conf` 
- `/etc/fail2ban/jail.local`
- `/etc/audit/rules.d/99-security.rules`

## Usage Guidelines

1. Test in test environment first
2. Scripts auto-backup configurations
3. Verify SSH access before logout
4. Monitor logs after implementation
5. Run audits regularly

## Troubleshooting

```bash
# SSH issues
sudo sshd -t && sudo systemctl status sshd
sudo journalctl -u sshd -f

# Firewall issues
sudo ufw status verbose
sudo journalctl -u ufw -f

# Fail2ban issues
sudo fail2ban-client status
sudo journalctl -u fail2ban -f
```