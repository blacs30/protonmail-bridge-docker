# GoLang Build Image
#FROM golang:latest AS build

# Version Variable
#ENV BRIDGE_VERSION="2.1.1"

# Install Build Dependencies
#RUN apt-get update && \
#    apt-get install -y libsecret-1-dev

# Build Source
#WORKDIR /build/
#RUN git clone https://github.com/ProtonMail/proton-bridge.git && \
#    cd proton-bridge && \
#    git checkout v${BRIDGE_VERSION} && \
#    make build-nogui

# Debian Base Image
FROM debian:latest

EXPOSE 1025
EXPOSE 1143

# Set default ports
ENV SMTP_PORT 1025
ENV IMAP_PORT 1143

# Login Variables
ENV USERNAME=""
ENV PASSWORD=""
ENV OTP_CODE="false"
ENV LOGIN="false"
ENV INTERACTIVE="false"

# Install dependencies
# Install dependencies and protonmail bridge
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    expect \
    libsecret-1-0 \
    pass \
    socat \
    curl \
    libcap2-bin \
    gnupg \
    grep 


RUN useradd -ms /bin/bash proton
#RUN setcap 'cap_net_bind_service=+ep' /usr/bin/socat

# Copy Binary From Build Stage
# COPY --from=build /build/proton-bridge/proton-bridge /proton/

# install protonmail bridge
ENV BRIDGE_VERSION=2.1.1
ENV BRIDGE_RELEASE=1
ENV SHA256=9c6c1daa0dac1835e72c886064b0e9a38749f96bdf47719f08eaac787d43bca7
RUN set -x; \
        curl -o bridge.deb -SL https://protonmail.com/download/bridge/protonmail-bridge_${BRIDGE_VERSION}-${BRIDGE_RELEASE}_amd64.deb \
  && echo "$SHA256 bridge.deb" | sha256sum -c - \
        && dpkg --force-depends -i bridge.deb \
        && apt-get update \
        && apt-get -y install -f --no-install-recommends \
        && rm -rf /var/lib/apt/lists/* bridge.deb

# Copy scripts
COPY gpgparams entrypoint.sh login.sh /proton/

USER proton
WORKDIR /home/proton

# Start Protonmail-Bridge
ENTRYPOINT ["bash", "/proton/entrypoint.sh"]