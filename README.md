# gromgit's macOS FUSE stuff

This tap exists to support macOS FUSE-related software that have been dropped from Homebrew core.

## How do I install these formulae?

First, if you've already installed FUSE formulae from the core tap _before_ they were disabled, you might _not_ want to switch over to my formulae, because:
1. As far as I know, Homebrew will not remove them from your system, even after the formulae themselves are deleted.
2. Many of these formulae are rather old, so you're unlikely to find updates anyway. 

But if you _do_ want to install my formulae over the core ones, you should uninstall the latter first:
```
brew uninstall XYZ
brew install gromgit/fuse/XYZ-mac
```

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

## FAQ

### Why is XYZ not available?

Possible reasons:
1. All available versions of `XYZ` require version 3 of the libfuse API, but macFUSE only supports v2.
2. I might not have gotten around to getting it up. [File an issue](https://github.com/gromgit/homebrew-fuse/issues/new/choose) to get my attention. 😀

### Why is XYZ so old?

Possible reasons:
1. Current `XYZ` requires libfuse v3, so I found and bottled the last version that requires libfuse v2.
2. `XYZ` was abandoned by its authors. If you know of a revived fork of such software, [file an issue](https://github.com/gromgit/homebrew-fuse/issues/new/choose) with the details and I'll see what can be done.
3. I might not have gotten around to updating it yet. [File an issue](https://github.com/gromgit/homebrew-fuse/issues/new/choose) to get my attention. 😀

### Why is your formula called `XYZ-mac`?

To avoid a naming conflict with the formula called `XYZ` that still exists in Homebrew core.

### Why is the XYZ _program_ installed as `XYZ-mac`?

`brew info gromgit/fuse/XYZ-mac` and read the _Caveats_ section.
