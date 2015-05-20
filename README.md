
#Couchdb for RedQueen
This is the repo that will help you setup couchdb for use with redqueen.

## Running
1. Install [docker](https://docs.docker.com/installation/).
2. Run setup.sh
```setup.sh local.ini data_dir```

## Details
* We are using [klaemo/docker-couchdb](https://github.com/klaemo/docker-couchdb) 
* local.ini is pulled directly from klaemo's docker container

## Note
* Create a new replication user, you will need to use this users credentials for replications.
* 
