#!/bin/bash

# script for calculation if the distribution of notification sample sizes is correct, an input file with versions is needed
# you have to have a filterserver set up and running locally first: https://gitlab.com/eyeo/adblockplus/abpui/adblockplusui/-/wikis/Setup-filter-server-to-test-notifications

for i in $(seq 5000); do
	curl --progress-bar "http://notification.local/notification.json" | grep version;
done > notifications-versions-file

##################
# vars that need to be specified:
sourcefile=notifications-versions-file
setDists=(0.001 0.009 0.04 0.05 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1)
##################

allRequests=$(cat $sourcefile | wc -l)

echo 'all requests: '$allRequests
echo

for i in ${!setDists[@]}; do
	#let "x=i+1"
	#we need X for grepping version pattern that starts with 1
	x=$((i+1))
 	eval sampleVersionPattern="'7/$x\"'"
 	eval "requestsInSample=$(cat $sourcefile | grep -c "$sampleVersionPattern")"
 	eval "actualDist=$(echo "scale=4 ; $requestsInSample / $allRequests" | bc)"

 	echo 'number of requests in sample: '$x 'with pattern' $sampleVersionPattern ':' $requestsInSample
	echo 'set distribution: '${setDists[$i]}
	echo 'actual distribution: '$actualDist
	echo
 done
