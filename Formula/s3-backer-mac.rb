require_relative "../require/macfuse"

class S3BackerMac < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  url "https://archie-public.s3.amazonaws.com/s3backer/s3backer-2.1.5.tar.gz"
  sha256 "d834eef512fa99cedd7920586cae03729693613f67d380c1ac980564eed76c8e"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_sonoma: "7f67d78e85e19ec2447968526fddc16c9285c32f2d81eb5cdbaa2771fb2e7153"
    sha256 cellar: :any, ventura:      "51f68b3c5cba34ac4e669b9cc8b2b1f37a940fc01e3d356decb4aaf750f1e96d"
  end

  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "expat"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "openssl@3"

  def install
    setup_fuse
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"s3backer", "--version"
  end
end
