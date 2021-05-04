require_relative "../require/macfuse"

class Ext2fuseMac < Formula
  desc "Compact implementation of ext2 file system using FUSE"
  homepage "https://sourceforge.net/projects/ext2fuse"
  url "https://downloads.sourceforge.net/project/ext2fuse/ext2fuse/0.8.1/ext2fuse-src-0.8.1.tar.gz"
  sha256 "431035797b2783216ec74b6aad5c721b4bffb75d2174967266ee49f0a3466cd9"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/ext2fuse-mac-0.8.1"
    sha256 cellar: :any, big_sur:  "8dba44571e8df43bac8356f7fe74719200f965318e9075fdc717e863dbf8aad7"
    sha256 cellar: :any, catalina: "0b24132b10c92b0f9ca6bde9c72caa54281e812c07f1f491034fe71e305eba67"
    sha256 cellar: :any, mojave:   "e46c5e7eff79716a8e075752e429bea3e9027b6516538df45fbbdc98ba878b94"
  end

  depends_on "gcc" => :build
  depends_on "e2fsprogs"
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    ENV.append "LIBS", "-lfuse"
    ENV.append "CFLAGS",
      "-D__FreeBSD__=10 -DENABLE_SWAPFS -I/usr/local/include/fuse "
    ENV.append "CFLAGS", "--std=gnu89" if ENV.compiler == :clang

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ext2fuse --version 2>&1", 9)
  end
end
