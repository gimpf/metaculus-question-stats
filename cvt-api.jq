include "./lib";

def scaleNum($scale):
  (if $scale.deriv_ratio == 1
   then .
   else "unsupported: deriv_ratio != 1" # figure out what this does, some day
   end) * ($scale.max - $scale.min) + $scale.min
  ;

def scaleDate($scale):
  if   $scale.deriv_ratio == 1
  then scaleNum({ min: $scale.min | fromdate, max: $scale.max | fromdate, deriv_ratio: $scale.deriv_ratio }) | epochtodate
  else "unsupported: deriv_ratio != 1"
  end
  ;

def scalePossible($poss):
  if   . == null                  then null
  elif $poss.type == "binary"     then .
  elif $poss.type == "continuous" then
      (if   $poss.format == "num"  then .q2 | scaleNum($poss.scale)
       elif $poss.format == "date" then .q2 | scaleDate($poss.scale)
       else "unsupported: format: " + $poss.format
       end)
  else "unsupported: possibility type not in (binary, continuous): " + $poss.type
  end
  ;

def mapResolution($poss):
  if . == -1                  then "ambiguous"
  elif $poss.type == "binary" then . == 1
  else .
  end
  ;

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
  })
