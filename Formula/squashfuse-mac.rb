require_relative "../require/macfuse"

class SquashfuseMac < Formula
  desc "FUSE filesystem to mount squashfs archives"
  homepage "https://github.com/vasi/squashfuse"
  url "https://github.com/vasi/squashfuse/releases/download/0.5.2/squashfuse-0.5.2.tar.gz"
  sha256 "54e4baaa20796e86a214a1f62bab07c7c361fb7a598375576d585712691178f5"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/squashfuse-mac-0.1.104"
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "d54920002790e1cbf24e78ae5e0bfdd4d88ab8f0b8282c20d902e9202f474569"
    sha256 cellar: :any, monterey:       "908aafed75c0fba5d1e4da9a5342b93ab7e10b1c2cc5f6949c0a63e8fefdc4f9"
    sha256 cellar: :any, big_sur:        "d90a812d02c57e0515044fb7294d50216e8d68503da793234f5759444bf8f079"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "lz4"
  depends_on "lzo"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "squashfs"
  depends_on "xz"
  depends_on "zlib"
  depends_on "zstd"

  def install
    setup_fuse
    system "./configure", *std_configure_args
    system "make", "install"
  end

  # Unfortunately, making/testing a squash mount requires sudo privileges, so
  # just test that squashfuse execs for now.
  test do
    output = shell_output("#{bin}/squashfuse --version 2>&1", 254)
    assert_match version.to_s, output
  end
end
