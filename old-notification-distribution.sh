#!/bin/bash

# this is just ugly, ignore it. served well as a starting point

#sourcefile=1kout
sourcefile=5kout
#sourcefile=10kout
#sourcefile=83kout
allrequests=$(cat $sourcefile | wc -l)

sample1=$(cat $sourcefile | grep -c '7/1"')
sample2=$(cat $sourcefile | grep -c '7/2"')
sample3=$(cat $sourcefile | grep -c '7/3"')
sample4=$(cat $sourcefile | grep -c '7/4"')
sample5=$(cat $sourcefile | grep -c '7/5"')

echo 'all requests: '
echo $allrequests
echo
echo 'sample 1, number of requests: '$sample1
echo 'set distribution: '
echo .001
echo 'actual distribution: '
echo "scale=4 ; $sample1 / $allrequests" | bc
echo
echo 'sample 2, number of requests: '$sample2
echo 'set distribution: '
echo .009
echo 'actual distribution: '
echo "scale=3 ; $sample2 / $allrequests" | bc
echo
echo 'sample 3, number of requests: '$sample3
echo 'set distribution: '
echo .04
echo 'actual distribution: '
echo "scale=2 ; $sample3 / $allrequests" | bc
echo
echo 'sample 4, number of requests: '$sample4
echo 'set distribution: '
echo .05
echo 'actual distribution: '
echo "scale=2 ; $sample4 / $allrequests" | bc
echo
echo 'sample 5, number of requests: '$sample5
echo 'set distribution: '
echo .1
echo 'actual distribution: '
echo "scale=2 ; $sample5 / $allrequests" | bc
