#!/bin/bash
set -e
set -x

cd contrib

rm -rfv build
mkdir build
cd build
if ../bootstrap --enable-nettle --enable-gnutls; then
make .nettle .gnutls .ffmpeg

make
# That's all !
else
	error_exit "$LINENO: An error has occurred.. Aborting."
fi

cd ../../
if ./autogen.sh; then
./configure --prefix=/opt/usr
make
make install

else
	error_exit "$LINENO: An error has occurred.. Aborting."
fi

function error_exit
{
	echo "$1" 1>&2
	exit 1
}
