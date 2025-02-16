require_relative "../require/macfuse"

class XmountMac < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.sits.lu/xmount"
  url "https://code.sits.lu/foss/xmount/-/archive/1.2.0/xmount-1.2.0.tar.gz"
  sha256 "abded7b53646c5d56ab9caf30473d75d0deb543e8262cadf2af572da3e1d127d"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 arm64_sonoma: "1d67ae2174104c69471b892aceaface732e0853c15c039c260ef78c1f493eea9"
    sha256 ventura:      "aa2caa902402f9aa415b5bf570c046f5dcf7129621b7a514de1e4cc031b4ab7d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "openssl@3"

  patch :DATA

  def install
    setup_fuse
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl@3"].opt_lib/"pkgconfig"

    system "cmake", "-S", ".", "-B", "build", *fuse_cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"xmount", "--version"
  end
end
__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 7369014..0bea886 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -73,9 +73,6 @@ check_include_files(libkern/OSByteOrder.h HAVE_LIBKERN_OSBYTEORDER_H)
 find_package(Threads REQUIRED)
 if(NOT APPLE)
   find_package(LibFUSE REQUIRED)
-else(NOT APPLE)
-  # On OSx, search for osxfuse
-  find_package(LibOSXFUSE REQUIRED)
 endif(NOT APPLE)
 
 # Generate config.h and add it's path to the include dirs
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 92d9b8f..623c3d1 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -2,9 +2,8 @@ if(NOT APPLE)
   include_directories(${LIBFUSE_INCLUDE_DIRS})
   set(LIBS ${LIBS} ${LIBFUSE_LIBRARIES})
 else(NOT APPLE)
-  include_directories(${LIBOSXFUSE_INCLUDE_DIRS})
-  set(LIBS ${LIBS} ${LIBOSXFUSE_LIBRARIES})
-  link_directories(${LIBOSXFUSE_LIBRARY_DIRS})
+  find_package(PkgConfig REQUIRED)
+  pkg_check_modules(FUSE fuse REQUIRED)
 endif(NOT APPLE)
 
 if(LIBFUSE_VERSION EQUAL 3)
@@ -25,7 +24,9 @@ if(THREADS_HAVE_PTHREAD_ARG)
   target_compile_options(xmount PUBLIC "-pthread")
 endif(THREADS_HAVE_PTHREAD_ARG)
 
-target_link_libraries(xmount ${LIBS})
+target_include_directories(xmount PUBLIC ${FUSE_INCLUDE_DIRS})
+target_link_libraries(xmount PUBLIC ${LIBS} ${FUSE_LDFLAGS})
+target_compile_options(xmount PUBLIC ${FUSE_CFLAGS})
 
 install(TARGETS xmount DESTINATION bin)
 
