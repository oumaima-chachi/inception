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

## 2. Building and launching the project

```bash
make       # creates $HOME/data/{mariadb,wordpress} then runs
           # docker compose -f srcs/docker-compose.yml up --build
```

Internally, the Makefile only wraps Docker Compose commands:

| Target | Underlying command |
|---|---|
| `make all` | `mkdir -p` for the data dirs, then `docker compose ... up --build` |
| `make up` | `docker compose ... up` |
| `make down` | `docker compose ... down` |
| `make clean` | `docker compose ... down -v` |
| `make fclean` | `make clean` + `docker system prune -af` |
| `make re` | `make fclean` then `make all` |

Build order: `mariadb` is built and started first, then `wordpress`
(`depends_on: mariadb`), then `nginx` (`depends_on: wordpress`). Note that
`depends_on` only guarantees start **order**, not readiness — that's why
every `setup.sh` script contains its own wait loop (`mysqladmin ping`)
before doing anything else.

## 3. Managing containers and volumes

Useful `docker compose` commands (run from the repo root):

```bash
docker compose -f srcs/docker-compose.yml ps                 # container status
docker compose -f srcs/docker-compose.yml logs -f <service>  # follow logs
docker compose -f srcs/docker-compose.yml exec <service> sh  # shell into a container
docker compose -f srcs/docker-compose.yml restart <service>  # restart one service
```

Volume inspection:

```bash
docker volume ls                       # list all volumes
docker volume inspect srcs_mariadb     # see where a volume is bound on disk
```

To wipe everything (containers + volumes, i.e. all data) and rebuild from
scratch:

```bash
make re
```

## 3. Managing containers and volumes

Useful `docker compose` commands (run from the repo root):

```bash
docker compose -f srcs/docker-compose.yml ps                 # container status
docker compose -f srcs/docker-compose.yml logs -f <service>  # follow logs
docker compose -f srcs/docker-compose.yml exec <service> sh  # shell into a container
docker compose -f srcs/docker-compose.yml restart <service>  # restart one service
```

Volume inspection:

```bash
docker volume ls                       # list all volumes
docker volume inspect srcs_mariadb     # see where a volume is bound on disk
```

To wipe everything (containers + volumes, i.e. all data) and rebuild from
scratch:

```bash
make re
```

