require_relative "../require/macfuse"

class SshfsAT2 < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://github.com/libfuse/sshfs"
  url "https://github.com/libfuse/sshfs/archive/refs/tags/sshfs-2.10.tar.gz"
  sha256 "6af13acda03a4632e3deb559ecc3f35881cb92e16098049a7ba4cc502650ab18"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]

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
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/sshfs", "--version"
  end
end
__END__
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
