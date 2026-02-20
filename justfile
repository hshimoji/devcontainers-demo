# Default: show available recipes
default:
    @just --list

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
