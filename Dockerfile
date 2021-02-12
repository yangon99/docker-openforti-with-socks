#
# OpenFortinet and MicroSocks
# https://github.com/adrienverge/openfortivpn
# https://github.com/rofl0r/microsocks
#

# Build openforti and microsocks
FROM alpine:latest as builder

RUN \
    cd /tmp \
    echo "Installing build dependences..."&& \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.bfsu.edu.cn/g' /etc/apk/repositories &&\
    apk add --update --no-cache \
        git build-base tar openssl-dev pkgconf autoconf automake &&\
    echo "Building OpenFortinet..." &&\
    git clone https://github.com/adrienverge/openfortivpn &&\
    cd openfortivpn &&\
    ./autogen.sh && ./configure --prefix=/usr/bin --sysconfdir=/etc && make &&\
    cd .. &&\
    echo "Building MicroSocks..." &&\
    git clone https://github.com/rofl0r/microsocks &&\
    cd microsocks &&\
    make

FROM alpine:latest

COPY --from=builder /tmp/openfortivpn/openfortivpn /usr/bin/openfortivpn
COPY --from=builder /tmp/microsocks/microsocks /usr/bin/microsocks
COPY config /etc/openfortivpn/config
COPY run-proxy /

RUN \
    echo "Installing&Configuring runtime environment..." &&\
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.bfsu.edu.cn/g' /etc/apk/repositories &&\
    echo "pppoe" >> /etc/modules &&\
    apk add --no-cache ppp bash coreutils curl &&\
    chown root:root /run-proxy && chmod 4755 /run-proxy

HEALTHCHECK --interval=2m --timeout=30s \
  CMD curl -fs http://jwxs.hebut.edu.cn/ || exit 1

ENTRYPOINT ["/run-proxy"]