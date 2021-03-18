#!/bin/bash
##################################
# yosys apio package builder  #
##################################

# Set english language for propper pattern matching
export LC_ALL=C

# Generate toolchain-yosys-arch-ver.tar.gz
# Releases are downloadedt from: https://github.com/open-tool-forge/fpga-toolchain

# -- yosys apio package version
VERSION=2021.3.16

# -- fpga-toolchain version to download
SRC_VER="nightly-20210316"

# -- Target architectures
ARCH=$1
TARGET_ARCHS="linux_x86_64 windows_amd64 darwin"

# -- Tools name
NAME=toolchain-yosys

# -- Source fpga-toolchain package name (without arch, version and extension)
SRC_NAME="fpga-toolchain-"$ARCH-$SRC_VER

# -- Source URL
SRC_URL="https://github.com/YosysHQ/fpga-toolchain/releases/download/$SRC_VER"

# -- Store current dir
WORK_DIR=$PWD

# -- Folder for storing the generated apio packages
PACKAGES_DIR=$WORK_DIR/_packages

# --  Folder for storing the upstream release packages download from github
UPSTREAM_DIR=$WORK_DIR/_upstream

# -- Create the packages directory
mkdir -p "$PACKAGES_DIR"

# -- Create the _upsream directory
mkdir -p "$UPSTREAM_DIR"

# -- Print function
function print {
  echo ""
  echo "$1"
  echo ""
}

# -- Check ARCH
if [[ $# -gt 1 ]]; then
  echo ""
  echo "Error: too many arguments"
  exit 1
fi

if [[ $# -gt 1 ]]; then
  echo ""
  echo "Usage: bash build.sh TARGET"
  echo ""
  echo "Targets: $TARGET_ARCHS"
  exit 1
fi

if [[ $ARCH =~ [[:space:]] || ! $TARGET_ARCHS =~ (^|[[:space:]])$ARCH([[:space:]]|$) ]]; then
  echo ""
  echo ">>> WRONG ARCHITECTURE \"$ARCH\""
  echo "Targets: $TARGET_ARCHS"
  echo ""
  exit 1
fi

# -- Directory for installating the target files
PACKAGE_DIR=$PACKAGES_DIR/build_$ARCH

# -- Directory for downloading the upstream release for a given ARCH
UPSTREAM_DIR=$UPSTREAM_DIR/$ARCH

# -- Create the package folders
mkdir -p "$PACKAGE_DIR"/"$NAME"/bin

# -- Create the upstream folder
mkdir -p "$UPSTREAM_DIR"

echo ""
echo ">>> ARCHITECTURE \"$ARCH\""



# -- Source architecture: should be the same than target
# -- architecture, but the names in the fujprog and apio
# -- are different: Convert from fujprog to apio
if [ "$ARCH" == "windows_amd64" ]; then
  SRC_NAME=$SRC_NAME".zip"
  EXE=".exe"
  echo "Source filename: "$SRC_NAME
fi

if [ "$ARCH" == "linux_x86_64" ]; then
  SRC_NAME=$SRC_NAME".tar.gz"
  EXE=""
  echo "Source filename: "$SRC_NAME
fi

if [ "$ARCH" == "darwin" ]; then
  SRC_NAME=$SRC_NAME".tar.gz"
  EXE=""
  echo "Source filename: "$SRC_NAME
fi

echo "Download from: "$SRC_URL

# --- Enter to the upstream folder
cd "$UPSTREAM_DIR" || exit

# --- Download the executable file, if it does not exist yet
if [[ -f $SRC_NAME ]]; then
  echo "FILE Already exist"
else
  wget $SRC_URL/$SRC_NAME
fi

# --- Uncompress the file
if [ "$ARCH" == "windows_amd64" ]; then
  unzip $SRC_NAME
else
  tar -vzxf $SRC_NAME
fi

# -- Copy the yosys packages to the package bin folder
cp fpga-toolchain/bin/yosys$EXE $PACKAGE_DIR/$NAME/bin
cp fpga-toolchain/bin/yosys-abc$EXE $PACKAGE_DIR/$NAME/bin
cp fpga-toolchain/bin/yosys-config$EXE $PACKAGE_DIR/$NAME/bin
cp fpga-toolchain/bin/yosys-filterlib$EXE $PACKAGE_DIR/$NAME/bin
cp fpga-toolchain/bin/yosys-smtbmc$EXE $PACKAGE_DIR/$NAME/bin
cp -r fpga-toolchain/share/yosys $PACKAGE_DIR/$NAME/share

# -- Create package script

# -- Copy templates/package-template.json
cp -r "$WORK_DIR"/build-data/templates/package-template.json "$PACKAGE_DIR"/"$NAME"/package.json

# -- Fill in the templates with the current version and architecture
sed -i "s/%VERSION%/\"$VERSION\"/;" "$PACKAGE_DIR"/"$NAME"/package.json
sed -i "s/%SYSTEM%/\"$ARCH\"/;" "$PACKAGE_DIR"/"$NAME"/package.json

## --Create a tar.gz package

cd "$PACKAGE_DIR/$NAME" || exit

tar -czvf "../$NAME-$ARCH-$VERSION.tar.gz" ./*

# -- Create the releases folder
mkdir -p "$WORK_DIR/releases"

## -- Copy the package to the releases folder
cd "$PACKAGE_DIR" || exit
cp "$NAME"-"$ARCH"-"$VERSION".tar.gz "$WORK_DIR"/releases

echo ""
