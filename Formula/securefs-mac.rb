require_relative "../require/macfuse"

class SecurefsMac < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs.git",
      tag:      "0.12.0",
      revision: "a4972834d93e89117e67dae58998f10f8a7c0fbb"
  license "MIT"
  head "https://github.com/netheril96/securefs.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/securefs-mac-0.12.0"
    sha256 cellar: :any, big_sur:  "70db42eeea99f3ba3f2cc630e54d889160557a578c288fab05c3a4a16f6313b1"
    sha256 cellar: :any, catalina: "492fb88bdcc12fb16397429ccdba0992cb7623f530fbb888f4b07e1289c9e92c"
    sha256 cellar: :any, mojave:   "250e40c532c038f514ffba5a0064e6a787ba025aa84f35f86b32d560c09542af"
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
