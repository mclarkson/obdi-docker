FROM fedora:latest

COPY buildfiles/x86_64/*.rpm /tmp/

RUN dnf -qy install /tmp/obdi-w*x86_64*.rpm

COPY init.sh /sbin/init.sh

ENTRYPOINT ["/sbin/init.sh"]

