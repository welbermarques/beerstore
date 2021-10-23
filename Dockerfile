FROM gradle:4.7.0-jdk8-alpine AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle build --no-daemon

FROM openjdk:8u212-jdk-alpine3.9

EXPOSE 8080

RUN mkdir /app

WORKDIR /app

COPY --from=build /home/gradle/src/build/libs/*.jar /app/app.jar

CMD java -jar ./app.jar $APP_OPTIONS

