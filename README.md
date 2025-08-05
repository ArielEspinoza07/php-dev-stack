# 📦 PHP Dockerized Environment with Multi-Version, Multi-Framework & Virtual Host Support

<p>
  <a href="https://github.com/ArielEspinoza07/php-dev-stack/actions">
    <img src="https://github.com/ArielEspinoza07/php-dev-stack/actions/workflows/build-php.yml/badge.svg"  alt="Build - PHP images">
  </a>
  <a href="https://github.com/ArielEspinoza07/php-dev-stack/actions">
    <img src="https://github.com/ArielEspinoza07/php-dev-stack/actions/workflows/ci-core.yml/badge.svg"  alt="CI - Core Validation">
  </a>
  <a href="https://github.com/ArielEspinoza07/php-dev-stack/actions">
    <img src="https://github.com/ArielEspinoza07/php-dev-stack/actions/workflows/lint.yml/badge.svg"  alt="Lint - Dockerfile & Makefile">
  </a>
  <a href="https://github.com/ArielEspinoza07/php-dev-stack/actions">
    <img src="https://github.com/ArielEspinoza07/php-dev-stack/actions/workflows/framework-tests.yml/badge.svg"  alt="Framework - Laravel / Symfony Test">
  </a>
  <a href="https://github.com/ArielEspinoza07/php-dev-stack/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-green.svg" alt="License">
  </a>
</p>

This repository provides a robust and flexible development setup for any PHP-based project (Laravel, Symfony, WordPress,
etc.) using Docker, with full support for:

- ✅ Multiple PHP versions (5.6, 7.4–8.3)
- ✅ Virtual host management via `sites-available` / `sites-enabled`
- ✅ Composer and Xdebug (where supported)
- ✅ MySQL or PostgreSQL selectable per project
- ✅ Redis support
- ✅ Node.js support for frontend tools (Vite, Webpack, etc.)
- ✅ Supervisor integration for queue workers
- ✅ Centralized Makefile for streamlined DX

```
├── data/                        # Volumes (mysql, pgsql, redis)
├── docker/
│   ├── nginx/
│   │   ├── nginx.conf
│   │   ├── sites-available/    # Contains available vhosts
│   │   └── sites-enabled/      # Contains symlinks to enabled vhosts
│   ├── php/
│   │   ├── entrypoint.sh
│   │   └── [5.6 | 7.4 | 8.0 | 8.3]/ → Dockerfile + php.ini
│   └── supervisor/
│       └── supervisord.conf
├── logs/                       # Logs from services (e.g., nginx)
├── src/                        # Where your PHP projects live
├── docker-compose.yml          # Core services (nginx, php, node, redis)
├── docker-compose.mysql.yml    # Optional MySQL stack
├── docker-compose.pgsql.yml    # Optional PostgreSQL stack
├── Makefile                    # Dev command runner
```

---

## 🚀 Getting Started

### 1. Clone this boilerplate:

```bash
cp -r this-folder my-new-project
cd my-new-project
cp .env.example .env
```

### 2. Set PHP version in `.env`:

```dotenv
PHP_VERSION=8.3
```

### 3. Set database engine:

```dotenv
DB_CONNECTION=mysql# or pgsql
```

### 4. Enable a virtual host:

```bash
make enable-site site=api.local.conf
```

### 5. Add domains to `/etc/hosts`:

```plaintext
127.0.0.1 api.local
127.0.0.1 symfony.local
```

### 6. Start the stack:

```bash
make up-db         # Auto-detects DB from .env
```

---

## ⚙️ Useful Makefile Commands

| Command                                           | Description                                  |
|---------------------------------------------------|----------------------------------------------|
| make up                                           | Start default stack (nginx, php, redis)      |
| make up-mysql                                     | Start stack with MySQL                       |
| make up-pgsql                                     | Start stack with PostgreSQL                  |
| make up-db                                        | Detects DB from `.env` and runs accordingly  |
| make down                                         | Stop and remove containers                   |
| make restart                                      | Restart stack                                |
| make switch-php version=8.2                       | Change PHP version                           |
| make logs                                         | Tail container logs                          |
| make bash                                         | Open shell in PHP container                  |
| make composer-create-project project=... name=... | Run composer install                         |
| make composer-install project=...                 | Run composer install                         |
| make composer-update  project=...                 | Run composer update                          |
| make composer-require project=... package=...     | Install package via Composer                 |
| make run-php-command  project=... command=...     | Run any PHP CLI command                      |
| make run-npm-command  project=... command=...     | Run any npm command (install, run dev, etc.) |
| make enable-site site=...                         | Enable virtual host                          |
| make new-site site=...                            | Create + enable new virtual host             |

---

## ⚠️ Windows Support

This development environment is designed for **Linux/macOS** or **Windows with WSL2**.

### ✅ Recommended for Windows users

To use this setup on Windows, follow these steps:

1. Install [WSL2 (Windows Subsystem for Linux)](https://learn.microsoft.com/en-us/windows/wsl/install)
2. Install a Linux distribution (Ubuntu is recommended)
3. Ensure Docker Desktop is installed and configured to use WSL2
4. Open a WSL terminal and use `make` commands as usual:

```bash
   make up-db
   make switch-php version=8.2
   make run-php-command command="artisan migrate"
```

### 🛠️ Manual fallback (if not using WSL)

If you can't use WSL2, you may run equivalent commands manually from Git Bash or CMD (limited support):

```bash
docker compose -f docker-compose.yml -f docker-compose.mysql.yml up -d --build
docker exec -it php_project_php bash
composer install
```

```
⚠️ Note: Some Makefile logic (like sed, ln -sf, conditional execution) won't work on Windows without WSL2.
```

For full compatibility, WSL2 is strongly recommended.

---

## 🧪 PHP Version Support

| Version | Composer | Xdebug | Notes                        |
|---------|----------|--------|------------------------------|
| 5.6     | ❌        | ❌      | Legacy, limited              |
| 7.4     | ✅        | ✅      | Stable, supported            |
| 8.0+    | ✅        | ✅      | Recommended for new projects |

---

## 🧠 Notes

* Node is available for projects using modern frontend tooling (Vite, Webpack, etc.)
* Supervisor is integrated and can be configured via `.env` to run queue workers.
* Redis is included and exposed for local debugging and pub/sub dev scenarios.
* Ports for Node (e.g., Vite) are optional and can be configured dynamically.

---

## 📜 License

[MIT License](LICENSE)
