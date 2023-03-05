FROM python:3

# set up for annabel
RUN mkdir /workdir
WORKDIR /workdir
RUN cd /workdir
COPY requirements.txt /workdir

RUN pip install --editable .
EXPOSE 8080


# set up for postgres
RUN mkdir /postgres 
RUN cd /postgres
WORKDIR /postgres

# install postgresql
RUN apt -y update 
RUN apt -y install vim
RUN apt -y install software-properties-common
RUN apt -y install postgresql-13
RUN apt -y install postgresql-client-13
RUN apt -y install postgresql-contrib-13


# Create a PostgreSQL role named ``annabel`` with ``annabel`` as the password and
# then create a database `annabel_db` owned by the ``annabel`` role.
#USER postgres
#RUN /etc/init.d/postgresql start && \
#    psql --command "CREATE USER annabel WITH SUPERUSER PASSWORD 'annabel';" && \
#    createdb -O annabel_db annabel
#USER root

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/13/main/pg_hba.conf

## And add ``listen_addresses`` to ``/etc/postgresql/13/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/13/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

####################################################

WORKDIR /annabel
CMD ["bash"]
