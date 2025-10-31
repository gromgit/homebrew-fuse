require_relative "../require/macfuse"

class IfuseMac < Formula
  desc "FUSE module for iOS devices"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/ifuse/archive/refs/tags/1.2.0.tar.gz"
  sha256 "29ab853037d781ef19f734936454c7f7806d1c46fbcca6e15ac179685ab37c9c"
  license "LGPL-2.1-or-later"
  head "https://github.com/libimobiledevice/ifuse.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_sequoia: "7b2a54ceeca52d5ada2e625f7e3edbcdd7f6eedfc8b8f6286137fb38fcff50e6"
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
