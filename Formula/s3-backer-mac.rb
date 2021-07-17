require_relative "../require/macfuse"

class S3BackerMac < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  url "https://archie-public.s3.amazonaws.com/s3backer/s3backer-1.6.2.tar.gz"
  sha256 "9e5da54aeafa9c758e80b2a934fc9704c678936c41b2dcc301fad2e548f48383"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/s3-backer-mac-1.6.2"
    sha256 cellar: :any, big_sur:  "6181d14d9d43798f02f969c94649248f932cb5e85ae68c74cc3fe0423060590d"
    sha256 cellar: :any, catalina: "5fb327e2d096cf9b57179dff8b44666deff2c814f032cad2451ac20c6461052f"
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
