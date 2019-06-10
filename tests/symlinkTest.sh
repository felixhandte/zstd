#!/bin/sh

set -e

println() {
    printf '%b\n' "${*}"
}

die() {
    println "$@" 1>&2
    exit 1
}

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PRGDIR="$SCRIPT_DIR/../programs"
TESTDIR="$SCRIPT_DIR/../tests"

if [ -z "$ZSTD" ]; then
  ZSTD="$PRGDIR/zstd"
fi

$ZSTD --version || die "Zstd must be provided!"

clean() {
  rm -f $TESTDIR/symlinkTest.tmp \
        $TESTDIR/symlinkTest.tmp.zst \
        $TESTDIR/symlinkTest.link.tmp \
        $TESTDIR/symlinkTest.link.tmp.zst
}


clean

echo "foo" > $TESTDIR/symlinkTest.tmp
ln -s $TESTDIR/symlinkTest.tmp $TESTDIR/symlinkTest.link.tmp
$ZSTD $TESTDIR/symlinkTest.tmp $TESTDIR/symlinkTest.link.tmp || true
# regular file should have been compressed!
test -f $TESTDIR/symlinkTest.tmp.zst
# symbolic link should not have been compressed!
test ! -f $TESTDIR/symlinkTest.link.tmp.zst

clean
