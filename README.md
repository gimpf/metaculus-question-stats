# OBSOLETE Metaculus Question Stats

**Don't use this.  Hopelessly buggy, outdated, unmaintained!**

Simple stats about metaculus questions, like number created or resolved.

**Only binary questions are used for those stats!**

**Prerequisites**:
* a unix shell
* `jq`


**Enjoyment**:
To get results, run `./fetch && ./convert && ./query stats`, and get something like

```csv
"period","resolving","resolved","unambiguous","yes","ratio","new","short7d","short14d","short28d"
"2017Q1",32,32,30,6,0.1875,23,0,0,0
"2017Q2",20,20,20,5,0.25,15,3,3,3
```

**period**: time-frame  
**resolving**: number of questions that are (planned) to resolve in the time-frame  
**resolved**: number of questions that actually resolved  
**unambiguous**: of _resolved_ only those that were unambiguous  
**yes**: resolved positively  
**new**: new questions that were published during that time-frame (_not_ created, as many won't see the light of day)  
**shortXYd**: questions that resolved within x days after being published
