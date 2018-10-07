map(select(.qtype == "binary")) |
map({
  id: .id,
  title: .title,
  res: (if .resolution == 1 then true elif .resolution == 0 then false else null end),
  resolved: true,
  res_at: .resolve_time,
  cP: .cpred,
  mP: (.mpred // .mpost) })
