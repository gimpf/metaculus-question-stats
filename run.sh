#!/bin/sh
./update-data.sh && jq -fr stats.jq data-questions.json
