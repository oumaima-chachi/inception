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
