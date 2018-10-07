map(.results) |
flatten |
map(select(.possibilities.type == "binary")) |
map({
  id: .id,
  title: .title,
  res: (if .resolution == 1 then true elif .resolution == 0 then false else null end),
  resolved: (.resolution != null),
  res_at: .resolve_time,
  cre_at: .publish_time,
  cP: .prediction_timeseries?[-1]?.community_prediction?,
  mP: .metaculus_prediction?[-1]?.x })
