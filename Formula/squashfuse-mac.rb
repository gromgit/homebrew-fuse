require_relative "../require/macfuse"

class SquashfuseMac < Formula
  desc "FUSE filesystem to mount squashfs archives"
  homepage "https://github.com/vasi/squashfuse"
  url "https://github.com/vasi/squashfuse/releases/download/0.6.5/squashfuse-0.6.5.tar.gz"
  sha256 "9ec44b8ee6309e09bdcdeba422edc745e876db16136acacb74ecc7e7131e5763"
  license "BSD-2-Clause"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "8a5109754aeece39710006c13d0716f2bc978f8222bff4a375cda819c37960c7"
    sha256 cellar: :any, arm64_sequoia: "1df84298e2a97d9c95c88b25fedfc85ab34848b25ff3db5d2be7a097650c3cee"
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
