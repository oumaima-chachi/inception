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
