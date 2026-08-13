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
    sha256 cellar: :any, arm64_tahoe:   "be7f26dd57547363b4656891b3e352b63536cbc622a77a74716d228d811ad26f"
    sha256 cellar: :any, arm64_sequoia: "5fb293e5ea27a539779ee808a4fffe4c613624beb395975066d7767bf692ca0f"
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
