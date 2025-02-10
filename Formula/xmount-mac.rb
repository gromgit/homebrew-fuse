require_relative "../require/macfuse"

class XmountMac < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.sits.lu/xmount"
  url "https://code.sits.lu/foss/xmount/-/archive/1.2.0/xmount-1.2.0.tar.gz"
  sha256 "abded7b53646c5d56ab9caf30473d75d0deb543e8262cadf2af572da3e1d127d"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/xmount-mac-0.7.6"
    sha256 monterey: "3892b95a295e6c00bcf433d083248399d4d826f922db317e38a4563f6dd5d086"
    sha256 big_sur:  "7759a60875ac63e16cf33d1b87376be2f1cc57adc2ac4653e71d7bc10b5707db"
    sha256 catalina: "9e25523204f40e98d32026209e5380ecda4048b9f9a4abed15574fb07c50d765"
    sha256 mojave:   "2a195cb467d9df4a0152f56aa66e29a5b3e039558a60a9fb969d41fb53ddc781"
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
diff --git a/cmake_modules/FindLibOSXFUSE.cmake b/cmake_modules/FindLibOSXFUSE.cmake
index 9b98990..315fe88 100644
--- a/cmake_modules/FindLibOSXFUSE.cmake
+++ b/cmake_modules/FindLibOSXFUSE.cmake
@@ -1,6 +1,6 @@
 # Try pkg-config first
 find_package(PkgConfig)
-pkg_check_modules(PKGC_LIBOSXFUSE QUIET osxfuse)
+pkg_check_modules(PKGC_LIBOSXFUSE QUIET fuse)
 
 if(PKGC_LIBOSXFUSE_FOUND)
   # Found lib using pkg-config.
