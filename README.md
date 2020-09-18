# compoBot — A bot to toot composekey sequences
The compose key (a.k.a. Multi Key) is a massively useful and
(unfortunately) forgotten feature.
It lets you type a keyboard sequence eg. `<Multi_Key><t><m>` and
it inserts a special character: ™.

This bot regularly toots one of those sequences to a mastodon
account so that everyone can appreciate them.

The sequences used, are standard on modern linux systems.
However, the compose/multikey is usually not mapped on most
keyboards.
With `xmodmap`, it can be mapped to a rarely used key like menu
or capslock.
On windows systems, there is
(WinCompose)[https://github.com/samhocevar/wincompose]
to get similar results.

## Usage
compoBot can be used from shell or docker.
The prerequisits are minimal: sqlite3, curl and the standard tools.

It is configured by environment variables wich may be set in a file
called env.

| Variable      | Default                                  | Description                                  |
|---------------|------------------------------------------|----------------------------------------------|
| database      | ./working-db.db3 /data/working-db.db3    | Databasefile, should be persistant in docker |
| minWait       | 43200             (12 h)                 | Minimum random time to wait between toots    |
| maxWait       | 86400             (24 h)                 | Maximum random time to wait between toots    |
| mtdVisibility | direct                                   | Privacy setting for the toot¹                |
| mtdApi        | https://mastodon.example/api/v1/statuses | API endpoint to sent statuses²               |
| mtdToken      | THIS_SHOULD_BE_A_Bearer-Token            | API authentication²                          |

¹) https://docs.joinmastodon.org/user/posting/
²) https://docs.joinmastodon.org/methods/apps/#create-an-application

