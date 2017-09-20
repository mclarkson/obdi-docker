FROM fedora:latest

RUN dnf install -qy rpmdevtools gcc golang tar git

RUN git clone https://github.com/mclarkson/obdi.git && \
    cd obdi && \
    ./dist/jenkins-build-redhat7.sh

COPY pause.c /tmp/

RUN gcc -o /usr/sbin/pause /tmp/pause.c

ENTRYPOINT ["pause"]
