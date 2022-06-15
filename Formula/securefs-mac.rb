require_relative "../require/macfuse"

class SecurefsMac < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs.git",
      tag:      "0.13.0",
      revision: "1705d14b8fef5ebb826a74549d609c6ab6cb63f7"
  license "MIT"
  head "https://github.com/netheril96/securefs.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/securefs-mac-0.13.0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8fc0484d4e992eaa090ae75b91d6a3cc19ed21d32d31aebd158385505de3011"
    sha256 cellar: :any,                 monterey:       "33933601d2dd7e914fdb0d33fa389372c0cb005c9508b3e8f96f1349dbe10f16"
    sha256 cellar: :any,                 big_sur:        "70db42eeea99f3ba3f2cc630e54d889160557a578c288fab05c3a4a16f6313b1"
    sha256 cellar: :any,                 catalina:       "492fb88bdcc12fb16397429ccdba0992cb7623f530fbb888f4b07e1289c9e92c"
    sha256 cellar: :any,                 mojave:         "250e40c532c038f514ffba5a0064e6a787ba025aa84f35f86b32d560c09542af"
  end

  depends_on "cmake" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    system "cmake", ".", *fuse_cmake_args, *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/securefs", "version" # The sandbox prevents a more thorough test
  end
end
