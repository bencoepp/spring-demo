FROM maven:3.9.4-eclipse-temurin-21 AS builder

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src

RUN mvn clean package -DskipTests

FROM openjdk:21-slim

RUN useradd --uid 1000 --create-home appuser

EXPOSE 8080

COPY --from=builder /app/target/demo-0.0.1-SNAPSHOT.jar /home/appuser/app.jar

USER appuser

ENTRYPOINT ["java", "-jar", "/home/appuser/app.jar"]