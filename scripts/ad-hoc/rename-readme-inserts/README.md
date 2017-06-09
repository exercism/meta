# Rename README Inserts

Rename the old `./SETUP.md` or `{exercises/,./}TRACK_HINTS.md` file to `docs/EXERCISE_README_INSERT.md`.

## Reference

See https://github.com/exercism/meta/issues/5

## Assumptions

This assumes that

* [hub][] is installed and configured, and
* all the existing language track repositories are checked out into a directory called `tracks`:

    tree -L 1 tracks/
    ├── xbash
    ├── ...
    └── xvimscript

The script should be executed from the directory that contains the tracks directory.

[hub]: http://github.com/github/hub
