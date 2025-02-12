require_relative "../require/macfuse"

class SimpleMtpfsMac < Formula
  desc "Simple MTP fuse filesystem driver"
  homepage "https://github.com/phatina/simple-mtpfs"
  url "https://github.com/phatina/simple-mtpfs/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "1d011df3fa09ad0a5c09d48d84c03e6cddf86390af9eb4e0c178193f32f0e2fc"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    rebuild 1
    sha256 cellar: :any, arm64_sonoma: "cf831fa0da5d53fbef60c754223bb2ed7601c80e89d7bb11be4bd349001b2f1e"
    sha256 cellar: :any, ventura:      "01adbaed0737e09f73ec91d8e248a1a9c138e06f8476cd6da23e6b511f3c68d9"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build # required for AX_CXX_COMPILE_STDCXX_17
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "libmtp"
  depends_on "libusb"
  depends_on MacfuseRequirement
  depends_on :macos

  patch :DATA

  def install
    setup_fuse
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
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
