#!/bin/bash

set -e;

source $1;

USERNAME=$username
PASSWORD=$password

wget --save-cookies cookies --keep-session-cookies --post-data="username=$USERNAME&password=$PASSWORD" https://account.thethingsnetwork.org/api/v2/users/login -O - &> /dev/null;

TOKEN=`wget --load-cookies cookies --max-redirect 0 'https://account.thethingsnetwork.org/users/authorize?client_id=ttnctl&redirect_uri=/oauth/callback/ttnctl&response_type=code'  2>&1  | perl -lne 'print $1 if /^.*code=([^\s]*)/';`

printf '{"changed": false, "token": "%s"}\n' "$TOKEN"
