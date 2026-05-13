# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install dependencies, generate key, migrate DB, build assets
composer setup

# Start dev environment (PHP server + queue + logs + Vite, concurrently)
composer dev

# Run tests
composer test
# or
php artisan test

# Run a single test file
php artisan test tests/Feature/ExampleTest.php

# Lint / fix code style (Laravel Pint)
./vendor/bin/pint

# Build frontend assets
npm run build

# Start Docker stack (app + MySQL 8.4 + Redis)
docker compose up -d
```

## Architecture

This is a minimal Laravel 13 authentication app — register, login, dashboard, logout — containerized for deployment to a Raspberry Pi 5 (ARM64) via GitHub Container Registry.

**Request lifecycle:**

```
routes/web.php
  → app/Http/Requests/{LoginRequest,RegistrationRequest}   (validation)
  → app/Http/Controllers/{SessionsController,RegistrationController}
  → app/Models/User
  → resources/views/auth/{login,register}.blade.php | dashboard.blade.php
```

**Routes** (`routes/web.php`): `/register` and `/login` are guest-only; `/dashboard` requires auth; `DELETE /logout` tears down the session.

**Docker** (`docker-compose.yml` / `Dockerfile`): The app runs as a plain `php:8.4-cli-alpine` container on port 8080→8000. MySQL 8.4 is the production DB; `.env.example` defaults to SQLite for local dev. Redis is available for cache/sessions.

**CI/CD** (`.github/workflows/deploy.yml`): On push, GitHub Actions builds an ARM64 Docker image and pushes it to GHCR (`ghcr.io/<owner>/cicd`).

## Environment

Copy `.env.example` to `.env` and run `php artisan key:generate`. For local development without Docker, the default SQLite config works out of the box. For Docker, the `DB_*` env vars must point to the `mysql` service.
