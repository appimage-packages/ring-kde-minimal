#!/bin/bash
set -e
set -x
export LD_LIBRARY_PATH=/opt/usr/lib:/opt/usr/lib/x86_64-linux-gnu:/usr/lib:/usr/lib64
export PKG_CONFIG="pkg-config --static"
add-apt-repository -y ppa:ubuntu-toolchain-r/test && apt-get update && apt-get -y install gcc-4.9 g++-4.9
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.9
cd contrib

rm -rfv build
mkdir build
cd build
if ../bootstrap --prefix=/opt/usr --enable-nettle --enable-gnutls --enable-x264 --enable-ffmpeg; then
make .nettle .gnutls .x264 .ffmpeg

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
cd ../../
LIBRINGLIENT=`pwd`/ring-lrc
RING=/app/src/ring
git clone https://gerrit-ring.savoirfairelinux.com/ring-lrc
cd $LIBRINGLIENT
mkdir build
cd build
if cmake .. -DCMAKE_INSTALL_PREFIX=/opt/usr; then
make -j8
make install
else
	error_exit "$LINENO: An error has occurred.. Aborting."
fi

# git clone https://gerrit-ring.savoirfairelinux.com/ring-client-gnome
# cd ring-client-gnome
# mkdir build
# cd build
# cmake .. -DCMAKE_INSTALL_PREFIX=/opt/usr
# make
# sudo make install
git clone git://anongit.kde.org/ring-kde
cd ring-kde
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/usr -DCMAKE_BUILD_TYPE=Release
make
make install
function error_exit
{
	echo "$1" 1>&2
	exit 1
}
