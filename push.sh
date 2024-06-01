#!/bin/sh
hugo --minify
cp -r ../capy-related/documentation/build/* ./public/docs
rsync -ave "ssh -p 8058" public/* zenith@bwsecondary.ddns.net:/etc/nginx/html/html/html_capy

