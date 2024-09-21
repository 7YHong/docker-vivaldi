FROM ghcr.nju.edu.cn/linuxserver/baseimage-kasmvnc:debianbookworm

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=vivaldi
ENV LC_ALL=en_US.UTF-8

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://vivaldi.com/favicon.ico && \
  echo "**** install packages ****" && \
  echo 'deb https://mirror.nju.edu.cn/debian/ bookworm main contrib non-free non-free-firmware\n\
  deb https://mirror.nju.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware\n\
  deb https://mirror.nju.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware\n\
  deb https://mirror.nju.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware' \
   > /etc/apt/sources.list && \
  apt-get update && \
  (cd /tmp && curl -LO https://github.com/uniartisan/fonts-harmonyos-sans-cn/releases/download/v1.0.0/harmonyos_sans.deb) && \
  (cd /tmp && curl -O https://downloads.vivaldi.com/stable/vivaldi-stable_6.9.3447.46-1_amd64.deb) && \
  dpkg -i /tmp/harmonyos_sans.deb /tmp/vivaldi*.deb || true && \
  apt-get install -fy --no-install-recommends &&\
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
