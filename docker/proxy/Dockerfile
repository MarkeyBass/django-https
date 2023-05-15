FROM nginx:1.23.0-alpine

COPY ./nginx/* /etc/nginx/
COPY ./run.sh /run.sh

# Default environment vars that can be later overiden if needed
ENV APP_HOST=app
ENV APP_PORT=9000

USER root

# installing openssl & bash - needed for the script
RUN apk add --no-cache openssl bash
# Adding executable permissions to the script
RUN chmod +x /run.sh

# serving static files
VOLUME /vol/static
# serving the cerbot challange fron the cerbot volume
VOLUME /vol/www

CMD ["/run.sh"]