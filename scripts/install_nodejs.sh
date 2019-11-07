#!/bin/bash
set -euo pipefail

NODE_VERSION="12.13.0"

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

  NODE_SHA256="55d69507d240b1ce582ce1c66e675b2271d8c3585f76c453595b3f3f20f4ed09"
  URL=https://buildpacks.cloudfoundry.org/dependencies/node/node-12.13.0-linux-x64-cflinuxfs3-55d69507.tgz
  

  echo "-----> Download Nodejs ${NODE_VERSION}"
  curl -s -L --retry 15 --retry-delay 2 $URL -o ${DOWNLOAD_FILE}

  DOWNLOAD_SHA256=$(shasum -a 256 ${DOWNLOAD_FILE} | cut -d ' ' -f 1)  

  if [[ $DOWNLOAD_SHA256 != $NODE_SHA256 ]]; then
    echo "       **ERROR** SHA256 mismatch: got $DOWNLODOWNLOAD_SHA256AD_MD5 expected $NODE_SHA256"
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
