include "./lib";

def scaleNum($scale):
  (if $scale.deriv_ratio == 1
   then .
   else 0 # TODO error: "unsupported: deriv_ratio != 1"
   end) * ($scale.max - $scale.min) + $scale.min
  ;

def scaleDate($scale):
  scaleNum({ min: $scale.min | fromdate, max: $scale.max | fromdate, deriv_ratio: $scale.deriv_ratio }) | epochtodate
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

def mapType($poss):
  if   . == null                  then null
  elif $poss.type == "binary"     then "binary"
  elif $poss.type == "continuous" then
    (if   $poss.format == "num"   then "numeric"
     elif $poss.format == "date"  then "date"
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
