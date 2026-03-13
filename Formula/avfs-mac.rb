require_relative "../require/macfuse"

class AvfsMac < Formula
  desc "Virtual file system that facilitates looking inside archives"
  homepage "https://avf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/avf/avfs/1.3.0/avfs-1.3.0.tar.bz2"
  sha256 "07cd69d4c0c7ed080e80ff040d980286405ad38a443fdc52dc395efef11c44b1"
  license all_of: [
    "GPL-2.0-only",
    "LGPL-2.0-only", # for shared library
    "GPL-2.0-or-later", # modules/dav_ls.c
    "Zlib", # zlib/*
  ]

  livecheck do
    url :stable
    regex(%r{url=.*?/avfs[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 arm64_tahoe:   "09e130d97d483441bbb2ad2c16a81557c482ef508a4f5448666ac13eb92cd148"
    sha256 arm64_sequoia: "35edcdb1c8bf28b9b16e81b6f0ad84452317331b09a50930cd6219facc91012b"
  end

  depends_on "pkgconf" => :build
  depends_on "bzip2"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "xz"
  depends_on "zlib"

  def install
    setup_fuse
    system "./configure", "--disable-silent-rules",
                          "--enable-fuse",
                          "--enable-library",
                          "--with-system-zlib",
                          "--with-system-bzlib",
                          "--with-xz",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"avfsd", "--version"
  end
end
