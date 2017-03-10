#!/bin/bash
set -e
set -x

cd contrib

rm -rfv build
mkdir build
cd build
if ../bootstrap --disable-pjproject; then

make
# That's all !
else
	error_exit "$LINENO: An error has occurred.. Aborting."
fi

function error_exit
{
	echo "$1" 1>&2
	exit 1
}
