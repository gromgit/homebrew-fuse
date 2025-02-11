require_relative "../require/macfuse"

class S3BackerMac < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  url "https://archie-public.s3.amazonaws.com/s3backer/s3backer-2.1.3.tar.gz"
  sha256 "b49a7cae66bc29e8104db889e7e63137748d4a3442d88ebad9fffa4705808a81"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/s3-backer-mac-2.0.2"
    sha256 cellar: :any, arm64_monterey: "2f1d3837847ac2879eaa859c40f223c2956759a72768f8d03db1df03ec72cbf4"
    sha256 cellar: :any, monterey:       "8a9f76908ee913f79aa7e32b5913f63d556510ac75cf254b9b86653dfcac05aa"
    sha256 cellar: :any, big_sur:        "1aac74d23e01950841770936f418fba4cec9f64f97ee27120908af7db9e1c185"
    sha256 cellar: :any, catalina:       "6b043afad65435edf6209a85d5e6c4c7d15752126af4656144e17d3fd7e994d8"
    sha256 cellar: :any, mojave:         "a6d732072a6b2992c3cb08adcedac1fff5472da7e7c1858c57508b84af5570c2"
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
