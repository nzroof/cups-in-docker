cups-in-docker
==============

cups 1.7.1 inside debian:sid

For external access

```bash
docker run -e CUPS_USER_ADMIN=admin -e CUPS_USER_PASSWORD=secr3t -p 6631:631/tcp roofnz/cups-in-docker
```

For access just by trusted containers on the same isolated user defined network

```bash
docker run -e CUPS_USER_ADMIN=admin -e CUPS_USER_PASSWORD=secr3t --net=isolated_nw  roofnz/cups-in-docker
```
