include .env

PROJECTNAME := $(notdir $(CURDIR))
PID := .$(PROJECTNAME).pid
OS := $(shell echo %OS%)

# Определяем Windows или Linux/macOS
ifeq ($(OS), Windows_NT)
    OS_NAME := Windows
    HELP_CMD := powershell -ExecutionPolicy Bypass -File help.ps1
    DOCKER_BUILD := docker compose build > output.log 2>&1 &
    DOCKER_UP := docker compose up -d
    DOCKER_DOWN := docker compose down
    LOCAL_RUN_CMD := start /B go run cmd/main.go > output.log 2>&1
else
    OS_NAME := Linux
    HELP_CMD := @grep -E '^[a-zA-Z0-9_-]+:.*#' $(MAKEFILE_LIST) | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m: $$(echo $$l | cut -f 2- -d'#')\n"; done
    DOCKER_BUILD := docker compose build > output.log 2>&1 &
    DOCKER_UP := docker compose up -d
    DOCKER_DOWN := docker compose down
    LOCAL_RUN_CMD := go run cmd/main.go > output.log 2>&1 &
endif

# Выбор команды запуска в зависимости от режима
ifeq ($(RUN_MODE), docker)
    RUN_CMD := $(DOCKER_UP)
else
    RUN_CMD := $(LOCAL_RUN_CMD)
endif

.PHONY: run
run: # Run the server
	@echo "Running in $(RUN_MODE) mode on $(OS_NAME) using port:$(CORE_SERVICE_PORT)..."
	@$(RUN_CMD)

.PHONY: build
build: # Build the Docker container or prepare local binary
	@echo "Building project..."
	@$(DOCKER_BUILD)

.PHONY: down
down: # Stop the docker container
	@$(DOCKER_DOWN)

.PHONY: up
up: # Run the docker container
	@$(DOCKER_UP)

.PHONY: help
help: # Show help for each Makefile command
	@$(HELP_CMD)

.PHONY: install
install: # Install missing dependencies
	@echo "Installing dependencies..."
	@go mod tidy

.PHONY: restart
restart: # Restart the server
ifeq ($(RUN_MODE), docker)
	@$(DOCKER_DOWN)
	@$(DOCKER_UP)
else
	@$(LOCAL_RUN_CMD)
endif

.PHONY: stop
stop: # Stop the server
	@if exist $(PID) for /f %%i in ('type $(PID)') do taskkill /F /PID %%i
	@if exist $(PID) del /Q $(PID)

.PHONY: compile
compile: # Compile the Go application
	@echo "Building binary..."
	@go build -o $(PROJECTNAME) cmd/main.go

.PHONY: clean
clean: # Clean build artifacts
	@echo "Cleaning cache..."
	@go clean

.PHONY: test
test: # Run tests using Docker
	@echo "Running tests..."
	@docker compose --profile test -f docker-compose.test.yml up -d
