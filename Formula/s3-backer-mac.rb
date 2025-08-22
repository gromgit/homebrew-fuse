require_relative "../require/macfuse"

class S3BackerMac < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  url "https://archie-public.s3.amazonaws.com/s3backer/s3backer-2.1.6.tar.gz"
  sha256 "55ff3123ab08d45822e6b349d9e305ca2ca13339474314cfc31a074d5308acf6"
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
  depends_on "zlib"
  depends_on "zstd"

  def install
    setup_fuse3
    # Disable macOS-specific features that break FUSE compatibility
    # https://github.com/macfuse/macfuse/issues/1064#issuecomment-2800022794
    ENV.append "CFLAGS", "-DFUSE_DARWIN_ENABLE_EXTENSIONS=0"
    system "./configure", "--disable-silent-rules",
            *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/s3backer --version 2>&1")

    assert_match "no S3 bucket specified", shell_output("#{bin}/s3backer 2>&1", 1)
  end
end
