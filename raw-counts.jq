include "./lib";
include "./libcvt";

def upTo(endDate):
  map(select(.t < endDate + "00:00:00Z"));

map(.results) |
flatten |
map(
  .prediction_timeseries |
  reduce map({t: .t | epochtodate, n: .num_predictions })[] as $item (
    {last: 0, stream: []};
    {"last": ($item.n), "stream": (.stream + [{t: $item.t, n: ($item.n - .last)}])}
  )) |
map(.stream) |
flatten |
sort_by(.t) as $all |
[ { e: "2016-01-01" },
  { e: "2016-02-01" },
  { e: "2016-03-01" },
  { e: "2016-04-01" },
  { e: "2016-05-01" },
  { e: "2016-06-01" },
  { e: "2016-07-01" },
  { e: "2016-08-01" },
  { e: "2016-09-01" },
  { e: "2016-10-01" },
  { e: "2016-11-01" },
  { e: "2016-12-01" },
  { e: "2017-01-01" },
  { e: "2017-02-01" },
  { e: "2017-03-01" },
  { e: "2017-04-01" },
  { e: "2017-05-01" },
  { e: "2017-06-01" },
  { e: "2017-07-01" },
  { e: "2017-08-01" },
  { e: "2017-09-01" },
  { e: "2017-10-01" },
  { e: "2017-11-01" },
  { e: "2017-12-01" },
  { e: "2018-01-01" },
  { e: "2018-02-01" },
  { e: "2018-03-01" },
  { e: "2018-04-01" },
  { e: "2018-05-01" },
  { e: "2018-06-01" },
  { e: "2018-07-01" },
  { e: "2018-08-01" },
  { e: "2018-09-01" },
  { e: "2018-10-01" },
  { e: "2018-11-01" },
  { e: "2018-12-01" },
  { e: "2019-01-01" }
] |
reduce .[] as $item (
    [];
    . + [
        ({ "before": $item.e } +
        ($all | upTo($item.e) | map(.n) | add | { "count": . }))
    ])
