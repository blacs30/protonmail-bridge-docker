FROM debian:stretch-slim
MAINTAINER mannp

# Generate locale C.UTF-8 for postgres and general locale data
ENV LANG C.UTF-8

# Set default ports
ENV SMTP_PORT 1025
ENV IMAP_PORT 1143

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
            ca-certificates \
            # Temp nano and unzip support
            nano \
            unzip \
            socat \
            pass \
			gnupg \
			grep \
            curl \
            libcap2-bin

# install protonmail bridge
ENV PM_VERSION 1.2.7
ENV PM_RELEASE 1
ENV SHA1 2ed3d699af65ba61def5440597eee58165c5e0b72926bac8cd99d0e976d2b327
RUN set -x; \
        curl -o bridge.deb -SL https://protonmail.com/download/protonmail-bridge_${PM_VERSION}-${PM_RELEASE}_amd64.deb \
  && echo "$SHA1 bridge.deb" | sha256sum -c - \
        && dpkg --force-depends -i bridge.deb \
        && apt-get update \
        && apt-get -y install -f --no-install-recommends \
        && rm -rf /var/lib/apt/lists/* bridge.deb

RUN useradd -ms /bin/bash proton
COPY gpgparams /
COPY initProton.sh /bin
RUN chmod +x /bin/initProton.sh
RUN rm -rf /tmp
RUN setcap 'cap_net_bind_service=+ep' /usr/bin/socat
USER proton
WORKDIR /home/proton

ENTRYPOINT /bin/initProton.sh
