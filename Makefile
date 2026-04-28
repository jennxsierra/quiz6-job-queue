# Load environment variables
include .envrc
ECHO_PREFIX = [make]

# ==================================================================================== #
# DEVELOPMENT
# ==================================================================================== #

## run: Start the API server
.PHONY: run
run:
	@echo "$(ECHO_PREFIX) Starting the API server on port ${PORT}..."
	@go run ./cmd/app \
		-db-dsn=${DB_DSN} \
		-port=${PORT}

# ==================================================================================== #
# DEMO
# ==================================================================================== #


# ==================================================================================== #
# DATABASE
# ==================================================================================== #

## db/psql: Connect to the database using psql
.PHONY: db/psql
db/psql:
	@psql '$(DB_DSN)'

# ==================================================================================== #
# MIGRATIONS
# ==================================================================================== #

## db/migrations/new name=$1 : Create new migration files
.PHONY: db/migrations/new
db/migrations/new:
	@test -n '$(name)' || (echo 'Usage: make db/migrations/new name=create_table' && exit 1)
	@echo 'Creating migration files for $(name)...'
	migrate create -seq -ext=.sql -dir=./migrations $(name)

## db/migrations/up: Apply all up migrations
.PHONY: db/migrations/up
db/migrations/up:
	@echo 'Running up migrations...'
	migrate -path ./migrations -database '$(DB_DSN)' up

## db/migrations/down: Apply all down migrations (revert all)
.PHONY: db/migrations/down
db/migrations/down:
	@echo 'Reverting all migrations...'
	migrate -path ./migrations -database '$(DB_DSN)' down

## db/migrations/goto version=$1: Go to specified migration version
.PHONY: db/migrations/goto
db/migrations/goto:
	@echo 'Going to migration version ${version}...'
	migrate -path ./migrations -database '${DB_DSN}' goto ${version}

## db/migrations/fix version=$1: Force the migration to a specific version
.PHONY: db/migrations/fix
db/migrations/fix:
	@test -n '$(version)' || (echo 'Usage: make db/migrations/fix version=1' && exit 1)
	@echo 'Forcing migration version to $(version)...'
	migrate -path ./migrations -database '${DB_DSN}' force $(version)