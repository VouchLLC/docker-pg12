FROM canvouch/ubuntu2004

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

RUN apt-get update

RUN apt-get install --assume-yes --no-install-recommends --no-install-suggests \
    postgresql-12 \
    postgresql-client-12 \
    postgresql-contrib-12

RUN apt-get purge --assume-yes --auto-remove \
    --option APT::AutoRemove::RecommendsImportant=false \
    --option APT::AutoRemove::SuggestsImportant=false
RUN rm -rf /var/lib/apt/lists/*

ENV PATH "$PATH:/usr/lib/postgresql/12/bin:/docker-entrypoint-initdb.d"
ENV PGDATA /var/lib/postgresql/12/main
ENV PGUSER postgres
ENV PGTZ UTC

RUN mkdir -p /docker-entrypoint-initdb.d

COPY etc/postgresql /etc/postgresql/12/main
COPY etc/postgresql-common /etc/postgresql-common

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

RUN chown root:root /usr/local/bin/*
RUN chmod 755 /usr/local/bin/*

CMD ["postgres", "--config-file=/etc/postgresql/12/main/postgresql.conf"]
