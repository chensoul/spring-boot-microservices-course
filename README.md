# Spring Boot Microservices Course

![Spring Boot Microservices course](docs/youtube-thumbnail.png)

We will build a BookStore application using Spring Boot, Spring Cloud, and Docker.

![BookStore Microservices Architecture](docs/bookstore-spring-microservices.png)

## Learning Objectives
* Building Spring Boot REST APIs
* Database Persistence using Spring Data JPA, Postgres, Flyway
* Event Driven Async Communication using RabbitMQ
* Implementing OAuth2-based Security using Spring Security and Keycloak
* Implementing API Gateway using Spring Cloud Gateway
* Implementing Resiliency using Resilience4j
* Job Scheduling with ShedLock-based distributed Locking
* Using RestClient, Declarative HTTP Interfaces to invoke other APIs
* Creating Aggregated Swagger Documentation at API Gateway
* Local Development Setup using Docker, Docker Compose and Testcontainers
* Testing using JUnit 5, RestAssured, Testcontainers, Awaitility, WireMock
* Building Web Application using Thymeleaf, Alpine.js, Bootstrap
* Observability using Grafana, Prometheus, Loki, Tempo, Fluent Bit

## Local Development Setup
* Install Java 17. Recommend using [SDKMAN](https://sdkman.io/) for [managing Java versions](https://youtu.be/ZywEiw3EO8A).
* Install [Docker Desktop](https://www.docker.com/products/docker-desktop/)
* Install [IntelliJ IDEA](https://www.jetbrains.com/idea) or any of your favorite IDE
* Install [Taskfile](https://taskfile.dev/) utility

```shell
$ curl -s "https://get.sdkman.io" | bash
$ source "$HOME/.sdkman/bin/sdkman-init.sh"
$ sdk env install
$ brew install go-task
```

### How to run the application locally?

1. **Start all the required services such as Postgres, RabbitMQ, Keycloak, etc.:**

```shell
$ task start_infra
```

2. **Start individual microservices:**
  You can start individual microservices by running their respective main entrypoint classes from IDE: 

- `ApiGatewayApplication`
- `CatalogServiceApplication`
- `OrderServiceApplication`
- `NotificationServiceApplication`
- `WebappApplication`

3. **Access the application** 

* **Webapp**: http://localhost:8080 with credentials `siva/siva1234` or `prasad/prasad1234`
* **Catalog Service Postgres DB**: `jdbc:postgresql://localhost:15432/postgres` with credentials `postgres/postgres`
* **Order Service Postgres DB**: `jdbc:postgresql://localhost:25433/postgres` with credentials `postgres/postgres`
* **RabbitMQ**: `http://localhost:15672` with credentials `guest/guest`
* **Keycloak**: `http://localhost:9191` with credentials `admin/admin1234`
* **MailHog**: `http://localhost:8025`

#### Option 2: Run all the infra components and applications using Docker Compose

1. **Rebuild Docker images** to include the new Docker profile configurations:
```bash
$ task build
# or
$ task docker-build
```

2. **Start Services**

```shell
$ task start
```

3. **Access the application** at http://localhost:8080

## Run the application with Observability Stack

1. **Rebuild Docker images** to include the new Docker profile configurations:
```bash
$ task build
# or
$ task docker-build
```

2. **Create .env file** to enable distributed tracing:
```bash
$ cd deployment/docker-compose
$ echo "MANAGEMENT_TRACING_ENABLED=true" > .env
```

3. **Start Services**

Start Grafana, Tempo, Loki, Prometheus using `$ task start_o11y`

ReStart the application using `$ task restart`

4. **Access Observability Tools**

* **Grafana**: http://localhost:3000 (credentials: `admin/admin1234`)
  - Pre-configured data sources: Prometheus, Tempo, Loki
  - Autoloaded dashboards: Spring Boot 3 Statistics
* **Prometheus**: http://localhost:9090
  - Check targets at: http://localhost:9090/targets
* **Tempo**: Accessible via Grafana Explore
* **Loki**: Accessible via Grafana Explore

## References

- https://github.com/sivaprasadreddy/bookstore
- https://github.com/Nasruddin/spring-boot-based-microservices
- https://github.com/SaiUpadhyayula/spring-boot-3-microservices-course
- https://github.com/PacktPublishing/Microservices-with-Spring-Boot-and-Spring-Cloud-Fourth-Edition
