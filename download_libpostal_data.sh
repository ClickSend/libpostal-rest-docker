#!/usr/bin/env bash

# Flag to download current data files or not
export DOWNLOAD_LIBPOSTAL_DATA=${DOWNLOAD_LIBPOSTAL_DATA:-"false"}

# Libpostal ENV vars
export LIBPOSTAL_VERSION=v1.0.0
export LIBPOSTAL_DATADIR="/opt/libpostal_data"
export LIBPOSTAL_DATA_FILE="libpostal_data.tar.gz"
export LIBPOSTAL_PARSER_FILE="parser.tar.gz"
export LIBPOSTAL_LANG_CLASS_FILE="language_classifier.tar.gz"
export PARALLEL_WORKERS=20
export LIBPOSTAL_DOWNLOAD_URL="https://github.com/openvenues/libpostal/releases/download"

if [ ! -d "$LIBPOSTAL_DATADIR" ]; then
    mkdir -p $LIBPOSTAL_DATADIR
fi

echo "Downloading latest libpostal data files: - $DOWNLOAD_LIBPOSTAL_DATA, to dir: $LIBPOSTAL_DATADIR"
if [ "$DOWNLOAD_LIBPOSTAL_DATA" = "true" ] ; then
    cd "${LIBPOSTAL_DATADIR}"

    echo "Downloading libpostal data files:"

    if [ -f "${LIBPOSTAL_DATADIR}/$LIBPOSTAL_DATA_FILE" ]; then
        echo "File: ${LIBPOSTAL_DATADIR}/$LIBPOSTAL_DATA_FILE exists, no need to download"
    else
            echo "Getting ${LIBPOSTAL_DATA_FILE}"
            wget "$LIBPOSTAL_DOWNLOAD_URL/$LIBPOSTAL_VERSION/$LIBPOSTAL_DATA_FILE" | parallel --no-notice "-j$PARALLEL_WORKERS"
    fi

    if [ -f "${LIBPOSTAL_DATADIR}/$LIBPOSTAL_PARSER_FILE" ]; then
        echo "File: ${LIBPOSTAL_DATADIR}/$LIBPOSTAL_PARSER_FILE exists, no need to download"
    else
        echo "Getting ${LIBPOSTAL_PARSER_FILE}"
        wget "$LIBPOSTAL_DOWNLOAD_URL/$LIBPOSTAL_VERSION/$LIBPOSTAL_PARSER_FILE" | parallel --no-notice "-j$PARALLEL_WORKERS"
    fi

    if [ -f "${LIBPOSTAL_DATADIR}/$LIBPOSTAL_LANG_CLASS_FILE" ]; then
        echo "File: ${LIBPOSTAL_DATADIR}/$LIBPOSTAL_LANG_CLASS_FILE exists, no need to download"
    else
        echo "Getting ${LIBPOSTAL_LANG_CLASS_FILE}"
        wget "$LIBPOSTAL_DOWNLOAD_URL/${LIBPOSTAL_VERSION}/$LIBPOSTAL_LANG_CLASS_FILE" | parallel --no-notice "-j$PARALLEL_WORKERS"
    fi
fi

