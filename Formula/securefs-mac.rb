require_relative "../require/macfuse"

class SecurefsMac < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs.git",
      tag:      "0.11.1",
      revision: "dfeebf8406871d020848edde668234715356158c"
  license "MIT"
  head "https://github.com/netheril96/securefs.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/securefs-mac-0.11.1"
    sha256 cellar: :any, big_sur: "67f46a42eca522dbc42cc5c8b2ac75b1f367db0810494cf0e6a196723ce32270"
  end

  depends_on "cmake" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  patch :DATA

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/securefs", "version" # The sandbox prevents a more thorough test
  end
end
__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 7b5e57d..7c9d2b7 100755
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -19,11 +19,7 @@ configure_file(${CMAKE_SOURCE_DIR}/sources/git-version.cpp.in ${CMAKE_BINARY_DIR
 
 if (UNIX)
     find_path(FUSE_INCLUDE_DIR fuse.h PATHS /usr/local/include PATH_SUFFIXES osxfuse)
-    if (APPLE)
-        find_library(FUSE_LIBRARIES osxfuse PATHS /usr/local/lib)
-    else()
-        find_library(FUSE_LIBRARIES fuse PATHS /usr/local/lib)
-    endif()
+    find_library(FUSE_LIBRARIES fuse PATHS /usr/local/lib)
     include_directories(${FUSE_INCLUDE_DIR})
     link_libraries(${FUSE_LIBRARIES})
     add_compile_options(-Wall -Wextra -Wno-unknown-pragmas)
