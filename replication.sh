#!/bin/bash

user=''
pass=''
db1='rqprojects'
db2='rqmessages'


# setup for replication
#
cat << EOF | curl -X PUT https://$user:$pass@frcv.net/couch/_replicator/rep_from_rqprojects --data-binary @-
{
    "_id": "rep_from_couch",
    "source":  "https://$user:$pass@frcv.net/couch/$db1",
    "target":  "https://$user:$pass@frcv.net/couch/$db2",
    "create_target":  true,
    "continuous":  true
}
EOF

cat << EOF | curl -X PUT https://$user:$pass@frcv.net/couch/_replicator/rep_from_rqmessages --data-binary @-
{
    "_id": "rep_from_couch",
    "source":  "https://$user:$pass@frcv.net/couch/$db2",
    "target":  "https://$user:$pass@frcv.net/couch/$db1",
    "create_target":  true,
    "continuous":  true
}
EOF
