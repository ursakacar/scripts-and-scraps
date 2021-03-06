#!/bin/bash

# script for calculation if the distribution of notification sample sizes is correct, an input file with versions is needed
# you have to have a filterserver set up and running locally first: https://gitlab.com/eyeo/adblockplus/abpui/adblockplusui/-/wikis/Setup-filter-server-to-test-notifications


##################
# vars that need to be specified:
numberOfRequests=7000
notificationId=8
sourceFile=notifications-versions-file
resultsFile=04_ui-860-activate-20-reach-50__results.txt
setDists=(0.01 0.14 0.15 0.20 0.20 0.15 0.15)
##################

for i in $(seq $numberOfRequests); do
	curl -k --insecure --progress-bar "https://notification.local/notification.json" | grep 'version\|links';
done > notifications-versions-file

allRequests=$(cat $sourceFile | wc -l)

(echo;
echo 'PATCH: ' $resultsFile;
echo 'all requests: '$allRequests) > $resultsFile

# how many % had links
 	eval "notificationsInSample=$(cat $sourceFile | grep -c "links")"
 	eval "notificationDistribution=$(echo "scale=2 ;  $notificationsInSample / $numberOfRequests" | bc)"
	(echo 'number of notifications: '$notificationsInSample;
	echo 'notification distribution: '$notificationDistribution;
	echo '_____________';
	echo) >> $resultsFile

# distribution of each variant
for i in ${!setDists[@]}; do
	#we need X for grepping version pattern that starts with 1
	x=$((i+1))
 	eval sampleVersionPattern="'$notificationId/$x\"'"
 	eval "requestsPerVersion=$(cat $sourceFile | grep -c "$sampleVersionPattern")"
 	eval "actualVersionDist=$(echo "scale=4 ; $requestsPerVersion / $numberOfRequests" | bc)"

 	(echo 'number of requests for version: '$x 'with pattern' $sampleVersionPattern ':' $requestsPerVersion;
	echo 'set version distribution: '${setDists[$i]};
	echo 'actual distribution: '$actualVersionDist;
	echo) >> $resultsFile
 done

cat $resultsFile