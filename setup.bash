#!/bin/bash

# exit when command fails
set -e
# exit status of last command that failed
set -o pipefail
# exit when use of undeclared varable
set -o nounset

if [ -z "$2" ]; then
  echo "usage: setup.sh /path/to/local.ini /path/to/store/couchdb/data"
  exit
fi

ini=$(readlink -f "$1")
dir=$(readlink -f "$2")
docker=$(which docker)

if [ ! -d "$dir" ]; then
  echo "INFO: Creating couchdb data dir"
  mkdir "$dir"
  mkdir "$dir/data"
  cp "$ini" "$dir"
  $docker run -d -p 5984:5984 --name couchdb -v "$dir/data":/usr/local/var/lib/couchdb -v "$dir/local.ini":/usr/local/etc/couchdb/local.ini klaemo/couchdb
  sleep 5
  pass=$(date | md5sum | cut -f 1 -d " ")
  curl -X PUT http://localhost:5984/_config/admins/redqueen -d "\"$pass\""
  printf "uers: redqueen\npass: $pass\n"
else
  if [ $(ls -A "$dir" | wc -l) -gt 0 ]; then
    while true; do
        read -p "Waring: Data dir contains files, want to continue using this directory? [yn]" yn
        case $yn in
            [Yy]* )
               $docker run -d -p 5984:5984 --name couchdb -v "$dir/data":/usr/local/var/lib/couchdb -v "$dir/local.ini":/usr/local/etc/couchdb/local.ini klaemo/couchdb
               break
            ;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
  fi
fi

