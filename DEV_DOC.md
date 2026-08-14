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

## 4. Where data is stored and how it persists

Per the subject's requirements, both named volumes are bound (via
`driver_opts` in `docker-compose.yml`) to real folders on the host instead
of Docker's internal storage area:

| Volume | Host path | Contains |
|---|---|---|
| `mariadb` | `$HOME/data/mariadb` | The MariaDB database files (`/var/lib/mysql` inside the container) |
| `wordpress` | `$HOME/data/wordpress` | The WordPress installation (`/var/www/html` inside the container), shared with the `nginx` container |

Because these are real directories on the VM's filesystem, the data
survives `docker compose down`, container crashes/restarts, and even
`docker system prune`. Only `make clean` / `make fclean` (which use
`down -v`) or manually deleting `$HOME/data/` will remove this data.

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

## 6. Known behaviors worth knowing during defense

- The WordPress `setup.sh` script only runs `wp core install` if
  `wp-config.php` doesn't already exist, so restarting the `wordpress`
  container does not attempt (and fail) a second installation.
