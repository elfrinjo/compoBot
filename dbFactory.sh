#!/bin/bash

if [ $# -ne 1 ]; then
	echo "This script shoud only be run from inside compoBot.sh"
	echo ""
	echo "Usage:"
	echo "$ sh dbFactory.sh /path/to/new/dbfile.db3"
	echo ""
	exit 1
fi

target=$1

cat lib/Compose.pre \
	| grep '^<Multi_key>' \
	| grep -v '<dead_' \
	| grep -v '<Cyrillic_' \
	| grep -v '<Greek_' \
	| grep -v '<kana_' \
	| grep -v '<U....>' \
	| grep -v '<U.....>' \
	| sed  --regexp-extended 's/(.*>)\s*:\s\"(.*)\"\s*(\S*)\s*#\s*(.*)/\1+\2+\3+\L\4/' \
	> /tmp/compose.psv

sqlite3 $target ".read lib/initDb.sql"
