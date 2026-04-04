# BRG-27-labs — ISEA Lab Portfolio

**Student:** Ng Jun Rong  
**Student ID:** CT0357253  
**Module:** Infrastructure and Systems Engineering for Asia (ISEA)  
**Submission Date:** 29 March 2026  

---

## About This Repository

This repository contains all lab evidence, scripts, and configuration files for the ISEA assignment. The work spans local Linux system administration on Ubuntu 24.04 LTS (hostname: `totoro-lab`) and cloud infrastructure provisioning on Microsoft Azure, covering service management, file permissions, bash scripting, cloud deployment, DNS/TLS configuration, cron automation, and Security Information and Event Management (SIEM) deployment via Wazuh.

---

## Repository Structure

```
BRG-27-labs/
├── README.md
├── screenshots/
│   ├── 01-linux-setup/           # Section 2 — Ubuntu CLI exploration, GitHub setup
│   ├── 02-services-ssh-firewall/ # Section 3.1 — Apache, SSH, Nmap, UFW
│   ├── 03-permissions/           # Section 3.2 — alice/bob/mallory, chmod, chgrp
│   ├── 04-file-search-archive/   # Section 3.3 — find, grep, tar, bzip2
│   ├── 05-bash-scripting/        # Section 3.4 — myscript.sh, system monitoring
│   ├── 06-azure-vm/              # Section 4.1–4.3 — VM, NSG, hardening, monitoring
│   ├── 07-azure-cost/            # Section 4.4 — Cost Management, budget tracking
│   ├── 08-dns-tls/               # Section 5 — DuckDNS, Certbot DNS-01, Apache SSL
│   ├── 09-cron-backup/           # Section 6 — backup.sh, crontab, automated runs
│   └── 10-wazuh-siem/            # Section 7 — Docker Compose, Wazuh dashboard
├── scripts/
│   ├── backup.sh                 # Timestamped tar.gz backup with logging
│   └── myscript.sh               # System monitoring script (whoami, df -h, free -h)
└── configs/
    └── crontab-entry.txt         # Cron schedule: 0 2 * * * /bin/bash ~/scripts/backup.sh
```

> **Note:** If you are viewing this repo for marking, the full written report (with reflections and analysis) is in the submitted `.docx` file. This repo holds the raw evidence and scripts referenced in that report.

---

## Lab Evidence Summary

### Section 2 — Linux Environment Setup & GitHub Integration
| Evidence | Description |
|----------|-------------|
| GitHub repo screenshot | Repo created under `T0tooro`, commits visible |
| CLI exploration | `pwd`, `ls`, `cd`, `man`, listing `/etc` directory |

### Section 3.1 — Service Configuration (Apache, SSH, Nmap)
| Evidence | Description |
|----------|-------------|
| `systemctl` outputs | `apache2` and `ssh` started, stopped, status verified |
| `systemctl list-units` | Full active service list: apache2, ssh, docker, cron, rsyslog |
| Nmap localhost scan | Ports 22 (SSH), 80 (HTTP), 631 (IPP) confirmed open |

### Section 3.2 — File Permissions & Group Access Control
| Evidence | Description |
|----------|-------------|
| User creation | `alice`, `bob`, `mallory` created via `adduser` |
| Group setup | `sharedgroup` created, alice/bob added via `usermod -aG` |
| Permission test | `chmod 770` on `/home/shared/`, mallory denied, alice/bob permitted |
| Sudo escalation | `mallory` added to sudo group, `groups mallory` confirmed |

### Section 3.3 — File Search, Analysis & Archiving
| Evidence | Description |
|----------|-------------|
| `find` and `grep` | `find /etc -name '*.conf'`, `grep -r 'nameserver' /etc/` |
| Compression pipeline | `wget` books from Gutenberg → `tar cf` → `bzip2` → `books.tar.bz2` (317K) |

### Section 3.4 — Bash Scripting
| Evidence | Description |
|----------|-------------|
| `myscript.sh` | Heredoc script displaying `whoami`, `df -h`, `free -h` |
| Execution | `chmod +x`, script output screenshot |

### Section 4.1–4.3 — Azure VM Deployment, Hardening & Monitoring
| Evidence | Description |
|----------|-------------|
| VM provisioned | `vm-webserver-01`, Ubuntu 24.04, Standard E2s v3, Southeast Asia |
| Network layout | VNet `vnet-security-lab`, subnets `snet-public` (10.0.1.0/24) and `snet-private` (10.0.2.0/24) |
| NSG rules | `nsg-public` (HTTP/HTTPS from internet), `nsg-private` (SSH from specific IP only) |
| Hardening (Phase 3) | Public IP removed, SSH blocked, HTTP blocked — verified via ERR_EMPTY_RESPONSE |
| Monitoring (Phase 4) | Azure Monitor dashboard, CPU stress test (89.94%), High-CPU-Alert fired at 12:05 PM |
| Alert email | Email from `azure-noreply@microsoft.com` received at 12:13 PM |

### Section 4.4 — Azure Cost Analysis
| Evidence | Description |
|----------|-------------|
| Cost breakdown | December 2025: USD $0.59 total — Public IP $0.31, Disk $0.21, VM $0.07 |
| Budget | $5.00/month budget configured in Azure Cost Management |

### Section 5 — DNS Setup & TLS Certificate
| Evidence | Description |
|----------|-------------|
| DuckDNS domain | `t0tooro.duckdns.org` → `138.75.96.0` |
| DNS verification | `nslookup` and `dig` confirming A record, NOERROR, TTL 52s |
| Certbot DNS-01 | TXT record deployed via DuckDNS API (`curl`), verified with `dig TXT` |
| Certificate issued | Let's Encrypt cert valid 89 days (expires 2026-06-27) |
| Apache SSL config | `a2enmod ssl`, `a2ensite default-ssl`, cert paths configured |

### Section 6 — Automation & Cron Jobs
| Evidence | Description |
|----------|-------------|
| `backup.sh` | Timestamped `tar.gz` of `~/test-folder`, logs to `~/backups/backup.log` |
| Cron testing | `* * * * *` (every minute) — log entries at 15:09, 15:10, 15:11, 15:12 |
| Production cron | `0 2 * * *` (daily 02:00 AM) |
| Automated archives | 8 backup archives generated without manual intervention |

### Section 7 — Wazuh SIEM (Additional Server Service)
| Evidence | Description |
|----------|-------------|
| Docker Compose deployment | `wazuh.indexer` (9200), `wazuh.manager` (1514-1515, 514, 55000), `wazuh.dashboard` (443/5601) |
| Dashboard | 2 active agents, 527 Medium alerts, 1,100 Low alerts (baseline noise) |
| Modules visible | Malware Detection, File Integrity Monitoring (FIM), MITRE ATT&CK, Vulnerability Detection |

---

## Scripts

### `backup.sh`
```bash
#!/bin/bash

# Backup script with logging
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR=~/backups
LOG_FILE=~/backups/backup.log

mkdir -p $BACKUP_DIR

echo "[$DATE] Starting backup..." >> $LOG_FILE
tar -czf $BACKUP_DIR/backup_$DATE.tar.gz ~/test-folder 2>> $LOG_FILE
echo "[$DATE] Backup completed: backup_$DATE.tar.gz" >> $LOG_FILE
echo "[$DATE] Disk usage: $(df -h ~ | tail -1)" >> $LOG_FILE
```

### Cron Entry
```
0 2 * * * /bin/bash /home/totoro/scripts/backup.sh
```
> During testing, schedule was set to `* * * * *` (every minute) to verify automatic execution.

---

## Tools & Platforms Used

| Tool | Purpose |
|------|---------|
| Ubuntu 24.04 LTS | Local Linux lab environment (`totoro-lab`) |
| Microsoft Azure | Cloud VM provisioning, NSG, Monitor, Cost Management |
| Apache HTTP Server | Web server (local + cloud) |
| DuckDNS | Free Dynamic DNS (DDNS) for domain `t0tooro.duckdns.org` |
| Certbot / Let's Encrypt | TLS certificate issuance via DNS-01 challenge |
| Wazuh (Docker Compose) | Open-source SIEM / XDR platform |
| Git / GitHub | Version control and evidence repository |
| Nmap | Port scanning and service enumeration |

---

## Frameworks Referenced

- **MITRE ATT&CK** — Technique mapping (T1053.003 Cron, T1070 Indicator Removal) via Wazuh integration
- **NIST SP 800-61** — Computer Security Incident Handling Guide
- **SANS Institute** — Incident response methodology

---

## Contact

Ng Jun Rong — CT0357253  
GitHub: [@T0tooro](https://github.com/T0tooro)
