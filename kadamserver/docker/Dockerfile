FROM java:8-jre
VOLUME /data
EXPOSE 8080
ENV ACTIVE_PROFILE=docker

WORKDIR /app
COPY docker/entrypoint.sh entrypoint.sh
COPY build/libs/*.war kadam.war

ENTRYPOINT ["sh", "entrypoint.sh"]