require_relative "../require/macfuse"

class S3fsMac < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/refs/tags/v1.95.tar.gz"
  sha256 "0c97b8922f005500d36f72aee29a1345c94191f61d795e2a7b79fb7e3e6f5517"
  license "GPL-2.0-or-later"
  head "https://github.com/s3fs-fuse/s3fs-fuse.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/s3fs-mac-1.92"
    sha256 cellar: :any, arm64_monterey: "25ec0f6ef2007436aacb9d10f0aabde8682e2fc8401eeb2588c5d926f49d8d9a"
    sha256 cellar: :any, monterey:       "47412ac05763761d837732468a813229a78f884912090608a5223ec65092e1cc"
    sha256 cellar: :any, big_sur:        "4ec4d56e890e2ec95c5fbba9720dd7a319d9919e56aa01fc67166c8a093e0aef"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libxml2"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "nettle"

  def install
    setup_fuse
    system "./autogen.sh"
    system "./configure", "--with-gnutls", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/s3fs", "--version"
  end
end
