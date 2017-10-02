#!/bin/bash
set -euo pipefail

NODE_VERSION="6.11.3"

export NodeInstallDir="/tmp/node$NODE_VERSION"
mkdir -p $NodeInstallDir

if [ ! -f $NodeInstallDir/go/bin/go ]; then
  NODE_MD5="ba51d463da63776d20582e07cb9b4d9d"

  URL=https://buildpacks.cloudfoundry.org/dependencies/node/node-${NODE_VERSION}-linux-x64-ba51d463.tgz

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

ls -al $NodeInstallDir

export NodeDir="$NodeInstallDir/node-v${NODE_VERSION}-linux-x64"

if [ ! -f $NodeDir/bin/node ]; then
  echo "       **ERROR** Could not download nodejs"
  exit 1
fi
