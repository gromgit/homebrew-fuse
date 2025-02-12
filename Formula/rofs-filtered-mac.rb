require_relative "../require/macfuse"

class RofsFilteredMac < Formula
  desc "Filtered read-only filesystem for FUSE"
  homepage "https://github.com/gburca/rofs-filtered/"
  url "https://github.com/gburca/rofs-filtered/archive/refs/tags/rel-1.7.tar.gz"
  sha256 "d66066dfd0274a2fb7b71dd929445377dd23100b9fa43e3888dbe3fc7e8228e8"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/rofs-filtered-mac-1.7"
    sha256 cellar: :any, monterey: "d1b89e344c767ca3c38cbc5dda85a840892961fca26726c09be0582db57d0200"
    sha256 cellar: :any, big_sur:  "cb7cbae756a0415b639c86a4d7998fd95bc66cde8be46f6cac08d8a158595f55"
    sha256 cellar: :any, catalina: "b1606a594b8aa539680f7796ef2dd16f8f38fb239da08b2af2a5b1914a9c480f"
    sha256 cellar: :any, mojave:   "d3fc41566f4d522148ed320f31751e48b325935fe94f79cd17293b840011bdf7"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  # Use pkgconfig to find FUSE
  patch :DATA

  def install
    setup_fuse
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    *fuse_cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/rofs-filtered", "--version"
  end
end
__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 53a6687..cb4f121 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -12,8 +12,8 @@ add_definitions(-D_GNU_SOURCE)
 set(CMAKE_C_FLAGS "-Wall -std=c99")
 
 # find fuse library
-find_package (FUSE REQUIRED)
-include_directories (${FUSE_INCLUDE_DIR})
+find_package(PkgConfig REQUIRED)
+pkg_check_modules(FUSE fuse REQUIRED)
 add_definitions(-D_FILE_OFFSET_BITS=64)
 
 # generate config file
@@ -24,7 +24,9 @@ include_directories(${CMAKE_CURRENT_BINARY_DIR})
 
 # create and configure targets
 add_executable(rofs-filtered rofs-filtered.c)
-target_link_libraries(rofs-filtered ${FUSE_LIBRARIES})
+target_include_directories(rofs-filtered PUBLIC ${FUSE_INCLUDE_DIRS})
+target_link_libraries(rofs-filtered PUBLIC ${LIBS} ${FUSE_LDFLAGS})
+target_compile_options(rofs-filtered PUBLIC ${FUSE_CFLAGS})
 
 # configure installation
 install(TARGETS rofs-filtered DESTINATION ${CMAKE_INSTALL_BINDIR})
