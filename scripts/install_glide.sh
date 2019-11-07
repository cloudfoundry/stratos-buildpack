#!/bin/bash
set -euo pipefail

#############################################################################
# Deprecated - not used in this version - will be removed in a future version
#############################################################################

# Download glide

GLIDE_VERSION="0.13.0"
GLIDE_PLATFORM="linux-amd64"

export GlideInstallDir="/tmp/glide/$GLIDE_VERSION"
mkdir -p $GlideInstallDir

if [ ! -f $GlideInstallDir/$GLIDE_PLATFORM/glide ]; then
  URL=https://github.com/Masterminds/glide/releases/download/v${GLIDE_VERSION}/glide-v${GLIDE_VERSION}-linux-amd64.tar.gz

  echo "-----> Download glide ${GLIDE_VERSION}"
  curl -s -L --retry 15 --retry-delay 2 $URL -o /tmp/glide.tar.gz

  tar xzf /tmp/glide.tar.gz -C $GlideInstallDir
  rm /tmp/glide.tar.gz
fi

export GlideDir=$GlideInstallDir/linux-amd64
if [ ! -f $GlideDir/glide ]; then
  echo "       **ERROR** Could not download glide"
  exit 1
fi
