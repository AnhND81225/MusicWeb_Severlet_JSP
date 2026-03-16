FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

COPY pom.xml .
RUN mvn -q -DskipTests dependency:go-offline

COPY src ./src
RUN mvn -q -DskipTests package

FROM tomcat:11.0
WORKDIR /usr/local/tomcat

COPY --from=build /app/target/MusicWeb_ASM_PRJ301-1.0-SNAPSHOT.war webapps/ROOT.war

RUN rm -rf webapps/ROOT

COPY docker/run-tomcat.sh /usr/local/bin/run-tomcat.sh
RUN chmod +x /usr/local/bin/run-tomcat.sh

EXPOSE 8080

CMD ["/usr/local/bin/run-tomcat.sh"]
