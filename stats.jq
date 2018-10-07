#
# run with: jq -fr stats.jq data-questions.json
#

def rrange(start; endDate):
  map(select(.res_at >= start + "T00:00:00Z" and .res_at < endDate + "00:00:00Z"));

def crange(start; endDate):
  map(select(.cre_at >= start + "T00:00:00Z" and .cre_at < endDate + "00:00:00Z"));

def fromdateisolike:
  # remove microseconds, then uild a full ISO time string so that we can get a valid time struct, including weekday
  capture("(?<y>\\d{4})-(?<m>\\d{2})-(?<d>\\d{2})T(?<H>\\d{2}):(?<M>\\d{2}):(?<S>\\d{2})(\\.\\d+)?Z") |
  (.y + "-" + .m + "-" + .d + "T" + .H + ":" + .M + ":" + .S + "Z") |
  strptime("%Y-%m-%dT%H:%M:%SZ") |
  mktime;

def short($days):
  map(select(  (.res_at | fromdateisolike) <= (.cre_at | fromdateisolike + (60*60*24*$days)) ));

def countResolved:
  map(select(.resolved)) | length;

def countUnambiguous:
  map(select(.resolved and .res != null)) | length;

def countYes:
  map(select(.resolved and .res)) | length;

def ratioYes:
  countYes as $yes | countUnambiguous as $resolved | if $resolved == 0 then null else $yes / $resolved end;

def rstats:
  { resolving: . | length, resolved: . | countResolved, unambiguous: . | countUnambiguous, yes: . | countYes, ratio: . | ratioYes };

def cstats:
  { new: . | length, short7d: . | short(7) | length, short14d: . | short(14) | length, short28d: . | short(28) | length };

def allstats($start; $endDate):
  . as $all |
  (($all | rrange($start; $endDate) | rstats) +
   ($all | crange($start; $endDate) | cstats));

. as $all |
[ { t: "2017Q1", s: "2017-01-01", e: "2017-04-01" },
  { t: "2017Q2", s: "2017-04-01", e: "2017-07-01" },
  { t: "2017Q3", s: "2017-07-01", e: "2017-10-01" },
  { t: "2017Q4", s: "2017-10-01", e: "2018-01-01" },
  { t: "2018Q1", s: "2018-01-01", e: "2018-04-01" },
  { t: "2018Q2", s: "2018-04-01", e: "2018-07-01" },
  { t: "2018Q3", s: "2018-07-01", e: "2018-10-01" },
  { t: "2018Q4", s: "2018-10-01", e: "2019-01-01" },
  { t: "2019Q1", s: "2019-01-01", e: "2019-04-01" } ] |
reduce .[] as $item (
    [];
    . + [
        ({ "period": $item.t } +
        ($all | allstats($item.s; $item.e)))
    ]) |
["period", "resolving", "resolved", "unambiguous", "yes", "ratio", "new", "short7d", "short14d", "short28d"] as $keys | $keys, map([.[ $keys[] ]])[] |
@csv
