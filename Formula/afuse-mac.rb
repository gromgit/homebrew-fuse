require_relative "../require/macfuse"

class AfuseMac < Formula
  desc "Automounting file system implemented in userspace with FUSE"
  homepage "https://github.com/pcarrier/afuse/"
  url "https://github.com/pcarrier/afuse.git",
      tag:      "v0.5.0",
      revision: "d7f07c32e58850fa092bb98b53c5c570fed8be69"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "d0b0e74b43c27ce951eec136e4c45a98c43edc39cceeb95418f43c2d5bfa9afe"
    sha256 cellar: :any,                 ventura:      "81eac9045ff5882fa86b3e40c6562bbed06cf1346ec5fb368033511cab03c982"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "FUSE library version", pipe_output("#{bin}/afuse --version 2>&1")
  end
end
