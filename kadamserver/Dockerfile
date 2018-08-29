FROM java:8-jre

ADD build/libs/*.war /app/kadam.war

WORKDIR /app

EXPOSE 8080
ENTRYPOINT ["java"]
CMD ["-Dgrails.env=test", "-jar", "kadam.war"]
