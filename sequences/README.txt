How to get the list of usable key-sequences?
--------------------------------------------
Download the X11 compose-sequences for en_US.UTF-8¹ and get rid of some things:
- Comments (XCOMM)
- Sequences not started my Multi_key
- Sequences containing non-standard characters

¹) en_US.UTF-8 seems to be quite complete and also available on other locales.

```
$ wget https://cgit.freedesktop.org/xorg/lib/libX11/plain/nls/en_US.UTF-8/Compose.pre
$ grep -i '^<multi' Compose.pre | grep -v '<U....>' | grep -v 'U.....>'  > Compose.usable
```


Convert to psv
--------------
Plus-separated-values because + is not used in the file.
Regex to extract the fields then remove tabs and squish spaces.
TODO: There must be a better regex for this. Also, this leaves begin-of-field spaces.

```
$ sed --regexp-extended 's/(.*): \"(.*)\"(.*)#(.*)/\1+\2+\3+\4/' Compose.usable | tr -d "\t" | tr -s " " > Compose.psv
```

Load into SQLite
----------------
$ sqlite3 Compose.db3
	CREATE TABLE "keySequences" (
		"keySequence"    TEXT NOT NULL,
		"utfCharacter"   TEXT NOT NULL,
		"desc1"          TEXT,
		"desc2"          TEXT
	);
	.mode csv
	.separator "+"
	.import Compose.psv keySequences



How to get random, unique entries that do not repeat
----------------------------------------------------
Create a table for ids we already sent.
	CREATE TABLE "alreadySent" (
		"keySequenceROWID" INTEGER,
		"timestamp"        INTEGER
	);

Create a view with yet unsent rows
	CREATE VIEW stillAvailable (
		keySequenceROWID,
		keySequence,
		utfCharacter,
		desc1,desc2
		)
	AS
    	SELECT ROWID, keySequence, utfCharacter, desc1, desc2
		FROM keySequences
		WHERE ROWID NOT IN (
			SELECT keySequenceROWID
			FROM alreadySent
		)

Add some phrases to start the toot with
---------------------------------------
Create a table with some entry-phrases:
	CREATE TABLE "phrases" (
		"phrase" TEXT
	);
	.mode csv
	.separator "+"
	.import phrases.txt phrases
