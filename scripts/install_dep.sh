#!/bin/bash
set -euo pipefail

#############################################################################
# Deprecated - not used in this version - will be removed in a future version
#############################################################################

# Download dep

DEP_VERSION="0.5.1"
DEP_PLATFORM="linux-amd64"

DOWNLOAD_FOLDER=${CACHE_DIR}/Downloads
mkdir -p ${DOWNLOAD_FOLDER}
DOWNLOAD_FILE=${DOWNLOAD_FOLDER}/dep${DEP_VERSION}

export DepInstallDir="/tmp/dep/$DEP_VERSION"
mkdir -p $DepInstallDir

# Download the file if we do not have it cached
if [ ! -f ${DOWNLOAD_FILE} ]; then
  # Delete any cached dep downloads, since those are now out of date
  rm -rf ${DOWNLOAD_FOLDER}/dep*

  URL=https://github.com/golang/dep/releases/download/v${DEP_VERSION}/dep-${DEP_PLATFORM}
  echo "-----> Download dep ${DEP_VERSION}"
  curl -s -L --retry 15 --retry-delay 2 $URL -o ${DOWNLOAD_FILE}
else
  echo "-----> dep install package available in cache"
fi

if [ ! -f $DepInstallDir/dep ]; then
  cp ${DOWNLOAD_FILE} $DepInstallDir/dep
  chmod +x $DepInstallDir/dep
fi

if [ ! -f $DepInstallDir/dep ]; then
  echo "       **ERROR** Could not download dep"
  exit 1
fi
