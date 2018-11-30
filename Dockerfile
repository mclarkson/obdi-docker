FROM fedora:latest

COPY buildfiles/x86_64/*.rpm /tmp/

RUN dnf -qy install /tmp/obdi-[0-9]*x86_64*.rpm wget

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64

RUN chmod +x /usr/local/bin/dumb-init

COPY init.sh /sbin/init.sh

# Runs "/usr/bin/dumb-init -- /my/script --with --args"
ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]

CMD ["/sbin/init.sh"]

