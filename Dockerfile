# GoLang Build Image
FROM golang:latest AS build

# Version Variable
ENV BRIDGE_VERSION="2.1.1"

# Install Build Dependencies
RUN apt-get update && \
    apt-get install -y libsecret-1-dev

# Build Source
WORKDIR /build/
RUN git clone https://github.com/ProtonMail/proton-bridge.git && \
    cd proton-bridge && \
    git checkout v${BRIDGE_VERSION} && \
    make build-nogui

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
    socat

RUN useradd -ms /bin/bash proton
#RUN setcap 'cap_net_bind_service=+ep' /usr/bin/socat

# Copy Binary From Build Stage
COPY --from=build /build/proton-bridge/proton-bridge /proton/

# Copy scripts
COPY gpgparams entrypoint.sh login.sh /proton/

USER proton
WORKDIR /home/proton

# Start Protonmail-Bridge
ENTRYPOINT ["bash", "/proton/entrypoint.sh"]