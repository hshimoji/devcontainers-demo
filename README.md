# devcontainer-demo

A Dev Container sample project with Go + PostgreSQL.

## Architecture

```mermaid
graph LR
    subgraph Host["Host (macOS)"]
        VSCode[VS Code]
        pgpass[~/.pgpass]
        workspace[project dir]
    end

    subgraph Docker["Docker Compose"]
        subgraph App["app container"]
            Go[Go / gcloud / psql / just]
            pgpass_m[~/.pgpass<br/>read-only]
        end
        subgraph DB["db container"]
            PG[(PostgreSQL 17<br/>trust auth)]
        end
        vol[(postgres-data<br/>volume)]
    end

    VSCode -- "Reopen in Container" --> App
    workspace -- "bind mount" --> Go
    pgpass -- "bind mount :ro" --> pgpass_m
    Go -- "host=db:5432<br/>PGUSER=$USER" --> PG
    PG --- vol
```

## Included

- Go (latest)
- Google Cloud CLI
- PostgreSQL 17 (multi-container, trust auth)
- psql client
- just (command runner)
- VS Code extensions: Go, Markdown Preview, Docker

## Prerequisites

- Docker Desktop
- VS Code + Dev Containers extension

## Setup

1. Open this folder in VS Code
2. Run "Reopen in Container"
3. On container startup, the following happens automatically:
   - A PostgreSQL role and database are created matching the host OS username
   - `~/.pgpass` is mounted read-only into the container
   - `PGUSER` is set to the host OS username

## Usage

```bash
# List available recipes
just

# Local environment (default: APPENV=local)
just run

# Production config
just run prod

# Check DB connectivity
just db-ping
```

## Environment Config

| | local | prod |
|------|-------|------|
| Host | `db` (compose service name) | `CHANGEME` |
| Port | 5432 | 5432 |
| Auth | trust (no user/password) | `.pgpass` via libpq |

Config files: `config/local.yaml`, `config/prod.yaml`

## Notes

- `host: db` in local config refers to the docker-compose service name. Inter-container communication uses service names, not `localhost`.
- If `~/.pgpass` does not exist on the host, an empty file is created automatically on first startup. Configure it properly before connecting to production.
- PostgreSQL data is persisted via Docker named volume (`postgres-data`).
