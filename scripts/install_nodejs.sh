#!/bin/bash
set -euo pipefail

NODE_VERSION="10.0.0"

export NodeInstallDir="/tmp/node$NODE_VERSION"
export NodeDir="$NodeInstallDir/node-v${NODE_VERSION}-linux-x64"

mkdir -p $NodeInstallDir

if [ ! -f  $NodeDir/bin/node ]; then
  NODE_MD5="3f6e9d3f486d9d0b792b9ab6d5c613d6"

  URL=https://buildpacks.cloudfoundry.org/dependencies/node/node-10.0.0-linux-x64-3e163e3d.tgz

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
