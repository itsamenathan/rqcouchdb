#!/bin/bash

user=''
pass=''
db='rqconfig'



# create view
################
#cat << EOF | curl -H 'Content-Type: application/json' \
#                  -X POST https://$user:$pass@frcv.net/couch/$db \
#                  --data-binary @-
#{
#  "_id":"_design/doc",
#  "language": "javascript",
#  "views":
#  {
#    "by_id": {
#      "map": "function(doc) { emit(doc.key, doc) }"
#    },
#    "by_name": {
#      "map": "function(doc) { emit(doc.name, doc) }"
#    }
#  }
#}
#EOF

## create doc
#############
#cat << EOF | curl -i \
#                  -H "Content-Type:application/json" \
#                  -X POST \
#                  https://$user:$pass@frcv.net/couch/$db \
#                  --data-binary @-
#{
#    "type": "project",
#    "created": "4/28/2015 4:16:39 AM",
#    "description": "SMTP realy for sending emails from RedQueen.",
#    "key": "apple",
#    "name": "rqmailer",
#    "owner" : {
#      "nick": "itsamenathan",
#      "email": "nathan@frcv.net",
#      "name": "Nathan Warner"
#    },
#    "permissions": []
#}
#EOF



# get something from a view.....don't forget to urlencode your key!
curl "https://$user:$pass@frcv.net/couch/$db/_design/doc/_view/by_key?key=%22banana%22"

