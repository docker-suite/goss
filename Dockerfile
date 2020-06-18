FROM docker:stable

ENV GOSS_VERSION "0.3.12"
ENV GOSS_COMMIT "b30949e"

LABEL \
  com.github.docker-suite.goss.authors="Hexosse <hexosse@gmail.com>" \
  com.github.docker-suite.goss.name="goss" \
  com.github.docker-suite.goss.description="A docker image for testing docker containers with goss, dgoss and dcgoss." \
  com.github.docker-suite.goss.licenses="MIT" \
  com.github.docker-suite.goss.source="https://github.com/docker-suite/goss" \
  com.github.docker-suite.goss.version="${GOSS_VERSION}-${GOSS_COMMIT}"

ENV PATH=/goss:$PATH

# Modified version of dgoss
ADD dgoss /usr/local/bin/dgoss

RUN \
    # Print executed commands
    set -x \
    # Update repository indexes
    apk upgrade --update-cache \
    # Add bash
    && apk add --no-cache bash \
    # Add build dependencies
    && apk add --no-cache py-pip \
    # Add build dependencies
    && apk add --no-cache curl python3-dev libffi-dev openssl-dev gcc libc-dev make --virtual .build-dependencies \
    # Install docker-compose
    && pip install docker-compose \
    # Install goss
    && curl -L -o /usr/local/bin/goss https://github.com/aelsabbahy/goss/releases/download/v${GOSS_VERSION}/goss-linux-amd64 \
    && chmod +x /usr/local/bin/goss \
    # Install dgoss
    && chmod +x /usr/local/bin/dgoss \
    # Install dcgoss
    && curl -L -o /usr/local/bin/dcgoss https://raw.githubusercontent.com/aelsabbahy/goss/${GOSS_COMMIT}/extras/dcgoss/dcgoss \
    && chmod +x /usr/local/bin/dcgoss \
    # Clear cache
    && apk del --no-cache .build-dependencies \
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

VOLUME /goss

WORKDIR /goss

CMD ["dgoss"]