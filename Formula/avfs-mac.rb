require_relative "../require/macfuse"

class AvfsMac < Formula
  desc "Virtual file system that facilitates looking inside archives"
  homepage "https://avf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/avf/avfs/1.1.4/avfs-1.1.4.tar.bz2"
  sha256 "3a7981af8557f864ae10d4b204c29969588fdb526e117456e8efd54bf8faa12b"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/avfs-mac-1.1.4"
    sha256 monterey: "73ab1cbd3df13518d52387613e24f0550e5a39c4d49f7ab58b20e4006ca5058f"
    sha256 big_sur:  "536a8ff3129d4ca73bafa08d059ecaa057dec2a24b0c4509762e8f62ad1117ca"
    sha256 catalina: "edfe514eaacc649484b26a67f37a2c8aa38d4bf7cff97ff06477417df4396701"
    sha256 mojave:   "eb4171d8c40b058d72fb0cbf480c21c0a89b201498fcc37d2dfd4c050219aacd"
  end

  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "openssl@1.1"
  depends_on "xz"

  def install
    setup_fuse
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-fuse
      --enable-library
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"avfsd", "--version"
  end
end
