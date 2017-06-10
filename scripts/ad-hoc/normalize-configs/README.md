# Normalize Configs

This uses the default Ruby JSON generator to normalize
all the indentation and line-endings in the config.json files
in all the tracks.

This lets us update the configs programmatically without the
extra noise that extra whitespace adds.

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
