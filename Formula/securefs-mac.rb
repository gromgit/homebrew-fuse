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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4befffc32ea6cfd3b3a64efc297d65b10f55696477a57c47f55ea1286ca6702"
    sha256 cellar: :any,                 big_sur:        "664cf88693667af20d27239d00120ba58a4bcbf341ed051a68be21b7df0c043c"
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
