# Core Shop Service

Core Shop Service is a microservice for managing goods and orders in an online store. The project is built on Go using PostgreSQL and Redis to work with data and caching.

## Main features

- Product management: add, update, delete and view the list of products.
- Order management: create, update and view orders.
- Authentication and authorization using JWT.
- Caching of data using Redis.

## Requirements:

- Golang 1.23+
- Docker & Docker Compose
- PostgreSQL (preferably, because it runs in docker container)
- pgAdmin    (preferably, because it runs in docker container)

## Setup Instructions  

Clone the repository and set up the environment:  

```sh
git clone https://github.com/NIC-Golang/core-shop-service.git
cd core-shop-service
cp .env.example .env
```
## Available Makefile Commands:
```sh
make help       # Show available commands  
make install    # Install dependencies (go mod tidy)  
make run        # Run the server  
make stop       # Stop the server  
make restart    # Restart the server  
make compile    # Compile the application  
make clean      # Clean the build cache  
make test       # Runs unit tests in docker
```

## Running the service:
Make sure Docker Engine is running, then execute:
```
docker compose build
docker compose up
```
To stop the service:
```
docker compose down
```
