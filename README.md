# tvheadend-docker

### docker-compose

Compatible with docker-compose v2 schemas.

```yaml
---
version: "2.1"
services:
  tvheadend:
    image: ghcr.io/linuxserver/tvheadend
    container_name: tvheadend
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - RUN_OPTS=<run options here> #optional
    volumes:
      - <path to data>:/config
      - <path to recordings>:/recordings
    ports:
      - 9981:9981
      - 9982:9982
    devices:
      - /dev/dri:/dev/dri #optional
      - /dev/dvb:/dev/dvb #optional
    restart: unless-stopped
```

### docker cli

```
docker run -d \
  --name=tvheadend \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e RUN_OPTS=<run options here> `#optional` \
  -p 9981:9981 \
  -p 9982:9982 \
  -v <path to data>:/config \
  -v <path to recordings>:/recordings \
  --device /dev/dri:/dev/dri `#optional` \
  --device /dev/dvb:/dev/dvb `#optional` \
  --restart unless-stopped \
  ghcr.io/linuxserver/tvheadend
```

#### Host vs. Bridge

If you use IPTV, SAT>IP or HDHomeRun, you need to create the container with --net=host and remove the -p flags. This is because to work with these services Tvheadend requires a multicast address of `239.255.255.250` and a UDP port of `1900` which at this time is not possible with docker bridge mode.
If you have other host services which also use multicast such as SSDP/DLNA/Emby you may experience stabilty problems. These can be solved by giving tvheadend its own IP using macavlan.


## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 9981` | WebUI |
| `-p 9982` | HTSP server port. |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London. |
| `-e RUN_OPTS=<run options here>` | Optionally specify additional arguments to be passed. See Additional runtime parameters. |
| `-v /config` | Where TVHeadend show store it's config files. |
| `-v /recordings` | Where you want the PVR to store recordings. |
| `--device /dev/dri` | Only needed if you want to use your AMD/Intel GPU for hardware accelerated video encoding (vaapi). |
| `--device /dev/dvb` | Only needed if you want to pass through a DVB card to the container. If you use IPTV or HDHomeRun you can leave it out. |
