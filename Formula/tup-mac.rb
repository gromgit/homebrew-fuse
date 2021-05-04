require_relative "../require/macfuse"

class TupMac < Formula
  desc "File-based build system"
  homepage "http://gittup.org/tup/"
  url "https://github.com/gittup/tup/archive/v0.7.10.tar.gz"
  sha256 "c80946bc772ae4a5170855e907c866dae5040620e81ee1a590223bdbdf65f0f8"
  license "GPL-2.0-only"
  head "https://github.com/gittup/tup.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/tup-mac-0.7.10"
    sha256 cellar: :any, big_sur:  "b53eb5dc159f063f9fc2e744c866b7582acd3baafa9a8bee7f0df7cb22ab91c8"
    sha256 cellar: :any, catalina: "d9d25e760b8b9b29cb73bdb1e573a383a3a5a8698e9437f272b66108103bc7de"
    sha256 cellar: :any, mojave:   "86f1ea5505469a269a5aabba0f4138451652e1fb9b36544b9e9a818770bf2f56"
  end

  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
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
