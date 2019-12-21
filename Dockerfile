FROM openjdk:13-jdk-alpine

ARG version
ENV version=$version

COPY target/documentation-$version.jar /usr/spring/documentation.jar

WORKDIR /usr/spring

RUN sh -c 'touch documentation.jar'

ENTRYPOINT java -jar -Dspring.profiles.active=prod documentation.jar