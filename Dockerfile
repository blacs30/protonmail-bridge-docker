FROM archlinux/base
LABEL maintainer="Hendrik 'T4cC0re' Meyer <dockerREMOVEME-images@t4cc0.re>"

COPY ProtonMail-Bridge-bin-1.1.0-1-x86_64.pkg.tar.xz /tmp/

RUN pacman -Sy --noconfirm socat pass gnupg grep && pacman -U --noconfirm /tmp/ProtonMail-Bridge-bin-1.1.0-1-x86_64.pkg.tar.xz
RUN useradd -ms /bin/bash proton
COPY gpgparams /
COPY initProton.sh /bin
RUN chmod +x /bin/initProton.sh
RUN rm -rf /tmp
RUN setcap 'cap_net_bind_service=+ep' /usr/bin/socat
USER proton
WORKDIR /home/proton

ENTRYPOINT /bin/initProton.sh
