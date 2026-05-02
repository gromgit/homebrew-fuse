require_relative "../require/macfuse"

class IfuseMac < Formula
  desc "FUSE module for iOS devices"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/ifuse/archive/refs/tags/1.2.1.tar.gz"
  sha256 "3c87f10111433e73fce93f51b2d14e1168add4da4d21d505abe6d7208af7f6ac"
  license "LGPL-2.1-or-later"
  head "https://github.com/libimobiledevice/ifuse.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "33c30efea5ef9a0fb991cfc7abe55a50d793cd0518d9a151a95c34f9c31ba600"
    sha256 cellar: :any, arm64_sequoia: "8f1e11a4b6ff079505303593fa5d684010431f180c078befd981d3461a463d5e"
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
    # This file can be generated only if `.git` directory is present
    # Create it manually
    (buildpath/".tarball-version").write version.to_s

    setup_fuse3
    system "./autogen.sh", *std_configure_args
    system "make", "install"
  end

  test do
    # Actual test of functionality requires osxfuse, so test for expected failure instead
    assert_match "ERROR: No device found!", shell_output("#{bin}/ifuse --list-apps", 1)
  end
end
