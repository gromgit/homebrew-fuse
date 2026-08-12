require_relative "../require/macfuse"

class BtfsMac < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/refs/tags/v3.2.tar.gz"
  sha256 "f41094e7433b36708bd79e4e2a9431731cbd203c0615aa28a1ac71058126dba1"
  license "GPL-3.0-only"
  head "https://github.com/johang/btfs.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "021167a0902e835d03557e380024972963250dddb206e7526444d4a4b7ec7613"
    sha256 cellar: :any, arm64_sequoia: "b550452e5337b01dc98bab60cb2ba163fcab33e2dde77fefb03a15b20cb4505b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "libtorrent-rasterbar"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "openssl@3"

  def install
    ENV.append "CXXFLAGS", "-std=c++17"
    setup_fuse3
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Mounting a torrent is fairly quick, but unmounting takes a long time.
      Be patient.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/btfs --version 2>&1")
  end
end
