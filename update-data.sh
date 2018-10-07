#!/usr/bin/env bash

# echo Get track record...
# curl --silent --show-error --fail https://www.metaculus.com/questions/track-record/export/ > tmp-data-track.json \
#   && mv -f tmp-data-track.json data-track-raw.json
#

echo Get all questions...
echo > tmp-data-questions.json
count=0
for p in {1..100}; do
  echo .. page $p ...
  curl --silent --show-error --fail 'https://www.metaculus.com/api2/questions/?page='$p >> tmp-data-questions.json
  if [[ $? -ne 0 ]]; then break; fi
  count=$((count + 1))
done
echo Got $count pages
if [[ $count > 30 ]]; then
  mv -f tmp-data-questions.json data-questions-raw.json
fi

echo Convert raw data to common format...
# jq -f cvt-track.jq data-track-raw.json > data-track.json
jq -s -f cvt-api.jq data-questions-raw.json > data-questions.json
