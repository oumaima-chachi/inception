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

Both `srcs/.env` and every file under `secrets/` contain confidential or
environment-specific data and **must be listed in `.gitignore`** — never
commit real passwords to the repository.

Edit `srcs/.env` to set your own login-based domain
(`DOMAIN_NAME=<login>.42.fr`) and edit the files in `secrets/` to replace
the placeholder passwords with your own before deploying for real.

## 5. Notes on secrets handling

Passwords are never passed as plain environment variables nor hard-coded in
any Dockerfile. Instead:

- `docker-compose.yml` declares each secret file under a top-level
  `secrets:` key and lists which service can access which secret.
- Docker mounts each declared secret read-only at
  `/run/secrets/<secret_name>` inside the relevant container.
- Each `setup.sh` script reads the password directly from that path
  (e.g. `MYSQL_PASSWORD=$(cat /run/secrets/db_password)`), keeping it out
  of `docker inspect`, `docker exec env`, and process listings.

