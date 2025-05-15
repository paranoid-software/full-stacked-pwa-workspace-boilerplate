# Metals

This branch provides a comprehensive development environment for Progressive Web Applications (PWAs), with ready-to-use infrastructure components and services. It's designed to streamline the setup of a complete development workspace using Docker containers, allowing developers to focus on building applications rather than configuring infrastructure.

## Development Environment

A pre-configured development container is available using the .devcontainer setup, which includes:

- Python 3.9 environment
- Docker extension for container management
- MongoDB extensions for database interaction
- REST client for API testing
- Code formatting with Prettier
- Database client tools

## Overview

The workspace is built around a concept of "metals" - essential infrastructure services required for modern web application development. These services are containerized and organized to work together seamlessly through a shared Docker network.

## Metals

Our workspace requires the following "metals" to be operative:

| Metal           | Container Name | Purpose                                  | Port(s)                    |
|-----------------|----------------|------------------------------------------|----------------------------|
| RabbitMQ        | the-rabbit     | Message broker for asynchronous communication | 9005 (management), 9007 (AMQP) |
| MongoDB 4 Rocket| biscuit        | Document database for Rocket service     | 9017                       |
| MongoDB 4 CMS   | oreo           | Document database for CMS                | 9019                       |
| Elasticsearch   | kit-kat        | Search engine for Rocket service         | 9002 (HTTP), 9003 (transport) |
| PostgreSQL      | macarons       | Relational database for structured data  | 9004                       |
| Redis           | hit            | In-memory data structure store           | 36379                      |
| n8n             | n8n            | Workflow automation tool                 | 5678                       |
| Rocket API      | api            | RESTful API service                      | 8000                       |
| Rocket Bridge   | bridge         | Bridge service for Rocket                | 8001                       |
| Rocket Indexer  | indexer        | Indexing service for Rocket              | 8002                       |

## Rocket

### Configuration

The Rocket services (API, Bridge, and Indexer) require configuration files that are mounted into their respective containers. Based on the docker-compose.yaml file, these are the configurations needed:

```
.metals/apps/rocket/_/etc/rocket/api/      # API configuration files
.metals/apps/rocket/_/etc/rocket/bridge/   # Bridge configuration files
.metals/apps/rocket/_/etc/rocket/indexer/  # Indexer configuration files
.metals/apps/rocket/_/etc/rocket/auth/     # Shared authentication files
```

#### Configuration Files

Before starting the Rocket services, review the necessary configuration files located at:

```
.metals/apps/rocket/_/etc/rocket/api/default.json
.metals/apps/rocket/_/etc/rocket/bridge/default.json
.metals/apps/rocket/_/etc/rocket/indexer/default.json
.metals/apps/rocket/_/etc/rocket/auth/cookie.monsta
```

### API Testing

The repository includes a sample HTTP playground file (.metals/apps/rocket/playground.http) for testing the Rocket API endpoints. You can use the VS Code REST Client extension to run these requests directly from the editor.

Example endpoints:

- Health check
- Authentication token generation
- Application creation
- Sample object for "Tasks" creation and retrieval

## Network Setup

To avoid complexity in communications between services, we start by creating a "main" network that will be shared among metals and applications:

```bash
docker network create main
```

## Environment Configuration

Each docker-compose.yaml file relies on environment variables that should be defined in corresponding .env files:

1. Persistence Environment Variables (.metals/persistence/.env)

### MongoDB "biscuit" credentials (for Rocket)

```
BISCUIT_SA_USERNAME=admin
BISCUIT_SA_PASSWORD=<your-password>
```

### MongoDB "oreo" credentials (for Elemental CMS)

```
OREO_SA_USERNAME=admin
OREO_SA_PASSWORD=<your-password>
```

### PostgreSQL "macarons" credentials

```
MACARONS_SA_USERNAME=postgres
MACARONS_SA_PASSWORD=<your-password>
MACARONS_DB=postgres
```

2. Messaging Environment Variables (.metals/messaging/.env)

### RabbitMQ credentials

```
THE_RABBITMQ_DEFAULT_USER=admin
THE_RABBITMQ_DEFAULT_PASS=<your-password>
```

3. N8N Environment Variables (.metals/apps/n8n/.env)

### PostgreSQL connection

```
POSTGRES_USER=postgres
POSTGRES_PASSWORD=<same-as-MACARONS_SA_PASSWORD>
POSTGRES_DB=n8n
POSTGRES_NON_ROOT_USER=n8n
POSTGRES_NON_ROOT_PASSWORD=<your-password>
```

### N8N configuration

```
SUBDOMAIN=n8n
DOMAIN_NAME=yourdomain.com
GENERIC_TIMEZONE=UTC
```

## Starting Services

### Start persistence services:

```
cd .metals/persistence
docker compose up -d
```

### Start messaging services:

```
cd .metals/messaging
docker compose up -d
```

### Start Rocket services:

```
cd .metals/apps/rocket
docker compose up -d
```

### Start n8n workflow automation:

```
cd .metals/apps/n8n
docker compose up -d
```
