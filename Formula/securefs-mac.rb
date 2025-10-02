require_relative "../require/macfuse"

class SecurefsMac < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "d7fac7adc70c09473173aeadee5b7041d7e63fbf392ef40bdd77888590bb12a2"
  license "MIT"
  head "https://github.com/netheril96/securefs.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_sequoia: "78b2a05c1291ba2828512745ac2b959786288389e44fe44dc0d4cda2a6bd68cc"
    sha256 cellar: :any, arm64_sonoma:  "54efe58e868a530d252e05beb72537171bd1f4559c16f876d92c31394a89ffb4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "tclap" => :build
  depends_on "abseil"
  depends_on "argon2"
  depends_on "cryptopp"
  depends_on "fruit"
  depends_on "jsoncpp"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "protobuf"
  depends_on "sqlite"
  depends_on "uni-algo"
  depends_on "utf8proc"

  def install
    setup_fuse
    args = %w[
      -DSECUREFS_ENABLE_INTEGRATION_TEST=OFF
      -DSECUREFS_ENABLE_UNIT_TEST=OFF
      -DSECUREFS_USE_VCPKG=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"securefs", "version" # The sandbox prevents a more thorough test
  end
end
