require_relative "../require/macfuse"

class S3fsMac < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.89.tar.gz"
  sha256 "2bb9c8cad855df5a877440edac9539bd405850d2a3c366cebd9d1fec6f802e29"
  license "GPL-2.0-or-later"
  head "https://github.com/s3fs-fuse/s3fs-fuse.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/s3fs-mac-1.89"
    sha256 cellar: :any, big_sur:  "58bf4c03848d57791f3ba33c82a04c0b0cd45aeb08ba744cff39322ee10707cc"
    sha256 cellar: :any, catalina: "8d742b27f566d7dbc7ea146510a0e4fba3c31f27192dd8fc149d24f1c05f9873"
    sha256 cellar: :any, mojave:   "4cb700a39849dc1427cee981e6da68b5a0486c3d2c0ef8266c7904d6f953ec9f"
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
