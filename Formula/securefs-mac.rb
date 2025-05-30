require_relative "../require/macfuse"

class SecurefsMac < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "a4b0ceaaca98d25ed062bce0649bd43c83d5ea78d93d1fa4f227a2d59bfb7e62"
  license "MIT"
  head "https://github.com/netheril96/securefs.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_sonoma: "00c3dde00c48f87ece1f6df2422f4e52e7823d36079acd8a362781d9ce586df8"
    sha256 cellar: :any, ventura:      "f1620f8c63014b133d381ad4de21fd5f2e651f93607c6d66886261fd514d30b6"
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
