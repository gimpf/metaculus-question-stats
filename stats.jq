include "./lib";

. as $all |
[ { t: "2017Q1",    s: "2017-01-01", e: "2017-04-01" },
  { t: "2017Q2",    s: "2017-04-01", e: "2017-07-01" },
  { t: "2017Q3",    s: "2017-07-01", e: "2017-10-01" },
  { t: "2017Q4",    s: "2017-10-01", e: "2018-01-01" },
  { t: "2017Q4ttm", s: "2017-01-01", e: "2018-01-01" },
  { t: "2018Q1",    s: "2018-01-01", e: "2018-04-01" },
  { t: "2018Q1ttm", s: "2017-04-01", e: "2018-04-01" },
  { t: "2018Q2",    s: "2018-04-01", e: "2018-07-01" },
  { t: "2018Q2ttm", s: "2017-07-01", e: "2018-07-01" },
  { t: "2018Q3",    s: "2018-07-01", e: "2018-10-01" },
  { t: "2018Q3ttm", s: "2017-10-01", e: "2018-10-01" },
  { t: "2018Q4",    s: "2018-10-01", e: "2019-01-01" },
  { t: "2018Q4ttm", s: "2018-01-01", e: "2019-01-01" },
  { t: "2019Q1",    s: "2019-01-01", e: "2019-04-01" },
  { t: "2019Q1ttm", s: "2018-04-01", e: "2019-04-01" } ] |
reduce .[] as $item (
    [];
    . + [
        ({ "period": $item.t } +
        ($all | allstats($item.s; $item.e)))
    ]) |
["period", "resolving", "resolved", "unambiguous", "yes", "ratio", "new", "short7d", "short14d", "short28d"] as $keys | $keys, map([.[ $keys[] ]])[] |
@csv
