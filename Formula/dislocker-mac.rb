require_relative "../require/macfuse"

class DislockerMac < Formula
  desc "FUSE driver to read/write Windows' BitLocker-ed volumes"
  homepage "https://github.com/Aorimn/dislocker"
  url "https://github.com/Aorimn/dislocker/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "c39261727a4993af13f90beec5ce1b56932f8a6d813df26e437ed0a668cf4141"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "e7a5410f87a3420f2f7a1efbdd49b63d85ff9fd441f5e845da2c195615d6eff3"
    sha256 cellar: :any, arm64_sequoia: "f88dd69bfeaa251f0118078f3ec1a27499d42a70468390d9413cc4d5765075ca"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "openssl@4"

  def install
    args = %w[
      -DCRYPTO_BACKEND=openssl
      -DWITH_RUBY=OFF
    ]

    setup_fuse3(disable_exts: false)
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/dislocker", "-h"
  end
end
