#!/bin/sh

if [ -f package.json ]; then
    npm install
else 
    ng new $APPNAME --directory . --routing --skip-git
fi

exec $@
