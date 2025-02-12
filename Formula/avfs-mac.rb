require_relative "../require/macfuse"

class AvfsMac < Formula
  desc "Virtual file system that facilitates looking inside archives"
  homepage "https://avf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/avf/avfs/1.1.5/avfs-1.1.5.tar.bz2"
  sha256 "ad9f3b64104d6009a058c70f67088f799309bf8519b14b154afad226a45272cf"
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
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/avfs-mac-1.1.5"
    sha256 arm64_monterey: "b68a4d79bebd62b4e7cc7ceff13aed1305e1e1db268cbbffa14ab3b26c4508be"
    sha256 monterey:       "9b0e55804b9c8b98a25aac295d0fb7ae352f9b446c35e210b260821e27ef0d9b"
    sha256 big_sur:        "5500a012293e374d1ed9476fe45c740c3739c15b416d503cde99fad1f9b3079d"
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
