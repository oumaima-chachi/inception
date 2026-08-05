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

Wait a few seconds after `make`/`make up` before opening the site: MariaDB
and WordPress need a short time to initialize on the very first start.

## 3. Accessing the website and the admin panel

Make sure your machine's `/etc/hosts` contains a line pointing your domain
to your local machine, for example:

```
127.0.0.1 ochachi.42.fr
```

Then, in a browser:

- **Website:** `https://ochachi.42.fr`
- **Admin panel:** `https://ochachi.42.fr/wp-admin`

The certificate is self-signed (generated locally, not issued by a public
certificate authority), so your browser will show a security warning the
first time — this is expected. Click "Advanced" → "Proceed" (wording
depends on your browser) to continue.

## 4. Where to find the credentials

- Non-sensitive settings (domain, database name, usernames, emails) are in
  `srcs/.env`.
- All passwords are stored in the `secrets/` folder, one file per secret:
  - `secrets/db_password.txt` — MariaDB application user password
  - `secrets/db_root_password.txt` — MariaDB root password
  - `secrets/credentials.txt` — WordPress admin & user passwords
    (`WP_ADMIN_PASSWORD=...` / `WP_USER_PASSWORD=...`)

The WordPress admin username is defined by `WP_ADMIN_USER` in `.env`
(never a value containing "admin"/"administrator", per the school's
requirements). The associated password is in `secrets/credentials.txt`.

**Change the default passwords shipped in this repository before any real
use** — they are placeholders meant to be replaced.

The WordPress admin username is defined by `WP_ADMIN_USER` in `.env`
(never a value containing "admin"/"administrator", per the school's
requirements). The associated password is in `secrets/credentials.txt`.

**Change the default passwords shipped in this repository before any real
use** — they are placeholders meant to be replaced.

