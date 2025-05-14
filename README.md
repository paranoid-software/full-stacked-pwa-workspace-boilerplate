# Metals

This branhc provides a comprehensive development environment for Progressive Web Applications (PWAs), with ready-to-use infrastructure components and services. It's designed to streamline the setup of a complete development workspace using Docker containers, allowing developers to focus on building applications rather than configuring infrastructure.

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

## Network Setup

To avoid complexity in communications between services, we start by creating a "main" network that will be shared among metals and applications:

```bash
docker network create main
```

### Environment Configuration

Each service requires environment variables to be set. You can create .env files in the respective directories:

```
.metals/persistence/.env - For database configurations
.metals/messaging/.env - For RabbitMQ configuration
.metals/apps/n8n/.env - For n8n configuration
````
