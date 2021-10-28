require_relative "../require/macfuse"

class S3BackerMac < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  url "https://archie-public.s3.amazonaws.com/s3backer/s3backer-1.6.3.tar.gz"
  sha256 "f2d992b6390c9a7569525fbf973edb8f767ed4d59c7b87ca9e3d38f87992e132"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-homebrew-fuse/releases/download/s3-backer-mac-1.6.3"
    sha256 cellar: :any, big_sur: "f0e8f148942af0efd873e81d62b87784e7e050266835442b2b387d61ed9a532e"
  end

  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "openssl@1.1"

  def install
    setup_fuse
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"s3backer", "--version"
  end
end
