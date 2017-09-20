FROM fedora:latest

COPY buildfiles/x86_64/*.rpm /tmp/

RUN dnf -qy install /tmp/obdi-[0-9]*x86_64*.rpm

COPY init.sh /sbin/init.sh

ENTRYPOINT ["/sbin/init.sh"]

