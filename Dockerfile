FROM ubuntu:16.04

ENV GIT_REPOSITORY https://github.com/fireice-uk/xmr-stak.git
ENV XMRSTAK_CMAKE_FLAGS -DXMR-STAK_COMPILE=native -DCUDA_ENABLE=OFF -DOpenCL_ENABLE=OFF -DMICROHTTPD_ENABLE=OFF

RUN apt-get update \
    && set -x \
    && apt-get install -qq --no-install-recommends -y ca-certificates cmake libhwloc-dev libssl-dev \
    && git clone $GIT_REPOSITORY \
    && cd /xmr-stak \
    && cmake ${XMRSTAK_CMAKE_FLAGS} . \
    && make \
    && cd - \
    && mv /xmr-stak/bin/* /usr/local/bin/ \

    && sed -r \
        -e 's/^("pool_address" : ).*,/\1"xmrpool.eu:3333",/' \
        -e 's/^("wallet_address" : ).*,/\1"45f2tc8ME3r3LKWe65hSxYDKvF9aMeFTRKDTBqvrfusXXrbBX4DtQnjXymmDd8FdU4cfYTrvHst4tRof74UAvJpk564mXWp",/' \
        -e 's/^("pool_password" : ).*,/\1"x",/' \
        ../config.txt > /usr/local/etc/config.txt \
    
    && rm -rf /xmr-stak \
    && apt-get purge -y -qq libhwloc-dev libssl-dev \
    && apt-get clean -qq

VOLUME /mnt

WORKDIR /mnt

ENTRYPOINT ["/usr/local/bin/xmr-stak"]
CMD ["/usr/local/etc/config.txt"]
