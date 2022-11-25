require_relative "../require/macfuse"

class SecurefsMac < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs.git",
      tag:      "0.13.1",
      revision: "bb7088e3fe43cd5978ec6b09b4cd9615a4ab654c"
  license "MIT"
  head "https://github.com/netheril96/securefs.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/securefs-mac-0.13.1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6c78f958cf18a829baed1cfe6a3b09e069339259b4c021fafa25cda068a9e6d"
    sha256 cellar: :any,                 monterey:       "33cf7a1a981086a428770a5a7a1ed33dcec521fc9d20531ccec2d7bdaff835a0"
    sha256 cellar: :any,                 big_sur:        "43f02b250cf103c61bca92e7132ebb90dfbbab0836bfc55f729841206addb273"
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
