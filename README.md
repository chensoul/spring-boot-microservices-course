# Spring Boot Microservices Course

![Spring Boot Microservices course](docs/youtube-thumbnail.png)

We will build a BookStore application using Spring Boot, Spring Cloud, and Docker.

![BookStore Microservices Architecture](docs/bookstore-spring-microservices.png)

## Local Development Setup

* Install Java 21. Recommend using [SDKMAN](https://sdkman.io/)
  for [managing Java versions](https://youtu.be/ZywEiw3EO8A).
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

1. **Start all the required services such as MySQL, RabbitMQ, Keycloak, etc.:**

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

* **Nacos**: http://localhost:8838 with credentials `nacos/nacos`
* **Webapp**: http://localhost:8080 with credentials `siva/siva1234` or `prasad/prasad1234`
* **RabbitMQ**: http://localhost:15672 with credentials `guest/guest`
* **Keycloak**: http://localhost:9191 with credentials `admin/admin1234`
* **MailHog**: http://localhost:8025
* **Grafana**: http://localhost:3000 (credentials: `admin/admin1234`)
* **Prometheus**: http://localhost:9090

## Version

| Spring Boot | Spring Cloud | Spring Cloud Alibaba | Nacos | 
|-------------|--------------|----------------------|-------|
| 2.6.15      | 2021.0.9     | 2021.0.6.2           | 2.2.0 | 
| 3.0.13      | 2022.0.5     | 2022.0.0.2           | 2.2.3 | 
| 3.2.12      | 2023.0.6     | 2023.0.3.4           | 2.4.3 | 
| 3.5.10      | 2025.0.1     | 2025.0.0.0           | 3.0.3 |
| 4.0.0       | 2025.1.0     | 2025.1.0.0-SNAPSHOT  | 3.1.0 | 

## References

- https://github.com/sivaprasadreddy/bookstore
- https://github.com/Nasruddin/spring-boot-based-microservices
- https://github.com/SaiUpadhyayula/spring-boot-3-microservices-course
- https://github.com/PacktPublishing/Microservices-with-Spring-Boot-and-Spring-Cloud-Fourth-Edition
