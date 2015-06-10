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

cat << EOF | curl -i \
                  -H "Content-Type:application/json" \
                  -X POST \
                  https://$user:$pass@frcv.net/couch/$db/_design/project \
                  --data-binary @-
{
  "filters" : {
    "by_name" : "function(doc, req) { if(doc.destination == req.query.name) { return true; } else { return false; }}"
    }
  }
}
EOF


