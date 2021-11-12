require_relative "../require/macfuse"

class S3fsMac < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.90.tar.gz"
  sha256 "75fad9560174e041b273bf510d0d6e8d926508eba2b1ffaec9e2a652b3e8afaa"
  license "GPL-2.0-or-later"
  head "https://github.com/s3fs-fuse/s3fs-fuse.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/s3fs-mac-1.90"
    sha256 cellar: :any, monterey: "5c13fb86a0655d2dd2ca87ad26e37f84c1a4713eb7a1e9543cba6d0cf60085a1"
    sha256 cellar: :any, big_sur:  "dcf5910b3393e0b247436369bfb785a06093fb19a04431f1101a03d012cdc8e1"
    sha256 cellar: :any, catalina: "9f7fbe004cba4fae0f9e6ef413c2b8afe8d300419b1f64ecf698539263eb04b3"
    sha256 cellar: :any, mojave:   "23290f4a76d3273ae6650acc24964c121b889b24845ed9f48b2382eb1c01cb3a"
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
