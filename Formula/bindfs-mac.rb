require_relative "../require/macfuse"

class BindfsMac < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.15.1.tar.gz"
  sha256 "04dd3584a6cdf9af4344d403c62185ca9fab31ce3ae5a25d0101bc10936c68ab"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/bindfs-mac-1.15.1"
    sha256 cellar: :any, big_sur:  "edb43ff7dd67f03169b9e4c84b527a2ec729c743baeff1e47319008722fccb15"
    sha256 cellar: :any, catalina: "eaabdbc55f58e3782705dbf4a1be9862f741939630bbd6d82e27915309995a2c"
  end

  head do
    url "https://github.com/mpartel/bindfs.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system "#{bin}/bindfs", "-V"
  end
end
