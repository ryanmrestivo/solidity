#!/bin/sh

set -eux

if ls /usr/local/lib | grep -q libff; then exit 0; fi

git clone https://github.com/scipr-lab/libff --recursive
cd libff
git submodule init && git submodule update
ARGS="-DWITH_PROCPS=OFF"
CXXFLAGS=""
if [ "$(uname)" = "Darwin" ]; then
  export LDFLAGS=-L/usr/local/opt/openssl/lib
  export CPPFLAGS=-I/usr/local/opt/openssl/include
  export CXXFLAGS=-I/usr/local/opt/openssl/include
  ARGS="$ARGS -DOPENSSL_INCLUDE_DIR=/usr/local/opt/openssl/include/openssl -DCURVE=ALT_BN128"
  sed -i '' 's/STATIC/SHARED/' libff/CMakeLists.txt # Fix GHC segfaults from hell (idk why)
  sed -i '' 's/STATIC/SHARED/' depends/CMakeLists.txt
fi
mkdir build
cd build
CXXFLAGS="-fPIC $CXXFLAGS" cmake $ARGS ..
make && sudo make install
cd ../.. && rm -rf libff
