include "./lib";

. as $all |
[ { t: "2018Q4",    s: "2018-10-01", e: "2019-01-01" } ] |
reduce .[] as $item (
    [];
    . + ($all |
         rrange($item.s; $item.e) |
         map(select(.resolved == false)))
    ) |
reduce .[] as $question (
    { total: 0,
      yes:   0 };
    { total: (.total + 1),
      yes:   (.yes + (if $question.cP <= 0.5 then 0 else 1 end))
    })