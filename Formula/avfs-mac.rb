require_relative "../require/macfuse"

class AvfsMac < Formula
  desc "Virtual file system that facilitates looking inside archives"
  homepage "https://avf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/avf/avfs/1.4.0/avfs-1.4.0.tar.bz2"
  sha256 "d4dcdaf5afd7ba146334b6d003600340011c97307d84229ece09fe684448f98e"
  license all_of: [
    "GPL-2.0-only",
    "LGPL-2.0-only", # for shared library
    "GPL-2.0-or-later", # modules/dav_ls.c
    "Zlib", # zlib/*
  ]

  livecheck do
    url :stable
    regex(%r{url=.*?/avfs[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 arm64_tahoe:   "d4a54df88c0f76595d4a236bbf6c1502ad29d7d0a57bedee6f81d3d3a71dc84a"
    sha256 arm64_sequoia: "741a6195fe496ffd6c53eff60f6f01071c139cf9bce34e2722959bc9e0884513"
  end

  depends_on "pkgconf" => :build
  depends_on "bzip2"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "xz"
  depends_on "zlib-ng-compat"

  on_macos do
    # rename timespec fields on macOS
    patch :DATA
  end

  def install
    setup_fuse
    system "./configure", "--disable-silent-rules",
                          "--enable-fuse",
                          "--enable-library",
                          "--with-system-zlib",
                          "--with-system-bzlib",
                          "--with-xz",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "AVFS specific options", shell_output("#{bin}/avfsd --help 2>&1", 1)
  end
end
__END__
diff --git a/src/local.c b/src/local.c
index 451d591..7a4a42b 100644
--- a/src/local.c
+++ b/src/local.c
@@ -205,12 +205,12 @@ static void stat_to_avstat(struct avstat *vbuf, struct stat *lbuf)
     vbuf->blksize    = lbuf->st_blksize;
     vbuf->blocks     = lbuf->st_blocks;
 #if _POSIX_C_SOURCE >= 200809L
-    vbuf->atime.sec  = lbuf->st_atim.tv_sec;
-    vbuf->atime.nsec = lbuf->st_atim.tv_nsec;
-    vbuf->mtime.sec  = lbuf->st_mtim.tv_sec;
-    vbuf->mtime.nsec = lbuf->st_mtim.tv_nsec;
-    vbuf->ctime.sec  = lbuf->st_ctim.tv_sec;
-    vbuf->ctime.nsec = lbuf->st_ctim.tv_nsec;
+    vbuf->atime.sec  = lbuf->st_atimespec.tv_sec;
+    vbuf->atime.nsec = lbuf->st_atimespec.tv_nsec;
+    vbuf->mtime.sec  = lbuf->st_mtimespec.tv_sec;
+    vbuf->mtime.nsec = lbuf->st_mtimespec.tv_nsec;
+    vbuf->ctime.sec  = lbuf->st_ctimespec.tv_sec;
+    vbuf->ctime.nsec = lbuf->st_ctimespec.tv_nsec;
 #else
     vbuf->atime.sec  = lbuf->st_atime;
     vbuf->atime.nsec = 0;
diff --git a/src/virtual.c b/src/virtual.c
index 05d367d..d8c3d3a 100644
--- a/src/virtual.c
+++ b/src/virtual.c
@@ -128,12 +128,12 @@ static void avstat_to_stat(struct stat *buf, struct avstat *avbuf)
     buf->st_blksize = avbuf->blksize;
     buf->st_blocks  = avbuf->blocks;
 #if _POSIX_C_SOURCE >= 200809L
-    buf->st_atim.tv_sec  = avbuf->atime.sec;
-    buf->st_atim.tv_nsec = avbuf->atime.nsec;
-    buf->st_mtim.tv_sec  = avbuf->mtime.sec;
-    buf->st_mtim.tv_nsec = avbuf->mtime.nsec;
-    buf->st_ctim.tv_sec  = avbuf->ctime.sec;
-    buf->st_ctim.tv_nsec = avbuf->ctime.nsec;
+    buf->st_atimespec.tv_sec  = avbuf->atime.sec;
+    buf->st_atimespec.tv_nsec = avbuf->atime.nsec;
+    buf->st_mtimespec.tv_sec  = avbuf->mtime.sec;
+    buf->st_mtimespec.tv_nsec = avbuf->mtime.nsec;
+    buf->st_ctimespec.tv_sec  = avbuf->ctime.sec;
+    buf->st_ctimespec.tv_nsec = avbuf->ctime.nsec;
 #else
     buf->st_atime   = avbuf->atime.sec;
     buf->st_mtime   = avbuf->mtime.sec;
diff --git a/test/test_stat.c b/test/test_stat.c
index 24f222e..5a45575 100644
--- a/test/test_stat.c
+++ b/test/test_stat.c
@@ -35,12 +35,12 @@ int main( int argc, char **argv )
     struct stat buf;
 
     if (virt_stat(argv[2], &buf) == 0) {
-        printf("  atime sec: %lu\n", buf.st_atim.tv_sec);
-        printf("  atime nsec: %lu\n", buf.st_atim.tv_nsec);
-        printf("  mtime sec: %lu\n", buf.st_mtim.tv_sec);
-        printf("  mtime nsec: %lu\n", buf.st_mtim.tv_nsec);
-        printf("  ctime sec: %lu\n", buf.st_ctim.tv_sec);
-        printf("  ctime nsec: %lu\n", buf.st_ctim.tv_nsec);
+        printf("  atime sec: %lu\n", buf.st_atimespec.tv_sec);
+        printf("  atime nsec: %lu\n", buf.st_atimespec.tv_nsec);
+        printf("  mtime sec: %lu\n", buf.st_mtimespec.tv_sec);
+        printf("  mtime nsec: %lu\n", buf.st_mtimespec.tv_nsec);
+        printf("  ctime sec: %lu\n", buf.st_ctimespec.tv_sec);
+        printf("  ctime nsec: %lu\n", buf.st_ctimespec.tv_nsec);
     } else {
         printf( "Could not get stats for %s (%s)\n", argv[2], strerror( errno ) );
     }

