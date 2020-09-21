-- A table for the sequences
CREATE TABLE "keySequences" (
	"keySequence"    TEXT NOT NULL,
	"utfCharacter"   TEXT NOT NULL,
	"desc1"          TEXT,
	"desc2"          TEXT
);

-- A table for characters we already sent.
	CREATE TABLE "alreadySent" (
		"keySequenceROWID" INTEGER,
		"timestamp"        INTEGER
	);

-- A view with yet unsent characters
	CREATE VIEW stillAvailable (
		keySequenceROWID,
		keySequence,
		utfCharacter,
		desc1,
        desc2
		)
	AS
	SELECT ROWID, keySequence, utfCharacter, desc1, desc2
		FROM keySequences
		WHERE ROWID NOT IN (
			SELECT keySequenceROWID
			FROM alreadySent
		);

-- A table with some entry-phrases:
CREATE TABLE "phrases" (
    "phrase" TEXT
);

-- Load Data
.mode csv
.separator "+"
.import lib/phrases.txt phrases
.import /tmp/compose.psv keySequences
