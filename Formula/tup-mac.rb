require_relative "../require/macfuse"

class TupMac < Formula
  desc "File-based build system"
  homepage "http://gittup.org/tup/"
  url "https://github.com/gittup/tup/archive/refs/tags/v0.8.tar.gz"
  sha256 "45ca35c4c1d140f3faaab7fabf9d68fd9c21074af2af9a720cff4b27cab47d07"
  license "GPL-2.0-only"
  head "https://github.com/gittup/tup.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/tup-mac-0.7.11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "080770170cafca605d4f04b26e32ea8af093df86a6461fee483073f404de62aa"
    sha256 cellar: :any,                 monterey:       "c0fa166568e8f24a6a77de27ec30f201d65ae812b1b595fd0cbea44647aa69e4"
    sha256 cellar: :any,                 big_sur:        "e1d223dcd5865119de5a2b9570ef28ec780909d709db49f53c3fe7229aa68e5a"
    sha256 cellar: :any,                 catalina:       "ce44cb9e6ca8c79e35a2cc4e2dfd7c39460bb2575510ac3ee966b6b7d6642679"
    sha256 cellar: :any,                 mojave:         "03d842d15270c158614812b9355bb91252994f4b2b7b0a2a308b336b312784f8"
  end

  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    ENV["TUP_LABEL"] = version
    system "./build.sh"
    bin.install "build/tup"
    man1.install "tup.1"
    doc.install (buildpath/"docs").children
    pkgshare.install "contrib/syntax"
  end

  test do
    system "#{bin}/tup", "-v"
  end
end
