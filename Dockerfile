ARG NEWRELIC_VERSION
ARG CIRCLE_PROJECT_REPONAME=libpostal-rest
ARG VCS_REF
ARG BUILD_DATE=$(date)

ARG GO_VERSION=1.11.1
ARG ALPINE_VERSION=3.8

FROM golang:${GO_VERSION}-alpine${ALPINE_VERSIOM}

LABEL   Maintainer="support@clicksend.com" \
        Description="Go container based on alpine that handles ${CIRCLE_PROJECT_REPONAME} sevices." \
        org.label-schema.name="service-${CIRCLE_PROJECT_REPONAME}" \
        org.label-schema.description="Go container based on alpine that handles ${CIRCLE_PROJECT_REPONAME} sevices." \
        org.label-schema.build-date=$BUILD_DATE \
        org.label-schema.vcs-ref=$VCS_REF \
        org.label-schema.schema-version="1.0.0"

RUN apk update && apk upgrade
RUN apk add --no-cache --virtual .build-deps \
        curl \
        snappy-dev \
        autoconf \
        automake \
        make \
        g++ \
        libtool \
        git \
        sed


WORKDIR /go/src/app
COPY . .

COPY ./libpostal.sh .
RUN chmod +x ./libpostal.sh
RUN ./libpostal.sh

COPY ./libpostal_rest.sh .
RUN chmod +x ./libpostal_rest.sh
#RUN ./libpostal_rest.sh

EXPOSE 8080

#CMD /libpostal/workspace/bin/libpostal-rest
#CMD ["./libpostal_rest.sh"]

RUN go install -v ./libpostal-rest

CMD ["app"]

