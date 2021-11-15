require_relative "../require/macfuse"

class DislockerMac < Formula
  desc "FUSE driver to read/write Windows' BitLocker-ed volumes"
  homepage "https://github.com/Aorimn/dislocker"
  url "https://github.com/Aorimn/dislocker/archive/v0.7.3.tar.gz"
  sha256 "8d5275577c44f2bd87f6e05dd61971a71c0e56a9cbedf000bd38deadd8b6c1e6"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/dislocker-mac-0.7.3"
    sha256 big_sur:  "964e32ec0176c6373424e843f6baa3e1fe47f383a917eb2429c33a4460486a80"
    sha256 catalina: "db46215c80f270b02c8a73a6272f0d251b534b32fad08162ed9bec482ddd93a9"
    sha256 mojave:   "92bc4d90014fc99e102e23548f43c20503bfa722ddbd8e372dd668c98d53ddd4"
  end

  depends_on "cmake" => :build
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "mbedtls@2"

  # Fix OSXFUSE-isms
  patch :DATA

  def install
    setup_fuse
    system "cmake", "-DCMAKE_DISABLE_FIND_PACKAGE_Ruby=TRUE", *fuse_cmake_args, *std_cmake_args
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
