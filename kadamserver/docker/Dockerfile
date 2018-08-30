FROM java:8-jre

EXPOSE 8080

RUN mkdir /app

ADD https://github.com/pkdm1989/kadamserver/releases/download/v1.0/root.war /app/root.war

WORKDIR /app
CMD ["java", "-Dgrails.env=prod", "-jar", "root.war" ]