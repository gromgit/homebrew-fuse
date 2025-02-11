require_relative "../require/macfuse"

class SecurefsMac < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "de888359734a05ca0db56d006b4c9774f18fd9e6f9253466a86739b5f6ac3753"
  license "MIT"
  head "https://github.com/netheril96/securefs.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/securefs-mac-0.13.1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6c78f958cf18a829baed1cfe6a3b09e069339259b4c021fafa25cda068a9e6d"
    sha256 cellar: :any,                 monterey:       "33cf7a1a981086a428770a5a7a1ed33dcec521fc9d20531ccec2d7bdaff835a0"
    sha256 cellar: :any,                 big_sur:        "43f02b250cf103c61bca92e7132ebb90dfbbab0836bfc55f729841206addb273"
    sha256 cellar: :any,                 catalina:       "b3415327bc9e130b416f74897271488df6b6d6ec75a2f5f2f5099901b4d02794"
    sha256 cellar: :any_skip_relocation, mojave:         "d1de1707eef8b902fbfb89bff3ac6475011a67b3ea60d1bd26b32e5243e687d1"
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
