# Remove Ignored

This deletes the "ignored" key from the config.json of all tracks.

Since all exercise implementations are contained within the exercises directory,
we no longer need to ignore specific directories in the root of the track.

## Reference

See https://github.com/exercism/meta/issues/3

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
