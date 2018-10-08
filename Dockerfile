FROM ubuntu:18.04
#FROM frolvlad/alpine-go

#ARG COMMIT
#ENV COMMIT ${COMMIT:-master}
#ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    curl libsnappy-dev autoconf automake libtool pkg-config \
    git \
    golang \
    sed \
    bash

COPY . .
WORKDIR /

COPY ./libpostal.sh .
RUN chmod +x ./libpostal.sh
RUN ./libpostal.sh

COPY ./libpostal_rest.sh .
RUN chmod +x ./libpostal_rest.sh
RUN ./libpostal_rest.sh

EXPOSE 8080

CMD /libpostal/workspace/bin/libpostal-rest
