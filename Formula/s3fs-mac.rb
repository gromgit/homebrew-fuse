require_relative "../require/macfuse"

class S3fsMac < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/refs/tags/v1.97.tar.gz"
  sha256 "28413457cbf923b9b81e546caffabb8edd5c18f263e698ad86f564fd4b5b344d"
  license "GPL-2.0-or-later"
  head "https://github.com/s3fs-fuse/s3fs-fuse.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "d68a2a2b163e8d032b22922156bef9c54f9ce0dbe74225d54b0da0f360f29fd2"
    sha256 cellar: :any, arm64_sequoia: "0f6c30a3139b5e34803c109df921c9867f2b0cd7196980045b7582fa64c97fd2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "gcc"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libxml2"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "nettle"

  fails_with :clang do
    cause <<~EOS
      libc++abi: terminating due to uncaught exception of type std::__1::system_error:
      mutex lock failed: Invalid argument
    EOS
  end

  def install
    # s3fs >= 1.96 configure only probes the fuse-t and fuse3 pkg-config modules,
    # but its macOS code still uses the FUSE 2 API; use macFUSE's fuse module instead
    # TODO: Review for removal in next release
    inreplace "configure.ac", "[fuse3 >= ${min_fuse_version}", "[fuse >= ${min_fuse_version}"

    setup_fuse
    system "./autogen.sh"
    system "./configure", "--with-gnutls", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/s3fs", "--version"
  end
end
