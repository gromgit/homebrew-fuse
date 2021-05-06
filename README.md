# gromgit's macOS FUSE stuff

This tap exists to support macOS FUSE-related software that have been dropped from Homebrew core.

## How do I install these formulae?
`brew install gromgit/fuse/<formula>`

## Documentation
`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

## FAQ

### Why is XYZ not available?
Probably because I haven't gotten around to putting it in yet. If you need it, [file an issue](https://github.com/gromgit/homebrew-fuse/issues/new/choose) and I'll see what can be done.

### Why is XYZ so old?
Maybe I just haven't gotten around to updating it yet, but a significant subset simply can't be updated until MacFUSE supports version 3 of the FUSE API. These will be labeled as such in their _Caveats_.

Other formulae seem to have been abandoned by their authors. If you know of a revived fork of such software, [file an issue](https://github.com/gromgit/homebrew-fuse/issues/new/choose) with the details and I'll see what can be done.

### Why is the XYZ program installed as `XYZ-mac`?
Some formulae (e.g. `rclone`) are still available in Homebrew core, just without FUSE functionality and dependencies. My FUSE-enabled binaries for these formulae will always be name with a `-mac` suffix to prevent naming conflicts, but see each formula's _Caveats_ section for instructions on how to access these binaries via their original names.
