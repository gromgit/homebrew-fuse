require_relative "../require/macfuse"

class TupMac < Formula
  desc "File-based build system"
  homepage "http://gittup.org/tup/"
  url "https://github.com/gittup/tup/archive/v0.7.11.tar.gz"
  sha256 "be24dff5f1f32cc85c73398487a756b4a393adab5e4d8500fd5164909d3e85b9"
  license "GPL-2.0-only"
  head "https://github.com/gittup/tup.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/tup-mac-0.7.11"
    sha256 cellar: :any, monterey: "c0fa166568e8f24a6a77de27ec30f201d65ae812b1b595fd0cbea44647aa69e4"
    sha256 cellar: :any, big_sur:  "e1d223dcd5865119de5a2b9570ef28ec780909d709db49f53c3fe7229aa68e5a"
    sha256 cellar: :any, catalina: "ce44cb9e6ca8c79e35a2cc4e2dfd7c39460bb2575510ac3ee966b6b7d6642679"
    sha256 cellar: :any, mojave:   "03d842d15270c158614812b9355bb91252994f4b2b7b0a2a308b336b312784f8"
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
