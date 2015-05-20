#!/bin/bash

db='test'
url='https://frcv.net/couch'

since='now'
while true; do
  # Connect with longpoll
  change=$(curl -s -X GET "$url/$db/_changes?feed=longpoll&since=$since")

  # check if we get a doc id
  id=$(jq -r '.results[0] .id' <<< "$change")

  # couch sends empty hartbeat every min, so if no doc id, loop back around
  [ "$id" == "null" ] && continue

  # we remember seq_id so we don't miss anything 
  since=$(jq -r '.results[0] .seq' <<< "$change")

  # We acutally get the doc
  doc=$(curl -s -X GET "$url/$db/$id")
  echo "$doc"

  # This is were we parse the doc
  #msg=$(jq -r '.stdin' <<< "$doc")
  #echo "$msg"
done
