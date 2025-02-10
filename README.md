# gromgit's macOS FUSE stuff

This tap exists to support macOS FUSE-related software that have been dropped from Homebrew core.

---

# !!! WARNING: Mojave Deprecation !!!

Homebrew dropped support for macOS Mojave as of 25 Oct 2021. I'll continue to build Mojave bottles for the FUSE formulae for now, but ***not*** for any external dependencies that they rely on, _especially core formulae_. Therefore, at some point in 2022, I will also no longer support Mojave in this tap.

---

## How do I install these formulae?

First, if you've already installed FUSE formulae from the core tap _before_ they were disabled, you might _not_ want to switch over to my formulae, because:
1. As far as I know, Homebrew will not remove them from your system, even after the formulae themselves are deleted.
2. Many of these formulae are rather old, so you're unlikely to find updates anyway.

But if you _do_ want to install my formulae over the core ones, you should uninstall the latter first.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

## FAQ

### Why is XYZ not available?

It's probably available, but with a `-mac` suffix to avoid name clashes with Homebrew core (e.g. `sshfs` becomes `sshfs-mac`).

If you can't find it under its new name, possible reasons include:
1. All available versions of `XYZ` require version 3 of the libfuse API, but macFUSE only supports v2.
2. I might not have gotten around to getting it up. [File an issue](https://github.com/gromgit/homebrew-fuse/issues/new/choose) to get my attention. 😀

### Why is XYZ so old?

Possible reasons:
1. Current `XYZ` requires libfuse v3, so I found and bottled the last version that requires libfuse v2.
2. `XYZ` was abandoned by its authors. If you know of a revived fork of such software, [file an issue](https://github.com/gromgit/homebrew-fuse/issues/new/choose) with the details and I'll see what can be done.
3. I might not have gotten around to updating it yet. [File an issue](https://github.com/gromgit/homebrew-fuse/issues/new/choose) to get my attention. 😀

### Why is the XYZ formula called `XYZ-mac`?

To avoid a naming conflict with the formula called `XYZ` that still exists in Homebrew core.

### Why is the XYZ _program_ installed as `XYZ-mac`?

`brew info gromgit/fuse/XYZ-mac` and read the _Caveats_ section.

### Why does Homebrew say I need to build `XYZ-mac` from source?

It's likely one of the following:
1. You're using an M1 Mac. I don't have one, so there are no bottles (for now).
2. You're running Homebrew on an Intel Mac in a non-standard location, so the existing bottles won't install for you.

### Why can't I build XYZ on an M1 Mac?

Homebrew currently [filters out `/usr/local` entirely during M1-based builds](https://github.com/Homebrew/brew/blob/04532cb6216b69a5b067aa7a4e22cff0944b257d/Library/Homebrew/shims/super/cc#L266-L270). I've devised a workaround for this, and it works on Intel Big Sur with Homebrew installed in a non-standard location, but I don't have an M1 Mac, so I can't test it for real. If you still can't build it, please [file an issue](https://github.com/gromgit/homebrew-fuse/issues/new/choose).

If you need the software urgently, you'll have to set up a Rosetta-based Homebrew installation (which has prebuilt bottles):
```
arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
/usr/local/bin/brew install <FUSE_formula>
```
