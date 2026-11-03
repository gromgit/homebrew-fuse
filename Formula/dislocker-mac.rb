require_relative "../require/macfuse"

class DislockerMac < Formula
  desc "FUSE driver to read/write Windows' BitLocker-ed volumes"
  homepage "https://github.com/Aorimn/dislocker"
  url "https://github.com/Aorimn/dislocker/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "c39261727a4993af13f90beec5ce1b56932f8a6d813df26e437ed0a668cf4141"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_sonoma: "018c699c1d89ce79a16974486a39b5a23763cd4fc0063d1de9bc326a34fa5a40"
    sha256 cellar: :any, ventura:      "054aa62cbb45f561f88d200c95b308a45126320b361b5807dea5064ace6bf894"
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
