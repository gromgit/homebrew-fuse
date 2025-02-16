# gromgit's macOS FUSE stuff

This tap exists to support macOS FUSE-related software that have been dropped from Homebrew core.

---

# !!! WARNING: Reduced Build Coverage !!!

All my old Intel Mac hardware is dead, and I'm not inclined to spend additional resources spinning up VMs or building Hackintoshes at this stage. As of 2025-Feb-10, the only bottles built will be for those macOS versions supported by GitHub runners (currently Ventura on Intel and Sonoma on ARM). Sorry.

---

## How do I install these formulae?

First, if you've already installed FUSE formulae from the core tap _before_ they were disabled, you might _not_ want to switch over to my formulae, because:
1. As far as I know, Homebrew will not remove them from your system, even after the formulae themselves are deleted.
1. Many of these formulae are rather old, so you're unlikely to find updates anyway.

But if you _do_ want to install my formulae over the core ones, you should uninstall the core formulae first.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

## FAQ

### Why is XYZ not available?

It's probably available, but with a `-mac` suffix to avoid name clashes with Homebrew core (e.g. `sshfs` becomes `sshfs-mac`).

If you can't find it under its new name, possible reasons include:
1. All available versions of `XYZ` require version 3 of the libfuse API, but macFUSE only supports v2.
1. I might not have gotten around to getting it up. [File an issue](https://github.com/gromgit/homebrew-fuse/issues/new/choose) to get my attention. 😀

### Why is XYZ so old?

Possible reasons:
1. Current `XYZ` requires FUSE 3, which is not supported by all known macOS FUSE drivers, so the version you see is the latest one that can be built on macOS.
1. `XYZ` was abandoned by its authors. If you know of a revived fork of such software, [file an issue](https://github.com/gromgit/homebrew-fuse/issues/new/choose) with the details and I'll see what can be done.
1. I might not have gotten around to updating it yet. [File an issue](https://github.com/gromgit/homebrew-fuse/issues/new/choose) to get my attention. 😀

### Why is the XYZ formula called `XYZ-mac`?

To avoid a naming conflict with the formula called `XYZ` that still exists in Homebrew core.

### Why is the XYZ _program_ installed as `XYZ-mac`?

`brew info gromgit/fuse/XYZ-mac` and read the _Caveats_ section.

### Why does Homebrew say I need to build `XYZ-mac` from source?

All my old Intel Mac hardware is dead, so I'm relying now on the free GitHub runners to build bottles.

### Why can't I build XYZ on an ARM Mac?

Homebrew currently [filters out `/usr/local` entirely during ARM-based builds](https://github.com/Homebrew/brew/blob/04532cb6216b69a5b067aa7a4e22cff0944b257d/Library/Homebrew/shims/super/cc#L266-L270). I've devised a workaround for this, that seems to work well on both Intel and ARM GitHub runners. If you still can't build it, please [file an issue](https://github.com/gromgit/homebrew-fuse/issues/new/choose).

## Why aren't you using fuse-t in place of MacFUSE?

As of 2025-Feb-16, [fuse-t](https://github.com/macos-fuse-t/fuse-t) is certainly interesting, but not enough of an improvement to make me force everyone to move over.

For this to happen, at least one of the following needs to happen:

1. **open source**, so there's a hope of getting it into Homebrew core _a la_ `libfuse{,@2}`, and get rid of all the `require` hackery in these formulae
1. **FUSE 2 and 3 support**, so we're not stuck in the past with half these formulae, but are still able to build older FUSE 2 formulae

If any macOS FUSE implementation achieves *all* the above, I'm prepared to move everything over. Heck, if point 1 is achieved, this repo may itself become defunct.
