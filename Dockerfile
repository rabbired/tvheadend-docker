FROM ubuntu:16.04
MAINTAINER Red Z rabbired@outlook.com

ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME="/root" \
LANGUAGE="en_US.UTF-8" \
LANG="en_US.UTF-8" \
TERM="xterm"

RUN \ 
echo "**** install apt-utils and locales ****" && \
  apt update && \
    apt upgrade -y && \
    apt install -y \
    apt-utils \
    locales && \
echo "**** install packages ****" && \
  apt install -y \
    curl bzip2 dbus libavahi-client3 libavahi-common-data libavahi-common3 libcap-ng0 libdbus-1-3 libdvbcsa1 libexpat1 liburiparser1 \
    tzdata && \
echo "**** generate locale ****" && \
  locale-gen en_US.UTF-8 && \
echo "**** add s6 overlay ****" && \
  cd /tmp && \
    curl -fLO https://glare.now.sh/just-containers/s6-overlay/s6-overlay-amd64.tar.gz && \
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude="./bin" && \
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin && \
    ln -s /usr/bin/export /bin/ && \
    ln -s /usr/bin/s6-overlay-preinit /bin/ && \
    ln -s /usr/bin/importas /bin/ && \
    ln -s /usr/bin/execlineb /bin/ && \
    ln -s /usr/bin/exec /bin/ && \
echo "**** create abc user and make our folders ****" && \
  useradd -u 911 -U -d /config -s /bin/false abc && \
  usermod -G users abc && \
echo "**** add tvheadend ****" && \
  curl -fL http://tvheadend.cn/download-ubuntu.php?file=tvheadend-4.3-1804%7Egebb0968-ubuntu_amd64-1.deb -o tvheadend.deb && \
  dpkg -i tvheadend.deb && \
  mkdir -p \
    /app \
    /config \
    /defaults && \
  mv /usr/bin/with-contenv /usr/bin/with-contenvb && \
  /bin/bash -l -c 'echo export VERSION_CODENAME=`cat /etc/os-release | grep VERSION_CODENAME | sed 's/VERSION_CODENAME=//g'` >> /etc/bash.bashrc' && \
  /bin/bash -l -c 'echo export VERSION_CODENAME=`cat /etc/os-release | grep VERSION_CODENAME | sed 's/VERSION_CODENAME=//g'` > /etc/profile.d/docker_init.sh' && \
echo "**** cleanup ****" && \
  apt clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY root/ /

ENTRYPOINT ["/init"]
