ARG NEWRELIC_VERSION
ARG CIRCLE_PROJECT_REPONAME=libpostal-rest-docker
ARG VCS_REF
ARG BUILD_DATE=$("date -u")

ARG GO_VERSION=1.11.1
ARG ALPINE_VERSION=3.8

FROM golang:${GO_VERSION}-alpine${ALPINE_VERSIOM}

RUN date -u

LABEL   Maintainer="support@clicksend.com" \
        Description="Go container based on alpine that handles ${CIRCLE_PROJECT_REPONAME} sevices." \
        org.label-schema.name="${CIRCLE_PROJECT_REPONAME}" \
        org.label-schema.description="Go container based on alpine that handles ${CIRCLE_PROJECT_REPONAME} sevices." \
        org.label-schema.build-date=$BUILD_DATE \
        org.label-schema.vcs-ref=$VCS_REF \
        org.label-schema.schema-version="1.0.0"

RUN apk update && apk upgrade
RUN apk --update --no-cache add --virtual .build-deps \
        autoconf \
        automake \
        curl \
        gcc \
        g++ \
        libtool \
        make \
        pkgconfig \
        git \
        sed \
        parallel

WORKDIR /go/
COPY . /go/

# Get data/parser/language files (no ned to recompile/check EVERY time)
ENV LIBPOSTAL_DATADIR=/tmp
ENV LIBPOSTAL_VERSION=v1.0.0
ENV LIBPOSTAL_DATA_FILE="libpostal_data.tar.gz"
ENV LIBPOSTAL_PARSER_FILE="parser.tar.gz"
ENV LIBPOSTAL_LANG_CLASS_FILE="language_classifier.tar.gz"
ENV PARALLEL_WORKERS=12

RUN echo "Downloading libpostal data files"
RUN touch "${LIBPOSTAL_DATADIR}/$LIBPOSTAL_DATA_FILE"
RUN touch "${LIBPOSTAL_DATADIR}/$LIBPOSTAL_PARSER_FILE"
RUN touch "${LIBPOSTAL_DATADIR}/$LIBPOSTAL_LANG_CLASS_FILE"

RUN echo "Getting ${LIBPOSTAL_DATA_FILE}"
RUN wget "https://github.com/openvenues/libpostal/releases/download/${LIBPOSTAL_VERSION}/$LIBPOSTAL_DATA_FILE" \
    -O "${LIBPOSTAL_DATADIR}/$LIBPOSTAL_DATA_FILE" \
    | parallel -j ${PARALLEL_WORKERS}

RUN echo "Getting ${LIBPOSTAL_PARSER_FILE}"
RUN wget "https://github.com/openvenues/libpostal/releases/download/${LIBPOSTAL_VERSION}/$LIBPOSTAL_PARSER_FILE" \
    -O "${LIBPOSTAL_DATADIR}/$LIBPOSTAL_PARSER_FILE" \
    | parallel -j ${PARALLEL_WORKERS}

RUN echo "Getting ${LIBPOSTAL_LANG_CLASS_FILE}"
RUN wget "https://github.com/openvenues/libpostal/releases/download/${LIBPOSTAL_VERSION}/$LIBPOSTAL_LANG_CLASS_FILE" \
    -O "${LIBPOSTAL_DATADIR}/$LIBPOSTAL_LANG_CLASS_FILE" \
    | parallel -j ${PARALLEL_WORKERS}

#COPY ./libpostal.sh .
#RUN chmod +x ./libpostal.sh
#RUN ./libpostal.sh

#COPY libpostal_rest.sh /go/src/app
#RUN chmod +x /go/src/app/libpostal/compile_libpostal.sh
#RUN /go/src/app/libpostal/compile_libpostal.sh

#CMD /libpostal/workspace/bin/libpostal-rest
#CMD ["./libpostal_rest.sh"]

#RUN go install -v /go/src/app/libpostal-rest

#COPY libpostal /go/src/app/libpostal

# Fix Alpine issue
RUN ./build_libpostal.sh
#RUN ./build_libpostal_rest.sh
#RUN go install libpostal-rest

EXPOSE 8080

#CMD /go/src/app/workspace/bin/libpostal-rest

CMD ["go", "install", "libpostal-rest"]

