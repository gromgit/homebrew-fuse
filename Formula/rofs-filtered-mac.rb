require_relative "../require/macfuse"

class RofsFilteredMac < Formula
  desc "Filtered read-only filesystem for FUSE"
  homepage "https://github.com/gburca/rofs-filtered/"
  url "https://github.com/gburca/rofs-filtered/archive/refs/tags/rel-1.7.tar.gz"
  sha256 "d66066dfd0274a2fb7b71dd929445377dd23100b9fa43e3888dbe3fc7e8228e8"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "666320aa517fcda5fea5a9189caf62889ea80efc97991325934610f526565742"
    sha256 cellar: :any,                 ventura:      "0340ec5bd37f169ca31e5240a26766abef47040363f13f1fc0f7de2cd58a3e59"
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
