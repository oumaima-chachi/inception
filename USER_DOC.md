# User documentation — Inception

This document explains how to use the Inception stack as an end user or as
a site administrator, without needing to touch any code.

## 1. What this stack provides

Three services work together to serve a WordPress website:

| Service     | What it does                                             |
|-------------|-----------------------------------------------------------|
| `nginx`     | Receives every visitor over HTTPS (port 443) and serves the site |
| `wordpress` | Runs the WordPress CMS (PHP-FPM) that generates the pages |
| `mariadb`   | Stores all the website's content (articles, users, settings) |

Only `nginx` is reachable from outside the virtual machine; `wordpress` and
`mariadb` stay private on the internal Docker network.

## 2. Starting and stopping the project

From the root of the repository, on the virtual machine:

```bash
make        # first start: builds the images then starts everything
```

```bash
make up     # restart without rebuilding the images
```

```bash
make down   # stop everything (your data is kept)
```

```bash
make clean  # stop everything AND delete all data (irreversible)
```
