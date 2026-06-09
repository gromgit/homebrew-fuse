require_relative "../require/macfuse"

class SquashfuseMac < Formula
  desc "FUSE filesystem to mount squashfs archives"
  homepage "https://github.com/vasi/squashfuse"
  url "https://github.com/vasi/squashfuse/releases/download/0.6.2/squashfuse-0.6.2.tar.gz"
  sha256 "267f2852d6e20147eb1e21931f9d0fe7634a66612f1ede27e15fa60e56ce0eac"
  license "BSD-2-Clause"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "16382327e0843677de5dca5dc384a84e928a71a1f0088372e0092eb5e5477287"
    sha256 cellar: :any, arm64_sequoia: "87c11eb7c835d600ed8680d656625299c32a80750226828c5116343035feb29a"
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
