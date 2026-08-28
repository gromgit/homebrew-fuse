require_relative "../require/macfuse"

class SquashfuseMac < Formula
  desc "FUSE filesystem to mount squashfs archives"
  homepage "https://github.com/vasi/squashfuse"
  url "https://github.com/vasi/squashfuse/releases/download/0.6.3/squashfuse-0.6.3.tar.gz"
  sha256 "0c9f582ca488dc5eb450830d72f45a042ef5c0476118502ab5ed86ae9dd8bd46"
  license "BSD-2-Clause"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "3f09772bd8fd6805229adabccf6bb3423181c772e4376c931872d06e9e7671ee"
    sha256 cellar: :any, arm64_sequoia: "8e0dca625cd73c16f5be12e9757358b04a3408a73b185136bed321eb474ec00b"
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
