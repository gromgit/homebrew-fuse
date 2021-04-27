require_relative "../require/macfuse"

class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.15.1.tar.gz"
  sha256 "04dd3584a6cdf9af4344d403c62185ca9fab31ce3ae5a25d0101bc10936c68ab"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/bindfs-1.15.1"
    sha256 cellar: :any, big_sur: "f940f18270f1319c5f27c755538949c87a3d282ab0cf2c7397067c3df67c6306"
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
