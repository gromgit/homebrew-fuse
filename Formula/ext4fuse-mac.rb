require_relative "../require/macfuse"

class Ext4fuseMac < Formula
  desc "Read-only implementation of ext4 for FUSE"
  homepage "https://github.com/gerard/ext4fuse"
  url "https://github.com/gerard/ext4fuse/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "550f1e152c4de7d4ea517ee1c708f57bfebb0856281c508511419db45aa3ca9f"
  license "GPL-2.0-only"
  head "https://github.com/gerard/ext4fuse.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "293d9d09f9a4d2cfb51beb789c8b2581b4419b00daa68507f3bf6c97f258aff5"
    sha256 cellar: :any,                 ventura:      "4c4f3b18a0cd8b290e52d1290ea63a87c04597f43d9c1cde6e71c487bd4a4505"
  end

  depends_on "pkgconf" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    system "make"
    bin.install "ext4fuse"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ext4fuse --version 2>&1", 1)
  end
end
