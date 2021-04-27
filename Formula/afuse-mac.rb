require_relative "../require/macfuse"

class AfuseMac < Formula
  desc "Automounting file system implemented in userspace with FUSE"
  homepage "https://github.com/pcarrier/afuse/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/afuse/afuse-0.4.1.tar.gz"
  sha256 "c6e0555a65d42d3782e0734198bbebd22486386e29cb00047bc43c3eb726dca8"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/afuse-mac-0.4.1"
    sha256 cellar: :any, big_sur: "d14a7e51b8d3fd8c7b3419ab06011e5e14c89b6d8c8f46dbe66b80ea3c97fa1f"
  end

  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "FUSE library version", pipe_output("#{bin}/afuse --version 2>&1")
  end
end
