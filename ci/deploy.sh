#!/usr/bin/env bash

export LC_ALL=C.UTF-8

OUTDIR=$TRAVIS_BUILD_DIR/out/$TRAVIS_PULL_REQUEST/$TRAVIS_JOB_NUMBER-$HOST
mkdir -p $OUTDIR/bin

ARCHIVE_CMD="zip"

if [[ $HOST = "x86_64-w64-mingw32" ]]; then
    ARCHIVE_NAME+="win64.zip"
elif [[ $HOST = "x86_64-unknown-linux-gnu" ]]; then
    ARCHIVE_NAME+="linux64 + $DOCKER_NAME_TAG + .tar.gz"
    ARCHIVE_CMD="tar -czf"
elif [[ $HOST = "x86_64-apple-darwin11" ]]; then
    ARCHIVE_NAME+="mac64.zip"
fi

cp build/dash-$HOST/src/qt/dash-qt $OUTDIR/bin/ || cp build/dash-$HOST/src/qt/dash-qt.exe $OUTDIR/bin/
cp build/dash-$HOST/src/dashd $OUTDIR/bin/ || cp build/dash-$HOST/src/dashd.exe $OUTDIR/bin/
cp build/dash-$HOST/src/dash-cli $OUTDIR/bin/ || cp build/dash-$HOST/src/dash-cli.exe $OUTDIR/bin/
cp build/dash-$HOST/src/dash-tx $OUTDIR/bin/ || cp build/dash-$HOST/src/dash-tx.exe $OUTDIR/bin/
strip "$OUTDIR/bin"/*
ls -lah $OUTDIR/bin

cd $OUTDIR/bin || return
ARCHIVE_CMD="$ARCHIVE_CMD $ARCHIVE_NAME *"
eval $ARCHIVE_CMD

mkdir -p $OUTDIR/zip
mv $ARCHIVE_NAME $OUTDIR/zip

sleep $(( ( RANDOM % 6 ) + 1 ))s
