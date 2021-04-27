require_relative "../require/macfuse"

class Ext4fuse < Formula
  desc "Read-only implementation of ext4 for FUSE"
  homepage "https://github.com/gerard/ext4fuse"
  url "https://github.com/gerard/ext4fuse/archive/v0.1.3.tar.gz"
  sha256 "550f1e152c4de7d4ea517ee1c708f57bfebb0856281c508511419db45aa3ca9f"
  license "GPL-2.0-only"
  head "https://github.com/gerard/ext4fuse.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/ext4fuse-0.1.3"
    sha256 cellar: :any, big_sur:  "e29a46d11968d75fd09e06ff1d0c1be7bf63f11e56ed3c4eacbfb223f0ad5d5d"
    sha256 cellar: :any, catalina: "37c3b8fe51092e5b7053b1f12313b57baf7ba6afbc0c5069cad41bc834127dd9"
    sha256 cellar: :any, mojave:   "3c4c0f771fb91a2c229dfd2f475e6fe1cc575a3c511893fc267d5ae8bb1df9a7"
  end

  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    system "make"
    bin.install "ext4fuse"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ext4fuse --version 2>&1", 1)
  end
end
