require_relative "../require/macfuse"

class CryfsMac < Formula
  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/0.10.3/cryfs-0.10.3.tar.xz"
  sha256 "051d8d8e6b3751a088effcc4aedd39061be007c34dc1689a93430735193d979f"
  license "LGPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/cryfs-mac-0.10.3"
    sha256 cellar: :any, big_sur:  "50ad034e80fc0cb9ca197ba1563d08761e8716c72ebf131550a74be15c2eb203"
    sha256 cellar: :any, catalina: "6580d5df0615a854a347a0d7eb5414b020032e50a194d25184629aa6fecc45c4"
    sha256 cellar: :any, mojave:   "85c14c719bc3ca56e0fca178830d2d19160d500d84084f577b495eca78456de3"
  end

  head do
    url "https://github.com/cryfs/cryfs.git", branch: "develop", shallow: false
  end

  depends_on "cmake" => :build
  depends_on "conan" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libomp"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "openssl@1.1"

  patch :DATA

  def install
    setup_fuse
    configure_args = [
      "-GNinja",
      "-DBUILD_TESTING=off",
    ]

    if build.head?
      libomp = Formula["libomp"]
      configure_args.concat(
        [
          "-DOpenMP_CXX_FLAGS='-Xpreprocessor -fopenmp -I#{libomp.include}'",
          "-DOpenMP_CXX_LIB_NAMES=omp",
          "-DOpenMP_omp_LIBRARY=#{libomp.lib}/libomp.dylib",
        ],
      )
    end

    # macFUSE puts pkg-config into /usr/local/lib/pkgconfig, which is not included in
    # homebrew's default PKG_CONFIG_PATH. We need to tell pkg-config about this path for our build
    ENV.prepend_path "PKG_CONFIG_PATH", "#{HOMEBREW_PREFIX}/lib/pkgconfig"

    system "cmake", ".", *configure_args, *std_cmake_args
    system "ninja", "install"
  end

  test do
    ENV["CRYFS_FRONTEND"] = "noninteractive"

    # Test showing help page
    assert_match "CryFS", shell_output("#{bin}/cryfs 2>&1", 10)

    # Test mounting a filesystem. This command will ultimately fail because homebrew tests
    # don't have the required permissions to mount fuse filesystems, but before that
    # it should display "Mounting filesystem". If that doesn't happen, there's something
    # wrong. For example there was an ABI incompatibility issue between the crypto++ version
    # the cryfs bottle was compiled with and the crypto++ library installed by homebrew to.
    mkdir "basedir"
    mkdir "mountdir"
    assert_match "Operation not permitted", pipe_output("#{bin}/cryfs -f basedir mountdir 2>&1", "password")
  end
end
__END__
diff --git a/src/fspp/fuse/CMakeLists.txt b/src/fspp/fuse/CMakeLists.txt
index b991bd7..df1f481 100644
--- a/src/fspp/fuse/CMakeLists.txt
+++ b/src/fspp/fuse/CMakeLists.txt
@@ -37,7 +37,7 @@ if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
 
 elseif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
   set(CMAKE_FIND_FRAMEWORK LAST)
-  find_library_with_path(FUSE "osxfuse" FUSE_LIB_PATH)
+  find_library_with_path(FUSE "fuse" FUSE_LIB_PATH)
   target_link_libraries(${PROJECT_NAME} PUBLIC ${FUSE})
 else() # Linux
   find_library_with_path(FUSE "fuse" FUSE_LIB_PATH)
diff --git a/src/fspp/fuse/params.h b/src/fspp/fuse/params.h
index 4a45ef7..dfbac60 100644
--- a/src/fspp/fuse/params.h
+++ b/src/fspp/fuse/params.h
@@ -6,7 +6,7 @@
 #if defined(__linux__) || defined(__FreeBSD__)
 #include <fuse.h>
 #elif __APPLE__
-#include <osxfuse/fuse.h>
+#include <fuse.h>
 #elif defined(_MSC_VER)
 #include <fuse.h> // Dokany fuse
 #else
