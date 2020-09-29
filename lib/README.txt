How to get the list of usable key-sequences?
--------------------------------------------
Download the X11 compose-sequences for en_US.UTF-8¹ and get rid of some things:
- Comments (XCOMM)
- Sequences not started my Multi_key
- Sequences containing non-standard characters (U.... and U.....)
- Sequences containing non-international keys (cyrillic, greek, kana)
- Sequences containing other dead keys
This is done by grep in dbFactory.sh

¹) en_US.UTF-8 seems to be quite complete and also available on other locales.


Convert to psv
--------------
- Plus-separated-values because + is not used elsewhere in the file.
- Regex to extract the fields into psv.
- The second description is all-uppper, we'll convert it to all lower.
This is done by sed in dbFactory.sh

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
Create a table for characters we already sent.
	CREATE TABLE "alreadySent" (
		"keySequenceROWID" INTEGER,
		"timestamp"        INTEGER
	);

Create a view with yet unsent characters
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
		);

Add some phrases to start the toot with
---------------------------------------
Create a table with some entry-phrases:
	CREATE TABLE "phrases" (
		"phrase" TEXT
	);
	.mode csv
	.separator "+"
	.import phrases.txt phrases
