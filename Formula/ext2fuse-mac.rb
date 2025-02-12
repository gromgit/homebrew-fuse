require_relative "../require/macfuse"

class Ext2fuseMac < Formula
  desc "Compact implementation of ext2 file system using FUSE"
  homepage "https://sourceforge.net/projects/ext2fuse"
  url "https://downloads.sourceforge.net/project/ext2fuse/ext2fuse/0.8.1/ext2fuse-src-0.8.1.tar.gz"
  sha256 "431035797b2783216ec74b6aad5c721b4bffb75d2174967266ee49f0a3466cd9"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "1fea57a1f597f489ac0a58e6c75b4a7ea970b07f33d7c31dfe1a812a8029bf02"
    sha256 cellar: :any,                 ventura:      "8935e712ae67cb680c77a88dbf6aa6c66f4b294c67aefc557dce55c5c8bd5f41"
  end

  depends_on "gcc" => :build
  depends_on "e2fsprogs"
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    ENV.append "LIBS", "-lfuse"
    ENV.append "CFLAGS",
      "-D__FreeBSD__=10 -DENABLE_SWAPFS -I/usr/local/include/fuse "
    ENV.append "CFLAGS", "--std=gnu89" if ENV.compiler == :clang

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ext2fuse --version 2>&1", 9)
  end
end
