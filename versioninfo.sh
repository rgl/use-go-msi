#!/usr/bin/bash
set -euxo pipefail

APP_VERSION="${APP_VERSION:-0.0.0-dev}"

if [[ "$APP_VERSION" == *"-"* ]]; then
    APP_FILE_FLAGS='01' # VS_FF_PRERELEASE
else
    APP_FILE_FLAGS='00'
fi

jq \
    --arg ff "$APP_FILE_FLAGS" \
    '.FixedFileInfo.FileFlags = $ff' \
    versioninfo.json \
| goversioninfo \
    -o main.syso \
    -icon=main.ico \
    -manifest=main.manifest \
    -file-version="$APP_VERSION" \
    -product-version="$APP_VERSION" \
    -
