ARG CIRCLE_PROJECT_REPONAME=libpostal
ARG DOCKER_IMAGE=centos
ARG DOCKER_VERSION=latest
ARG VCS_REF
ARG BUILD_DATE=$("date -u")

FROM ${DOCKER_IMAGE}:${DOCKER_VERSION}

LABEL   Maintainer="support@clicksend.com" \
        Description="${DOCKER_IMAGE} container that handles ${CIRCLE_PROJECT_REPONAME} sevices." \
        org.label-schema.name="${CIRCLE_PROJECT_REPONAME}" \
        org.label-schema.description="${DOCKER_IMAGE} container that handles ${CIRCLE_PROJECT_REPONAME} sevices." \
        org.label-schema.build-date=$BUILD_DATE \
        org.label-schema.vcs-ref=$VCS_REF \
        org.label-schema.schema-version="1.0.0"

ENV DEBIAN_FRONTEND=interactive \
    GO_VERSION=${GO_VERSION:-"1.11.1"} \
    GOROOT=/libpostal/go \
    GOARCH=amd64 \
    GOOS=linux \
    GOPATH=/libpostal/workspace \
    LIBPOSTAL_DATA_DIR="/opt/libpostal_data" \
    PATH=$PATH:/libpostal/go/bin \
    PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"

# Update and install packages
RUN yum update -y && \
    yum install -y autoconf \
    curl libsnappy-dev \
    automake \
    libtool \
    git \
    build-essential \
    checkinstall \
    pkg-config \
    make && \
    yum groupinstall -y "Development Tools"

COPY . /libpostal/

WORKDIR /libpostal

# Install go
RUN /libpostal/install_go.sh

# Build and install libpostal
RUN chmod +x /libpostal/*.sh && \
    chmod +x /libpostal/bin/*  && \
    /libpostal/build_libpostal.sh && \
    pkg-config --libs --cflags libpostal

# Build and install libpostal
RUN /libpostal/build_libpostal_rest.sh

EXPOSE 8080

CMD ["/libpostal/workspace/libpostal-rest"]
