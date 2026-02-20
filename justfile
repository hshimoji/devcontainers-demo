# Default: show available recipes
default:
    @just --list

# Check tool versions and DB connectivity
check:
    @printf '\033[1;36m--- Go ---\033[0m\n'
    @go version
    @echo ""
    @printf '\033[1;36m--- gcloud ---\033[0m\n'
    @gcloud version 2>&1 | head -1
    @echo ""
    @printf '\033[1;36m--- psql ---\033[0m\n'
    @psql --version
    @echo ""
    @printf '\033[1;36m--- just ---\033[0m\n'
    @just --version
    @echo ""
    @printf '\033[1;36m--- Docker ---\033[0m\n'
    @docker --version 2>/dev/null || echo "Docker CLI is not available"
    @echo ""
    @printf '\033[1;36m--- Codex ---\033[0m\n'
    @codex --version 2>/dev/null || echo "Codex CLI is not available"
    @echo ""
    @printf '\033[1;36m--- DB Connectivity ---\033[0m\n'
    @pg_isready -h db -p 5432 > /dev/null 2>&1 && echo "DB is available" || echo "DB is not available"
    @echo ""

# Build the application
build:
    go build -o bin/app .

# Run the application (APPENV=local by default, override with: just run prod)
run env="local":
    APPENV={{env}} go run main.go

# Run tests
test:
    go test ./...

# Check DB connectivity via psql
db-ping:
    psql -h db -p 5432 -d postgres -c "SELECT 1;"

# Show PostgreSQL version via psql
db-version:
    psql -h db -p 5432 -d postgres -c "SELECT version();"

# Open interactive psql session
db-shell:
    psql -h db -p 5432 -d postgres

# Format Go code
fmt:
    go fmt ./...

# Run go vet
vet:
    go vet ./...

# Build and run
build-run env="local": build
    APPENV={{env}} ./bin/app

# Clean build artifacts
clean:
    rm -rf bin/
