FROM ubuntu:16.04
ENV GIT_REPOSITORY https://github.com/fireice-uk/xmr-stak.git
ENV XMRSTAK_CMAKE_FLAGS -DXMR-STAK_COMPILE=native -DCUDA_ENABLE=OFF -DOpenCL_ENABLE=OFF -DMICROHTTPD_ENABLE=OFF
RUN apt-get update \
    && set -x \
    && apt-get install -qq --no-install-recommends -y ca-certificates cmake g++ git make wget libhwloc-dev libssl-dev \
    && git clone $GIT_REPOSITORY \
    && cd /xmr-stak \
    && cmake ${XMRSTAK_CMAKE_FLAGS} . \
    && make \
    && cd /xmr-stak/bin/ \
    && wget --no-check-certificate https://raw.githubusercontent.com/swissinfonet/clouddocker/master/config.txt \
    && cd - \
    && mv /xmr-stak/bin/* /usr/local/bin/ \
    && rm -rf /xmr-stak \
    && apt-get purge -y -qq libhwloc-dev libssl-dev \
    && apt-get clean -qq
VOLUME /mnt
WORKDIR /mnt
ENTRYPOINT ["/usr/local/bin/xmr-stak"]
CMD ["--config /usr/local/bin/config.txt"]
