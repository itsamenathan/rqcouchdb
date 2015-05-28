#!/bin/bash

if [ -z $1 ]; then
  echo "Pass in dbname"
  exit
fi
user=''
pass=''
db=$1


# Create db
curl -X PUT https://$user:$pass@frcv.net/couch//$db


# set security
cat << EOF | curl -X PUT https://$user:$pass@frcv.net/couch/$db/_security --data-binary @-
{
    "admins": {
        "names": [
        ],
        "roles": [
            "admins"
        ]
    },
    "members": {
        "names": [
        ],
        "roles": [
        ]
    }
}
EOF

cat << EOF | curl -X PUT https://$user:$pass@frcv.net/couch/$db/_design/auth --data-binary @-
{
  "validate_doc_update":"function(newDoc, oldDoc, userCtx) {   if (userCtx.roles.indexOf('_admin') !== -1) {     return;   } else {     throw({forbidden: 'This DB is read-only'});   }   } "
}
EOF


## setup for replication
##
#cat << EOF | curl -X PUT https://$user:$pass@frcv.net/couch/_replicator/rep_from_couch2 --data-binary @-
#{
#    "_id": "rep_from_couch",
#    "source":  "https://frcv.net/couch2/$db",
#    "target":  "https://$user:$pass@frcv.net/couch/$db",
#    "create_target":  true,
#    "continuous":  true
#}
#EOF
#
#cat << EOF | curl -X PUT https://$user:$pass@frcv.net/couch2/_replicator/rep_from_couch --data-binary @-
#{
#    "_id": "rep_from_couch",
#    "source":  "https://frcv.net/couch/$db",
#    "target":  "https://$user:$pass@frcv.net/couch2/$db",
#    "create_target":  true,
#    "continuous":  true
#}
#EOF
