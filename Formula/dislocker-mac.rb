require_relative "../require/macfuse"

class DislockerMac < Formula
  desc "FUSE driver to read/write Windows' BitLocker-ed volumes"
  homepage "https://github.com/Aorimn/dislocker"
  url "https://github.com/Aorimn/dislocker/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "8d5275577c44f2bd87f6e05dd61971a71c0e56a9cbedf000bd38deadd8b6c1e6"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/dislocker-mac-0.7.3"
    rebuild 1
    sha256 arm64_monterey: "911c8174a086be60b70d9a1d3caf7ca02d35830ec34d1870bf05b17d24b7321c"
    sha256 monterey:       "701af14f991f776425578a38ee054bca520f4d2310071a90031df65558e6132a"
    sha256 big_sur:        "2d972fe6fb9e2cba0674c4309805166224cdf8a752d5855eb8d52758e2378856"
    sha256 catalina:       "14cea99377a68eef03508d53550987025eab4b1d0cdf4d07e7b144f0489d7594"
    sha256 mojave:         "51573fbf958a3ceb98a57b28d1f2ab2548cbd4f51eb5ed9cec7aa0e236be39d6"
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
