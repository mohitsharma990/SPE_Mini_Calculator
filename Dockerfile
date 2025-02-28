FROM maven as build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package


FROM openjdk:17

WORKDIR /app

COPY --from=build /app/target/SPE_MINI_CALCULATOR-1.0-SNAPSHOT.jar .

CMD ["java", "-cp", "/app/SPE_MINI_CALCULATOR-1.0-SNAPSHOT.jar", "com.mohit.Calculator"]