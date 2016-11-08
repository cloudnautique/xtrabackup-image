FROM debian

COPY ./entrypoint.sh /entrypoint.sh
RUN apt-get update && apt-get install -y libdbd-mysql-perl \
        rsync \
        libaio1 \
        libcurl3 \
        libev4 \
        libnuma1 \
        mysql-client \
        python-minimal

ENV VERSION 2.4.4-rdf58cf2
ADD https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.4/binary/debian/jessie/x86_64/Percona-XtraBackup-${VERSION}-jessie-x86_64-bundle.tar /
RUN tar -xvf /Percona-XtraBackup-${VERSION}-jessie-x86_64-bundle.tar \
    && dpkg -i /*.deb \
    && rm -f Percona-*.tar percona-*.deb

ENTRYPOINT ["/entrypoint.sh"]
