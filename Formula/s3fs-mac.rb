require_relative "../require/macfuse"

class S3fsMac < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/refs/tags/v1.96.tar.gz"
  sha256 "e11a051f23701445ca99ff0bfbc4e49d8b87c66cdd04a68a1802c2613ba9e3f1"
  license "GPL-2.0-or-later"
  head "https://github.com/s3fs-fuse/s3fs-fuse.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_sonoma: "ecbfca73778ed850eeef256fcba17bb229036f9fbce767fd54abc2335236efee"
    sha256 cellar: :any, ventura:      "0fb739e8007836e833c79d45159c78fbd05291b19afc9439683d2712d1b1dd68"
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
    setup_fuse
    system "./autogen.sh"
    system "./configure", "--with-gnutls", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/s3fs", "--version"
  end
end
