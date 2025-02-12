require_relative "../require/macfuse"

class DislockerMac < Formula
  desc "FUSE driver to read/write Windows' BitLocker-ed volumes"
  homepage "https://github.com/Aorimn/dislocker"
  url "https://github.com/Aorimn/dislocker/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "8d5275577c44f2bd87f6e05dd61971a71c0e56a9cbedf000bd38deadd8b6c1e6"
  license "GPL-2.0-only"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_sonoma: "018c699c1d89ce79a16974486a39b5a23763cd4fc0063d1de9bc326a34fa5a40"
    sha256 cellar: :any, ventura:      "054aa62cbb45f561f88d200c95b308a45126320b361b5807dea5064ace6bf894"
  end

  depends_on "cmake" => :build
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "mbedtls"

  # Backport support for mbedtls 3.x
  patch do
    url "https://github.com/Aorimn/dislocker/commit/2cfbba2c8cc07e529622ba134d0a6982815d2b30.patch?full_index=1"
    sha256 "07e0e3cac520a04a478f1f08d612340fc2743fd492b0835c7fb41cfdb5ef4244"
  end

  # Fix OSXFUSE-isms
  patch :DATA

  def install
    setup_fuse
    system "cmake", "-S", ".", "-B", "build",
           "-DCMAKE_DISABLE_FIND_PACKAGE_Ruby=TRUE",
           *fuse_cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
