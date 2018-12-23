#
# run with: jq -fr count.jq data-questions.json
#

include "./lib";

. | map(.pCnt) | add | { "prediction_count": . }
