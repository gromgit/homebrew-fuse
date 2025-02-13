require_relative "../require/macfuse"

class IfuseMac < Formula
  desc "FUSE module for iOS devices"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/ifuse/archive/refs/tags/1.1.4.tar.gz"
  sha256 "2a00769e8f1d8bad50898b9d00baf12c8ae1cda2d19ff49eaa9bf580e5dbe78c"
  license "LGPL-2.1-or-later"
  head "https://github.com/libimobiledevice/ifuse.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    rebuild 1
    sha256 cellar: :any, arm64_sonoma: "06ceadb0e0c288cc0f02b5c64c7051f8d54dd39d697801c305ba70101780e3ee"
    sha256 cellar: :any, ventura:      "d7aecf23caa314cb17ae46d790af547fceca621a300f19f74b2593c0c4cafe10"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libimobiledevice"
  depends_on "libplist"
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    system "./autogen.sh", *std_configure_args
    system "make", "install"
  end

  test do
    # Actual test of functionality requires osxfuse, so test for expected failure instead
    assert_match "ERROR: No device found!", shell_output("#{bin}/ifuse --list-apps", 1)
  end
end
