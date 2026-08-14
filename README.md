*This project has been created as part of the 42 curriculum by ochachi.*

# Inception

## Description

Inception is a system administration project whose goal is to build a small
web infrastructure entirely with Docker, from scratch, without relying on any
pre-built image other than a minimal Debian base. The stack is orchestrated
with Docker Compose and made of three custom-built containers:

- **NGINX** — the single entry point of the infrastructure, terminating
  TLSv1.2/TLSv1.3 connections on port 443.
- **WordPress + PHP-FPM** — the CMS that generates the website's pages.
- **MariaDB** — the database engine that stores all of WordPress's content.

Each service runs in its own container, built from its own Dockerfile, and
communicates with the others through a dedicated Docker network. Website
files and the database are kept in named volumes so that data survives a
container restart.

## Instructions

### Requirements

- A virtual machine with Docker and the Docker Compose plugin installed.
- An entry in `/etc/hosts` pointing your domain to `127.0.0.1`, e.g.:
  ```
  127.0.0.1 ochachi.42.fr
  ```

### Build & run

```bash
make        # builds the images and starts every container
```

Other available targets:

| Target       | Effect                                                        |
|--------------|-----------------------------------------------------------------|
| `make up`    | Starts the containers without rebuilding                        |
| `make down`  | Stops the containers (volumes are kept)                         |
| `make clean` | Stops the containers and removes the volumes (data is lost)     |
| `make fclean`| `clean` + full Docker system cleanup                             |
| `make re`    | `fclean` then `all`                                              |

Once running, visit `https://ochachi.42.fr` in a browser (accept the
self-signed certificate warning).

See `USER_DOC.md` for day-to-day usage and `DEV_DOC.md` for a developer's
setup guide.

## Resources

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose file reference](https://docs.docker.com/compose/compose-file/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [WP-CLI documentation](https://wp-cli.org/)
- [MariaDB documentation](https://mariadb.com/kb/en/documentation/)
- 42 Inception subject (v5.3)

### AI usage

An AI assistant (Claude, Anthropic) was used during this project for the
following tasks only:

- Reviewing the finished configuration files against the subject's
  requirements and pointing out non-compliant points (e.g. TLS restriction
  missing, admin username violating the naming rule, volumes not bound to
  `/home/login/data`, secrets not being used).
- Generating documentation drafts (this README, `USER_DOC.md`,
  `DEV_DOC.md`) that were then reviewed and adapted.
- Explaining Docker/Linux concepts (PID 1, FastCGI, TLS, named volumes vs
  bind mounts) to make sure they were fully understood before being used in
  the project, in line with the school's AI usage guidelines.

No AI tool was used to blindly generate the Dockerfiles or shell scripts
without review — every generated line was read, understood, and tested
before being kept.

## Project description

### Docker usage and project sources

Each service (`nginx`, `wordpress`, `mariadb`) has its own Dockerfile under
`srcs/requirements/<service>/`, built from `debian:bookworm`. No image is
pulled from Docker Hub except this base image. Configuration files live in
each service's `conf/` folder and are copied into the image at build time;
the domain-dependent NGINX configuration is instead generated at container
startup (see `srcs/requirements/nginx/tools/setup.sh`) so it always matches
`DOMAIN_NAME`.

### Virtual Machines vs Docker

A virtual machine virtualizes an entire computer, including its own kernel,
through a hypervisor: it is heavy (several GB), slow to boot (minutes), but
very strongly isolated from the host. A Docker container only virtualizes a
process: it shares the host's kernel and is isolated through Linux
namespaces and cgroups, making it lightweight (tens of MB) and fast to start
(milliseconds), at the cost of slightly weaker isolation. This project uses
Docker because it needs several independent, reproducible services running
side by side without the overhead of one full OS per service.

### Secrets vs Environment Variables

Environment variables (stored in `srcs/.env` here) are simple key/value
pairs injected into a container; they are visible in clear text through
`docker inspect` or `docker exec env`. Docker secrets are files mounted
read-only at `/run/secrets/<name>` inside a container; their content is not
exposed through `docker inspect`. In this project, non-sensitive
configuration (domain name, database name, usernames, emails) stays in
`.env`, while every password (`db_password.txt`, `db_root_password.txt`,
`credentials.txt`) is stored under `secrets/` and read by the startup
scripts from `/run/secrets/`, never hard-coded or passed as plain
environment variables.

### Docker Network vs Host Network

With `network: host`, a container shares the host machine's network stack
directly: no isolation, and every container fighting over the same ports.
This project instead defines a dedicated bridge network (`inception`) in
`docker-compose.yml`: containers on this network get their own private IP
range and can reach each other by service name (`mariadb`, `wordpress`,
`nginx`) through Docker's internal DNS, while staying isolated from the
host's network except for the single port NGINX explicitly publishes (443).

### Docker Volumes vs Bind Mounts

A bind mount maps a host path directly into a container; the path must be
managed manually and is not portable. A named volume is managed by Docker
itself, and can still be redirected to a specific host path through
`driver_opts`. The subject requires named volumes (not bind mounts) whose
data physically lives in `/home/<login>/data`: this is achieved here with
`driver: local` + `driver_opts.device: ${HOME}/data/<volume>` in
`docker-compose.yml`, combined with `mkdir -p` in the Makefile to make sure
the target directories exist before the first `docker compose up`.