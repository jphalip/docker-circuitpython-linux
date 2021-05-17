FROM debian:10-slim
ARG VERSION=6.2.0

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y build-essential pkg-config libffi-dev wget git gettext python3
RUN git clone https://github.com/adafruit/circuitpython.git
WORKDIR /circuitpython
RUN git checkout $VERSION
RUN git submodule sync --quiet --recursive
RUN git submodule update --init
RUN make -C mpy-cross
RUN cd ports/unix && make axtls && make micropython && make install
RUN apt-get purge --auto-remove -y build-essential pkg-config libffi-dev wget git gettext python3
RUN rm -rf /circuitpython
WORKDIR /
CMD ["/usr/local/bin/micropython"]