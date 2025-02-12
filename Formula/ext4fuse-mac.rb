require_relative "../require/macfuse"

class Ext4fuseMac < Formula
  desc "Read-only implementation of ext4 for FUSE"
  homepage "https://github.com/gerard/ext4fuse"
  url "https://github.com/gerard/ext4fuse/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "550f1e152c4de7d4ea517ee1c708f57bfebb0856281c508511419db45aa3ca9f"
  license "GPL-2.0-only"
  head "https://github.com/gerard/ext4fuse.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/ext4fuse-mac-0.1.3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebf7eb8b1131e195e1cf0a73b7485bcd687a57c05f34efaea564f41e12bbd4ec"
    sha256 cellar: :any,                 monterey:       "042a1154d62ef7779b9ddb5f21b4b4d04d388119b064d57a0d6cf8829d687a9e"
    sha256 cellar: :any,                 big_sur:        "9105318c87415a8c9466580b92c4e370abffaab1addb33712fd9d6ff78ed4824"
    sha256 cellar: :any,                 catalina:       "10cb5934f23ce95bd49b76c371c919638dcd2896967718fc3950434d0538f6e8"
    sha256 cellar: :any,                 mojave:         "ddda15d4eac7e188e0fae145301c25acba30e0dbaa774332257a2966c2653524"
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
