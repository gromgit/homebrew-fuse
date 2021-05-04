require_relative "../require/macfuse"

class S3BackerMac < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  url "https://archie-public.s3.amazonaws.com/s3backer/s3backer-1.6.1.tar.gz"
  sha256 "ec91b1c2ec2eadd945e1745fdeccc49baeb357a4040fd9ea8605a9bcdc96c29f"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/s3-backer-mac-1.6.1"
    sha256 cellar: :any, big_sur:  "7fd2974f3287fbed90f2d2cabd83c07b4fc6a832ac774fe10dcc57a5466d428b"
    sha256 cellar: :any, catalina: "4efa010416a73885fa3e9727d59180f83cb90ffbd6844feda2aaa04e32db1421"
  end

  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"s3backer", "--version"
  end
end
