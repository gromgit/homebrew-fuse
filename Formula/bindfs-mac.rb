require_relative "../require/macfuse"

class BindfsMac < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.17.2.tar.gz"
  sha256 "5f2c50a70b8d58c025b81fbf364fad432d154936630ce0023cc88baa8d5ca1d0"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/bindfs-mac-1.17.2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d026e72fe529131e8c407dcc5f927e45d5f34365fa162510f53c1224c7b0c34a"
    sha256 cellar: :any,                 monterey:       "e6f074f1acd358e9ceb96f7b0eb5c94e55ab0924f64ff81a31d196251d85857f"
    sha256 cellar: :any,                 big_sur:        "52ba09553027ce5617558a8ce025f2119f6f50f9065c7caae51d6bbc27701c3d"
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
    setup_fuse
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
