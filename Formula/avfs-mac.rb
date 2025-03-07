require_relative "../require/macfuse"

class AvfsMac < Formula
  desc "Virtual file system that facilitates looking inside archives"
  homepage "https://avf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/avf/avfs/1.2.0/avfs-1.2.0.tar.bz2"
  sha256 "a25a8ec43c1ee172624e1a4c79ce66a1b930841cdb545b725f1ec64bcabe889c"
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
    rebuild 1
    sha256 arm64_sonoma: "05159912f28e370dcd6ade51a51f4ff3692aa51d7b289d438df55f86fa8c0102"
    sha256 ventura:      "96d445c9a324a03e0abe222f798b1b3cf3be8cd6e0b810e0f408314453df835d"
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
