FROM python:3.10-alpine3.16

ENV PYTHONUNBUFFERED 1

COPY requirements.txt /requirements.txt
RUN apk add --upgrade --no-cache build-base linux-headers && \
    pip install --upgrade pip && \
    pip install -r /requirements.txt

COPY app/ /app
WORKDIR /app

# creating a user in order not to run on root mode
RUN adduser --disabled-password --no-create-home django

# Switch to the user django
USER django

# uwsgi will run our service;          4 threads;    run on foreground;                             app.wsgi will be auto created by Django;
CMD ["uwsgi", "--socket", ":9000", "--workers", "4", "--master", "--enable-threads", "--module", "app.wsgi"]