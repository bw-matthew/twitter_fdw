FROM ubuntu

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main 9.5" > /etc/apt/sources.list.d/postgres.list
RUN apt-get install -y wget
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get install -y postgresql-9.5 postgresql-server-dev-9.5 libcurl4-openssl-dev build-essential
RUN mkdir -p /var/run/postgresql
RUN chown -R postgres:postgres /var/run/postgresql

COPY . /project

WORKDIR /project
RUN make && make install

USER postgres

ENV PATH /usr/lib/postgresql/9.5/bin:$PATH
ENV PGDATA /var/lib/postgresql/data
VOLUME /var/lib/postgresql/data

EXPOSE 5432

CMD ["postgres", "--config_file=/etc/postgresql/9.5/main/postgresql.conf", "--stats_temp_directory=/tmp"]
