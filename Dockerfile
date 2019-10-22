FROM maven AS build
#WORKDIR /usr/src/app
#COPY pom.xml .
#RUN mvn -B -e -C -T 1C org.apache.maven.plugins:maven-dependency-plugin:3.0.2:go-offline
#COPY . .
#RUN mvn -B -e -o -T 1C verify

COPY pom.xml .

COPY ./src/ usr/local/service/src
COPY ./pom.xml usr/local/service
COPY ./application.yml usr/local/service
WORKDIR /usr/local/service

RUN ls



RUN mvn clean install

RUN ls


# package without maven
FROM openjdk:8-jdk-alpine
WORKDIR usr/local/service
COPY --from=build /usr/local/service/application.yml ./
COPY --from=build /usr/local/service/target/pg-queuemanager-v1.0.0.jar ./

EXPOSE 6501

RUN ls

CMD ["java","-jar","pg-queuemanager-v1.0.0.jar"]
