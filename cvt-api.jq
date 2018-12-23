include "./libcvt";

map(.results) |
flatten |
map(
  .possibilities as $poss |
  {
    id:       .id,
    title:    .title,
    res:      (.resolution | mapResolution($poss)),
    resolved: (.resolution != null),
    res_at:   .resolve_time,
    cre_at:   .publish_time,
    cP:       (.prediction_timeseries[-1].community_prediction | scalePossible($poss)),
    mP:       (.metaculus_prediction[-1].x                     | scalePossible($poss)),
    type:     . | mapType($poss),
    pCnt:     .prediction_timeseries[-1].num_predictions,
  })
