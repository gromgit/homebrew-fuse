require_relative "../require/macfuse"

class SimpleMtpfsMac < Formula
  desc "Simple MTP fuse filesystem driver"
  homepage "https://github.com/phatina/simple-mtpfs"
  url "https://github.com/phatina/simple-mtpfs/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "1d011df3fa09ad0a5c09d48d84c03e6cddf86390af9eb4e0c178193f32f0e2fc"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/simple-mtpfs-mac-0.4.0"
    sha256 cellar: :any, arm64_monterey: "3d5479cfca4348b32a0dc38097e803e817865488efe44de1e91cbcc1e39bef0f"
    sha256 cellar: :any, monterey:       "dab8ca53f1513d943c8102be2d592adf42d36f6d62d65fdd0af5914e7786c530"
    sha256 cellar: :any, big_sur:        "ab2daeee7f6e6c6bd9795f34b7d1746b3e9add149e4a33e88db29be02de20541"
    sha256 cellar: :any, catalina:       "6a07721c8bbd594f8ceeaf3a2503e780d3eb6ce3c4431ca785c40c8c71e8900c"
    sha256 cellar: :any, mojave:         "bbe032821fb0ea78e661a16fd79a185d969e8b2a602fd990c8ceb035cc7fee84"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build # required for AX_CXX_COMPILE_STDCXX_17
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmtp"
  depends_on MacfuseRequirement
  depends_on :macos

  patch :DATA

  def install
    setup_fuse
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"simple-mtpfs", "-h"
  end
end
__END__
diff --git a/configure.ac b/configure.ac
index 321cfec..a5e9294 100644
--- a/configure.ac
+++ b/configure.ac
@@ -25,8 +25,8 @@ test "x$os_name" == "xDarwin" || AC_CHECK_FUNCS([fdatasync])
 
 PKG_CHECK_MODULES([FUSE], [fuse >= 2.7.3])
 if test "x$os_name" == "xDarwin"; then
-    AC_SUBST([FUSE_CFLAGS],["-D_FILE_OFFSET_BITS=64 -D_DARWIN_USE_64_BIT_INODE -I/usr/local/include/osxfuse"])
-    AC_SUBST([FUSE_LIBS],["-L/usr/local/lib -losxfuse -pthread -liconv"])
+    AC_SUBST([FUSE_CFLAGS],["-D_FILE_OFFSET_BITS=64 -D_DARWIN_USE_64_BIT_INODE -I/usr/local/include/fuse"])
+    AC_SUBST([FUSE_LIBS],["-L/usr/local/lib -lfuse -pthread -liconv"])
 fi
 
 PKG_CHECK_MODULES(
