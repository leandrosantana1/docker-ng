#!/bin/sh

if [ -f package.json ]; then
    npm install
elif [ "$GENERATE" == "true" ]; then
    __old=$PWD
    cd ..
    ng new $APPNAME --directory ${__old} --routing --skip-git
    cd ${__old}
    unset __old
fi

exec $@
