#!/bin/bash
#####################################################################
##
#     compoBot — a bot to post compose-sequences to mastodon
#     ⓒ Joerg Elfring 2020
#
#####################################################################


## Databasefile
database=${database:="./compobot.db3"}

## Wait-time between toots in seconds
minWait=${minWait:=43200}
maxWait=${maxWait:=86400}

## Mastodon Settings&Credentials
mtdVisibility=${mtdVisibility:="direct"}     # public, unlisted, private, direct.
mtdApi=${mtdApi:="https://mastodon.example/api/v1/statuses"}
mtdToken=${mtdToken:="INSERT-YOUR-BEARER-TOKEN"}

#####################################################################

## Source config fro env if there is a file called env.
test -f ./env && source ./env

echo "=============> App-Start at $(date +%Y-%m-%dT%H%M%S)"

## Blow up on errors
set -e

while true ; do
	echo "-------------> Toot-Start at $(date +%Y-%m-%dT%H%M%S)"

	## Create Database if it does not exist
	test -f $database || sh dbFactory.sh $database

	## Number of rows still available,
	## when no row is left, just recreate the database and startover.
	rowsAvailable=$(sqlite3 "$database" "SELECT count(keySequenceROWID) FROM stillAvailable")
	echo rowsAvailable: $rowsAvailable
	if [ $rowsAvailable -eq 0 ] ; then
		echo "Deleting the database and starting ower."
		rm -f $database
		sh dbFactory.sh $database
	fi

	## Pick a random row
	_keySequenceROWID=$(sqlite3 "$database" "SELECT keySequenceROWID FROM stillAvailable ORDER BY RANDOM() LIMIT 1")
	_keySequence=$(sqlite3 "$database" "SELECT keySequence FROM stillAvailable WHERE keySequenceROWID=$_keySequenceROWID")
	_utfCharacter=$(sqlite3 "$database" "SELECT utfCharacter FROM stillAvailable WHERE keySequenceROWID=$_keySequenceROWID")
	_desc1=$(sqlite3 "$database" "SELECT desc1 FROM stillAvailable WHERE keySequenceROWID=$_keySequenceROWID")
	_desc2=$(sqlite3 "$database" "SELECT desc2 FROM stillAvailable WHERE keySequenceROWID=$_keySequenceROWID")
	echo "keySequenceRowID: $_keySequenceROWID"
	echo "keySequence:      $_keySequence"
	echo "utfCharacter:     $_utfCharacter"
	echo "desc1:            $_desc1"
	echo "desc2:            $_desc2"

	## Pick a random phrase to start the toot
	_phrase=$(sqlite3 "$database" "SELECT phrase FROM phrases ORDER BY RANDOM() LIMIT 1")
	echo "phrase:           $_phrase"

	## Build and Send Toot
	toot="$_phrase$_keySequencewill insert     $_utfCharacter($_desc2)"
	curl --form "status=$toot" \
		 --form "visibility=$mtdVisibility" \
		 --header "Authorization: Bearer $mtdToken" \
		 --silent \
		 --show-error \
		 $mtdApi
	echo ""

	## Insert sent-row into db
	sqlite3 "$database" "INSERT INTO alreadySent VALUES($_keySequenceROWID, datetime('now'));"

	## Sleep until the next time
	waitTime=$(shuf -i $minWait-$maxWait -n 1)
	echo "Waiting for $waitTime seconds.  " $(date -d "$waitTime seconds")
	echo ""
	sleep $waitTime

done
