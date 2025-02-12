require_relative "../require/macfuse"

class BtfsMac < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/refs/tags/v2.24.tar.gz"
  sha256 "d71ddefe3c572e05362542a0d9fd0240d8d4e1578ace55a8b3245176e7fd8935"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/johang/btfs.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_sonoma: "71e05be0beb418720d313a63f10cfea741d648bf78630b497eb2c51a5003d319"
    sha256 cellar: :any, ventura:      "388cc358e3c9372768469b6b1021f43d8def07f372aaef6e3f5d2d80bc93be48"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "libtorrent-rasterbar"
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
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
