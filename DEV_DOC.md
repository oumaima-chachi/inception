# Developer documentation — Inception

This document explains how to set up, build, and maintain the Inception
project as a developer.

## 1. Setting up the environment from scratch

### Prerequisites

- A Linux virtual machine (this project must run inside a VM, per the
  subject).
- Docker Engine + the Docker Compose plugin installed.
- Your `$HOME` on the VM should be `/home/<login>` — the two named volumes
  are bound to `$HOME/data/mariadb` and `$HOME/data/wordpress`.

### Configuration files

| File | Purpose |
|---|---|
| `srcs/.env` | Non-sensitive environment variables (domain, DB name, usernames, emails) |
| `secrets/db_password.txt` | MariaDB application user password |
| `secrets/db_root_password.txt` | MariaDB root password |
| `secrets/credentials.txt` | WordPress admin/user passwords (`KEY=value` lines) |
