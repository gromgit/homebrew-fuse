require_relative "../require/macfuse"

class S3BackerMac < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  url "https://archie-public.s3.amazonaws.com/s3backer/s3backer-2.1.3.tar.gz"
  sha256 "b49a7cae66bc29e8104db889e7e63137748d4a3442d88ebad9fffa4705808a81"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_sonoma: "74c3dc5284de2816f8ac93749c530cb6031a88cb862cd6b3cd815fc962d61c7f"
    sha256 cellar: :any, ventura:      "9e4cc5154864642ffaaea319c13994eab5ae558ca0278ad67f1ffc3aeaa7d95a"
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
