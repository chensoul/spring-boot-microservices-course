FROM eclipse-temurin:21.0.8_9-jre-jammy AS builder
WORKDIR extracted

ADD ./target/*.jar app.jar

RUN java -Djarmode=layertools -jar app.jar extract

FROM eclipse-temurin:21.0.8_9-jre-jammy
WORKDIR application

# Copy the dependencies layer from the builder stage
COPY --from=builder extracted/dependencies/ ./
# Copy the Spring Boot loader layer from the builder stage
COPY --from=builder extracted/spring-boot-loader/ ./
# Copy the snapshot dependencies layer from the builder stage
COPY --from=builder extracted/snapshot-dependencies/ ./
# Copy the application layer from the builder stage
COPY --from=builder extracted/application/ ./

EXPOSE 8082

# Set the entry point to launch the application
ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]

