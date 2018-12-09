#!/bin/sh

if [ -f package.json ]; then
    npm install
elif [ "$GENERATE" == "true" ]; then
    __old=$PWD
    _OPTS=""

    [ ${ANGULAR_ROUTING} == "true" ] && _OPTS="--routing"
    _OPTS=${_OPTS}" --style=$ANGULAR_STYLESHEET_FORMAT"

    cd ..
        ng new $APPNAME --directory ${__old} --skip-git $_OPTS
    cd ${__old}

    unset _OPTS __old
fi

# hack to disable host check
if [ "$1" == "ng" ] && [ "$2" == "serve" ]; then
    if [ "${ANGULAR_HOST_CHECK}" == "false" ]; then
        exec $@ --disable-host-check
    fi
fi

exec $@
