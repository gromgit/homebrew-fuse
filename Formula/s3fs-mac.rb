require_relative "../require/macfuse"

class S3fsMac < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.92.tar.gz"
  sha256 "76ebea3c0784c5c0f6b84e009d555806aff86258886ced39eee316bf02ae8750"
  license "GPL-2.0-or-later"
  head "https://github.com/s3fs-fuse/s3fs-fuse.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/s3fs-mac-1.92"
    sha256 cellar: :any, arm64_monterey: "25ec0f6ef2007436aacb9d10f0aabde8682e2fc8401eeb2588c5d926f49d8d9a"
    sha256 cellar: :any, big_sur:        "4ec4d56e890e2ec95c5fbba9720dd7a319d9919e56aa01fc67166c8a093e0aef"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "nettle"

  def install
    setup_fuse
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--with-gnutls", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/s3fs", "--version"
  end
end
