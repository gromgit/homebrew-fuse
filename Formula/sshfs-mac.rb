require_relative "../require/macfuse"

class SshfsMac < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://github.com/libfuse/sshfs"
  url "https://github.com/libfuse/sshfs/archive/refs/tags/sshfs-3.7.3.tar.gz"
  sha256 "52a1a1e017859dfe72a550e6fef8ad4f8703ce312ae165f74b579fd7344e3a26"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/sshfs-mac-2.10"
    sha256 cellar: :any, arm64_monterey: "422abbbbd1804e67c27a21b976e4e82cfdffd977b5aa2cf7ee4e21fc2b548167"
    sha256 cellar: :any, monterey:       "ffbc11b371d196dd6a32c13b21dfc28af7f7577145a62a165062228c2c661263"
    sha256 cellar: :any, big_sur:        "9e021d24580ec55f4ab034dba0e264906d9db5c57036fe83710bc601bc6885c6"
    sha256 cellar: :any, catalina:       "09f254420411218a784c783df760d2c652acd280eecc875d60e41014f80011cc"
    sha256 cellar: :any, mojave:         "6389b69b921295f5be6eb35336649f558375eb24da60573b376a313331a4d18c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on MacfuseRequirement
  depends_on :macos

  patch do
    url "https://github.com/libfuse/sshfs/commit/667cf34622e2e873db776791df275c7a582d6295.patch?full_index=1"
    sha256 "ab2aa697d66457bf8a3f469e89572165b58edb0771aa1e9c2070f54071fad5f6"
  end

  patch :DATA

  def install
    setup_fuse
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      This formula is outdated, and is provided only as a courtesy.
      It cannot be updated until macFUSE supports FUSE API version 3.

      If security issues are discovered with this old software,
      it may be removed without notice.
    EOS
  end

  test do
    system "#{bin}/sshfs", "--version"
  end
end
__END__
diff --git a/configure.ac b/configure.ac
index 76026ad..671810b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -16,7 +16,6 @@ case "$target_os" in
     *) osname=unknown;;
 esac
 
-export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
 PKG_CHECK_MODULES([SSHFS], [fuse >= 2.3 glib-2.0 gthread-2.0])
 have_fuse_opt_parse=no
 oldlibs="$LIBS"
diff --git a/sshfs.c b/sshfs.c
index 97eaf06..d442577 100644
--- a/sshfs.c
+++ b/sshfs.c
@@ -14,9 +14,6 @@
 #if !defined(__CYGWIN__)
 #include <fuse_lowlevel.h>
 #endif
-#ifdef __APPLE__
-#  include <fuse_darwin.h>
-#endif
 #include <assert.h>
 #include <stdio.h>
 #include <stdlib.h>
