#!/bin/sh
hugo --minify
cp -r ../capy-related/documentation/build/* ./public/docs
rsync -ave "ssh" public/* root@capy-ui.org:/usr/share/www/capy-ui.org

