#!/bin/sh

if [ -f package.json ]; then
    npm install
elif [ "$GENERATE" == "true" ]; then
    ng new $APPNAME --directory . --routing --skip-git
fi

exec $@
