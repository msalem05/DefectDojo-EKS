FROM python:3.14-alpine@sha256:05b2b8b732ecd268fee8727a369f936f022d1321b59befd13c30ede22769dcdc AS builder

WORKDIR /app

RUN \
  apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache \
    gcc \
    build-base \
    bind-tools \
    postgresql18-client \
    xmlsec \
    git \
    util-linux \
    curl-dev \
    openssl \
    libffi-dev \
    python3-dev \
    libpq-dev 

COPY requirements.txt ./

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.14-alpine@sha256:05b2b8b732ecd268fee8727a369f936f022d1321b59befd13c30ede22769dcdc AS runner

WORKDIR /app

RUN \
  apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache \
    openjpeg \
    jpeg \
    xmlsec \
    git \
    util-linux \
    postgresql18-client \
    curl-dev \
    bash \
    openssl 

COPY --from=builder /install /usr/local

COPY \
  docker/entrypoint-celery-beat.sh \
  docker/entrypoint-celery-worker.sh \
  docker/entrypoint-initializer.sh \
  docker/entrypoint-uwsgi.sh \
  docker/wait-for-it.sh \
  docker/secret-file-loader.sh \
  docker/reach_database.sh \
  docker/reach_broker.sh /

COPY manage.py ./
COPY dojo/ ./dojo/
COPY components/ ./components

EXPOSE 8081

ENTRYPOINT ["/entrypoint-uwsgi.sh"]
