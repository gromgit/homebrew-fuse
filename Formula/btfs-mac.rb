require_relative "../require/macfuse"

class BtfsMac < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/v2.24.tar.gz"
  sha256 "d71ddefe3c572e05362542a0d9fd0240d8d4e1578ace55a8b3245176e7fd8935"
  license "GPL-3.0-only"
  head "https://github.com/johang/btfs.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/btfs-mac-2.24"
    sha256 cellar: :any, big_sur:  "d92d62980a61112eaf05240b150122226cabaaeb9e52910d06a3db5475c9cf0d"
    sha256 cellar: :any, catalina: "8820a96d3817703851cae7871711fc635a94dfc419fffeba70155f8fd09a21bf"
    sha256 cellar: :any, mojave:   "10516fbacf59d585f1f28fc5c883f77724de7b1e49c094aabb0fe5ee4c8e07e5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtorrent-rasterbar"
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    ENV.cxx11
    inreplace "configure.ac", "fuse >= 2.8.0", "fuse >= 2.7.3"
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/btfs", "--help"
  end
end
