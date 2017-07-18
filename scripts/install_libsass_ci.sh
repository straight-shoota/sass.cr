#!/bin/sh
set -ex

LOCAL_LD_PATH="${LOCAL_LD_PATH:-$(pwd)/dynlib}"
if [ "$LIBSASS_VERSION" = "" ]; then
  LIBSASS_VERSION="3.4.5"
fi
export SASS_LIBSASS_PATH="$PWD/libsass-${LIBSASS_VERSION}"
[ -f "libsass-${LIBSASS_VERSION}.tar.gz" ] || wget "https://github.com/sass/libsass/archive/${LIBSASS_VERSION}.tar.gz" -O "libsass-${LIBSASS_VERSION}.tar.gz"
[ -d "libsass-${LIBSASS_VERSION}" ] || tar -xvf "libsass-${LIBSASS_VERSION}.tar.gz"

BUILD="shared" make -C "libsass-${LIBSASS_VERSION}" -j5

PREFIX="${LOCAL_LD_PATH}" make -C "libsass-${LIBSASS_VERSION}" install
cp "libsass-${LIBSASS_VERSION}/lib/libsass.so" "${LOCAL_LD_PATH}/lib"
