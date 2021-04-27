require_relative "../require/macfuse"

class Avfs < Formula
  desc "Virtual file system that facilitates looking inside archives"
  homepage "https://avf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/avf/avfs/1.1.4/avfs-1.1.4.tar.bz2"
  sha256 "3a7981af8557f864ae10d4b204c29969588fdb526e117456e8efd54bf8faa12b"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/avfs-1.1.4"
    sha256 big_sur:  "330fbd827479a4f6f0e5f218a5b711f2693bbfd92f17735fd5057100205abaca"
    sha256 catalina: "bcce73a08b09330cf8814b03f5fe5836e46c823c33d07829fba0f865b7fda35e"
    sha256 mojave:   "b10aca4aedca598335f6bc8e20c349559761a485a4bdfcc2bbcd56158b663dc5"
  end

  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "openssl@1.1"
  depends_on "xz"

  def install
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
