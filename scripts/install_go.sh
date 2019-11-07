#!/bin/bash
set -euo pipefail

GO_VERSION="1.13.4"

DOWNLOAD_FOLDER=${CACHE_DIR}/Downloads
mkdir -p ${DOWNLOAD_FOLDER}
DOWNLOAD_FILE=${DOWNLOAD_FOLDER}/go${GO_VERSION}.tar.gz

export GoInstallDir="/tmp/go$GO_VERSION"
mkdir -p $GoInstallDir

# Download the archive if we do not have it cached
if [ ! -f ${DOWNLOAD_FILE} ]; then
  # Delete any cached go downloads, since those are now out of date
  rm -rf ${DOWNLOAD_FOLDER}/go*.tar.gz

  GO_SHA256="692d17071736f74be04a72a06dab9cac1cd759377bd85316e52b2227604c004c"
  URL=https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz

  echo "-----> Download go ${GO_VERSION}"
  curl -s -L --retry 15 --retry-delay 2 $URL -o ${DOWNLOAD_FILE}

  DOWNLOAD_SHA256=$(shasum -a 256 ${DOWNLOAD_FILE} | cut -d ' ' -f 1)  

  if [[ $DOWNLOAD_SHA256 != $GO_SHA256 ]]; then
    echo "       **ERROR** SHA256 mismatch: got $DOWNLOAD_SHA256 expected $GO_SHA256"
    exit 1
  fi
else
  echo "-----> go install package available in cache"
fi

if [ ! -f $GoInstallDir/go/bin/go ]; then
  tar xzf ${DOWNLOAD_FILE} -C $GoInstallDir
fi

if [ ! -f $GoInstallDir/go/bin/go ]; then
  echo "       **ERROR** Could not download go"
  exit 1
fi


