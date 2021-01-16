FROM docker/compose:alpine-1.27.4 as compose

FROM docker:stable as goss

ENV GOSS_VERSION "0.3.16"
ENV GOSS_COMMIT "6e5d3e3"

LABEL \
  com.github.docker-suite.goss.authors="Hexosse <hexosse@gmail.com>" \
  com.github.docker-suite.goss.name="goss" \
  com.github.docker-suite.goss.description="A docker image for testing docker containers with goss, dgoss and dcgoss." \
  com.github.docker-suite.goss.licenses="MIT" \
  com.github.docker-suite.goss.source="https://github.com/docker-suite/goss" \
  com.github.docker-suite.goss.version="${GOSS_VERSION}-${GOSS_COMMIT}"

ENV PATH=/goss:$PATH


## Install docker-compose
COPY --from=compose /usr/local/bin/docker-compose /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose


# Modified version of dgoss
ADD dgoss /usr/local/bin/dgoss


## Install packages
RUN \
    # Print executed commands
    set -x \
    # Update repository indexes
    && apk update \
    # Add bash
    && apk add --no-cache bash curl \
    # Install goss
    && curl -L -o /usr/local/bin/goss https://github.com/aelsabbahy/goss/releases/download/v${GOSS_VERSION}/goss-linux-amd64 \
    && chmod +x /usr/local/bin/goss \
    # Install dgoss
    && chmod +x /usr/local/bin/dgoss \
    # Install dcgoss
    && curl -L -o /usr/local/bin/dcgoss https://raw.githubusercontent.com/aelsabbahy/goss/${GOSS_COMMIT}/extras/dcgoss/dcgoss \
    && chmod +x /usr/local/bin/dcgoss \
    # Clear cache
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

VOLUME /goss

WORKDIR /goss

CMD ["dgoss"]