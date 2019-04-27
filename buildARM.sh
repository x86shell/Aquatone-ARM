#!/bin/bash

BUILD_FOLDER=build
VERSION=$(cat core/banner.go | grep Version | cut -d '"' -f 2)

bin_dep() {
  BIN=$1
  which $BIN > /dev/null || { echo "[-] Dependency $BIN not found !"; exit 1; }
}

create_archive() {
  bin_dep 'zip'

  OUTPUT=$1

  echo "[*] Creating archive $OUTPUT ..."
  zip -j "$OUTPUT" aquatone ../README.md ../LICENSE.txt > /dev/null
  rm -rf aquatone aquatone.exe
}

build_arm() {
  echo "[*] Building linux/arm64 ..."
  GOOS=linux GOARCH=arm go build -o aquatone ..
}

rm -rf $BUILD_FOLDER
mkdir $BUILD_FOLDER
cd $BUILD_FOLDER

build_arm && create_archive aquatone_arm64_$VERSION.zip
shasum -a 256 * > checksums.txt

echo
echo
du -sh *

cd --
