require_relative "../require/macfuse"

class BtfsMac < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/refs/tags/v3.1.tar.gz"
  sha256 "c363f04149f97baf1c5e10ac90677b8309724f2042ab045a45041cfb7b44649b"
  license "GPL-3.0-only"
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
  depends_on "openssl@3"

  # Ref: https://github.com/johang/btfs/pull/103
  # NOTE: Review for removal on next version
  patch do
    url "https://github.com/johang/btfs/commit/ff3f838a251cea45398e8780cf531ec0e3d8941f.patch?full_index=1"
    sha256 "a99fcbb4b8bb199821dd6a5f481b821fa08aa2a983fced78ed2e8f7e1aaac1c2"
  end

  def install
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
