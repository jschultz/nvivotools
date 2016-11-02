#!/bin/sh

# Wrapper for DenormaliseNVPX.py
# Sets environment to run SQL Anywhere client on Linux or OSX then calls
# DenormaliseNVPX.py in the same directory as this script.

if [ "$(uname)" = "Linux" ]; then
    for SQLANYWHERE in `ls -d /opt/sqlanywhere?? 2>/dev/null`; do
        if test -f $SQLANYWHERE/bin64/sa_config.sh; then
            found=1
            . $SQLANYWHERE/bin64/sa_config.sh
        elif test -f $SQLANYWHERE/bin32/sa_config.sh; then
            found=1
            . $SQLANYWHERE/bin32/sa_config.sh
        fi
    done
elif [ "$(uname)" = "Darwin" ]; then
    SQLANYWHERE=/Applications/NVivo.app/Contents/SQLAnywhere
    if test -d "$SQLANYWHERE"; then
        if test -d $SQLANYWHERE/lib64; then
            found=1
            export DYLD_LIBRARY_PATH=$SQLANYWHERE/lib64
        elif test -d $SQLANYWHERE/lib32; then
            found=1
            export DYLD_LIBRARY_PATH=$SQLANYWHERE/lib32
        fi
    else
        for SQLANYWHERE in `ls -d /Applications/SQLAnywhere??/System 2>/dev/null`; do
            if test -f $SQLANYWHERE/bin64/sa_config.sh; then
                found=1
                . $SQLANYWHERE/bin64/sa_config.sh
                break
            elif test -f $SQLANYWHERE/bin32/sa_config.sh; then
                found=1
                . $SQLANYWHERE/bin32/sa_config.sh
                break
            fi
        done
    fi
fi
if [ "$found" != "1" ]; then
    echo "No SQLAnywhere instance found"
    exit
fi

# Call python explicitly here, otherwise env will drop our environment.
python `dirname $0`/DenormaliseNVPX.py "$@"