FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY target/News-App2-0.0.1-SNAPSHOT.jar ./

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "/app/News-App2-0.0.1-SNAPSHOT.jar"]