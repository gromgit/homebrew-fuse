require_relative "../require/macfuse"

class BtfsMac < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/refs/tags/v3.3.tar.gz"
  sha256 "9658625244a88e836bfbed53928c104907fc46bdfffb91225284ea8b6947f5a6"
  license "GPL-3.0-only"
  head "https://github.com/johang/btfs.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "1e29128ca0bf8cbaaea377aaddf272ddb52c1d864339cf0b606d24b5e401187a"
    sha256 cellar: :any, arm64_sequoia: "c8bcc41b320fef9ff849f97091996011dd338041bf069eb77a73bd444cda2147"
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
