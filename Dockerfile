FROM ubuntu:16.04
ARG COMMIT
ENV COMMIT ${COMMIT:-master}
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
    curl libsnappy-dev autoconf automake libtool pkg-config \
    git

WORKDIR /
RUN git clone https://github.com/openvenues/libpostal
WORKDIR /libpostal
RUN git checkout $COMMIT
COPY ./libpostal.sh .
RUN ./libpostal.sh

COPY ./libpostal_rest.sh .
RUN ./libpostal_rest.sh

COPY ./app .
COPY ./health_check.sh .
RUN ./health_check.sh

EXPOSE 8080 8081

COPY ./entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT entrypoint.sh