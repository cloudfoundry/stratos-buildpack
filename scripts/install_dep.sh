#!/bin/bash
set -euo pipefail

# Download dep

DEP_VERSION="0.5.0"
DEP_PLATFORM="linux-amd64"

export DepInstallDir="/tmp/dep/$DEP_VERSION"
mkdir -p $DepInstallDir

if [ ! -f $DepInstallDir/dep ]; then
  URL=https://github.com/golang/dep/releases/download/v${DEP_VERSION}/dep-${DEP_PLATFORM}
  echo "-----> Download dep ${DEP_VERSION}"
  curl -s -L --retry 15 --retry-delay 2 $URL -o $DepInstallDir/dep
  chmod +x $DepInstallDir/dep
fi

if [ ! -f $DepInstallDir/dep ]; then
  echo "       **ERROR** Could not download dep"
  exit 1
fi
