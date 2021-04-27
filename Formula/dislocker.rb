require_relative "../require/macfuse"

class Dislocker < Formula
  desc "FUSE driver to read/write Windows' BitLocker-ed volumes"
  homepage "https://github.com/Aorimn/dislocker"
  url "https://github.com/Aorimn/dislocker/archive/v0.7.3.tar.gz"
  sha256 "8d5275577c44f2bd87f6e05dd61971a71c0e56a9cbedf000bd38deadd8b6c1e6"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/dislocker-0.7.3"
    sha256 big_sur:  "ad648b9de0d695bb5aa316a2a68110f5d9181f050f1efe49d4f0df4bfc531eb1"
    sha256 catalina: "a3dbcd27de799127c8046037cd8c287de5d3fd1c69f4f27966566eb6bb329782"
    sha256 mojave:   "bde6ccac5ddd2d8c4686df516c0d5145d27ecc8e4d4a63eef51b7f9b4d8941ae"
  end

  depends_on "cmake" => :build
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "mbedtls"

  # Fix OSXFUSE-isms
  patch :DATA

  def install
    system "cmake", "-DCMAKE_DISABLE_FIND_PACKAGE_Ruby=TRUE", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dislocker", "-h"
  end
end
__END__
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index bd854d2..9ab137d 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -92,7 +92,7 @@ if("${CMAKE_SYSTEM_NAME}" STREQUAL "Darwin")
 	# Don't use `-read_only_relocs' here as it seems to only work for 32 bits
 	# binaries
 	set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-bind_at_load")
-	set (FUSE_LIB osxfuse_i64)
+	set (FUSE_LIB fuse)
 else()
 	# Useless warnings when used within Darwin
 	set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wconversion")
diff --git a/src/dislocker-fuse.c b/src/dislocker-fuse.c
index f93523f..3dd106c 100644
--- a/src/dislocker-fuse.c
+++ b/src/dislocker-fuse.c
@@ -33,11 +33,7 @@
 
 
 
-#ifdef __DARWIN
-# include <osxfuse/fuse.h>
-#else
-# include <fuse.h>
-#endif /* __DARWIN */
+#include <fuse.h>
 
 
 /** NTFS virtual partition's name */
