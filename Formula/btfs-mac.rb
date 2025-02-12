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
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/btfs-mac-2.24"
    sha256 cellar: :any, arm64_monterey: "725bfa8256133728271bd4c586ae03d2ed1922575ecf3ff4305a80becaaf8a06"
    sha256 cellar: :any, monterey:       "443e68c98b9a5861e90993b1afc2552804cb688082b399700ff6326d3f9fc08e"
    sha256 cellar: :any, big_sur:        "d92d62980a61112eaf05240b150122226cabaaeb9e52910d06a3db5475c9cf0d"
    sha256 cellar: :any, catalina:       "8820a96d3817703851cae7871711fc635a94dfc419fffeba70155f8fd09a21bf"
    sha256 cellar: :any, mojave:         "10516fbacf59d585f1f28fc5c883f77724de7b1e49c094aabb0fe5ee4c8e07e5"
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
