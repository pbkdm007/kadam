FROM java:8-jre
VOLUME /data
EXPOSE 8080
ENV ACTIVE_PROFILE=docker

WORKDIR /app
COPY /kadamserver/docker/entrypoint.sh entrypoint.sh
COPY /kadamserver/build/libs/*.war kadam.war

ENTRYPOINT ["sh", "entrypoint.sh"]