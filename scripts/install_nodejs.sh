#!/bin/bash
set -euo pipefail

NODE_VERSION="8.9.4"

DOWNLOAD_FOLDER=${CACHE_DIR}/Downloads
mkdir -p ${DOWNLOAD_FOLDER}
DOWNLOAD_FILE=${DOWNLOAD_FOLDER}/node${NODE_VERSION}.tar.gz

export NodeInstallDir="/tmp/node$NODE_VERSION"
export NodeDir="$NodeInstallDir/node-v${NODE_VERSION}-linux-x64"

mkdir -p $NodeInstallDir

# Download the archive if we do not have it cached
if [ ! -f ${DOWNLOAD_FILE} ]; then
  # Delete any cached node downloads, since those are now out of date
  rm -rf ${DOWNLOAD_FOLDER}/node*.tar.gz

  NODE_MD5="5bda713bd4aa39394536fc48c744854b"
  URL=https://buildpacks.cloudfoundry.org/dependencies/node/node-8.9.4-linux-x64-40e8e080.tgz

  echo "-----> Download Nodejs ${NODE_VERSION}"
  curl -s -L --retry 15 --retry-delay 2 $URL -o ${DOWNLOAD_FILE}

  DOWNLOAD_MD5=$(md5sum ${DOWNLOAD_FILE} | cut -d ' ' -f 1)

  if [[ $DOWNLOAD_MD5 != $NODE_MD5 ]]; then
    echo "       **ERROR** MD5 mismatch: got $DOWNLOAD_MD5 expected $NODE_MD5"
    exit 1
  fi
else
  echo "-----> Nodejs install package available in cache"
fi

if [ ! -f $NodeDir/bin/node ]; then
  tar xzf ${DOWNLOAD_FILE} -C $NodeInstallDir
fi

if [ ! -f $NodeDir/bin/node ]; then
  echo "       **ERROR** Could not download nodejs"
  exit 1
fi

export NODE_HOME=$NodeDir
