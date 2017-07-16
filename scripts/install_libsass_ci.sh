#!/bin/sh
set -ex

if [ "$LIBSASS_VERSION" = "" ]; then
  LIBSASS_VERSION="3.4.0"
fi
export SASS_LIBSASS_PATH="$PWD/libsass-${LIBSASS_VERSION}"
wget "https://github.com/sass/libsass/archive/${LIBSASS_VERSION}.tar.gz" -O "libsass.tar.gz"
tar -xvf "libsass.tar.gz"
cd "${SASS_LIBSASS_PATH}"
BUILD="shared" make -j5
sudo PREFIX="/usr/local" make install
sudo cp "lib/libsass.so" /usr/local/lib
sudo ldconfig
