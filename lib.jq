# select items resolving within range
def rrange(start; endDate):
  map(select(.res_at >= start + "T00:00:00Z" and .res_at < endDate + "00:00:00Z"));

# select items created within rnage
def crange(start; endDate):
  map(select(.cre_at >= start + "T00:00:00Z" and .cre_at < endDate + "00:00:00Z"));

def fromdate:
  strptime("%Y-%m-%d") | mktime;

def epochtodate:
  gmtime | strftime("%Y-%m-%d");

def fromdatetimeisolike:
  # remove microseconds, then build a full ISO time string so that we can get a valid time struct, including weekday
  capture("(?<y>\\d{4})-(?<m>\\d{2})-(?<d>\\d{2})T(?<H>\\d{2}):(?<M>\\d{2}):(?<S>\\d{2})(\\.\\d+)?Z") |
  (.y + "-" + .m + "-" + .d + "T" + .H + ":" + .M + ":" + .S + "Z") |
  strptime("%Y-%m-%dT%H:%M:%SZ") |
  mktime;

# selects items which resolve within $days of being created
def short($days):
  map(select(  (.res_at | fromdatetimeisolike) <= (.cre_at | fromdatetimeisolike + (60*60*24*$days)) ));

# all items that have been resolved
def countResolved:
  map(select(.resolved)) | length;

# all items that have been resolved unambiguously
def countUnambiguousBinary:
  map(select(.resolved and .res != null and .type == "binary")) | length;

# all items that have been resolved as true/yes/positive
def countYes:
  map(select(.resolved and .res == true)) | length;

# ratio of yes resolution of unambiguous binary resolutions
def ratioYes:
  countYes as $yes | countUnambiguousBinary as $resolved | if $resolved == 0 then null else $yes / $resolved end;

def rstats:
  { resolving: . | length, resolved: . | countResolved, unambiguous: . | countUnambiguousBinary, yes: . | countYes, ratio: . | ratioYes };

def cstats:
  { new: . | length, short7d: . | short(7) | length, short14d: . | short(14) | length, short28d: . | short(28) | length };

def allstats($start; $endDate):
  . as $all |
  (($all | rrange($start; $endDate) | rstats) +
   ($all | crange($start; $endDate) | cstats));
