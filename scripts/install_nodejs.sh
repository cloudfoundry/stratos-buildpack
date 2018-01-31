#!/bin/bash
set -euo pipefail

NODE_VERSION="8.9.4"

export NodeInstallDir="/tmp/node$NODE_VERSION"
export NodeDir="$NodeInstallDir/node-v${NODE_VERSION}-linux-x64"

mkdir -p $NodeInstallDir

if [ ! -f  $NodeDir/bin/node ]; then
  NODE_MD5="5bda713bd4aa39394536fc48c744854b"

  URL=https://buildpacks.cloudfoundry.org/dependencies/node/node-8.9.4-linux-x64-40e8e080.tgz

  echo "-----> Download Nodejs ${NODE_VERSION}"
  curl -s -L --retry 15 --retry-delay 2 $URL -o /tmp/nodejs.tar.gz

  DOWNLOAD_MD5=$(md5sum /tmp/nodejs.tar.gz | cut -d ' ' -f 1)

  if [[ $DOWNLOAD_MD5 != $NODE_MD5 ]]; then
    echo "       **ERROR** MD5 mismatch: got $DOWNLOAD_MD5 expected $NODE_MD5"
    exit 1
  fi

  tar xzf /tmp/nodejs.tar.gz -C $NodeInstallDir
  rm /tmp/nodejs.tar.gz
fi

if [ ! -f $NodeDir/bin/node ]; then
  echo "       **ERROR** Could not download nodejs"
  exit 1
fi

export NODE_HOME=$NodeDir
