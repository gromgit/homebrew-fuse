require_relative "../require/macfuse"

class XmountMac < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.pinguin.lu/xmount/"
  url "https://files.pinguin.lu/xmount-0.7.6.tar.gz"
  sha256 "76e544cd55edc2dae32c42a38a04e11336f4985e1d59cec9dd41e9f9af9b0008"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/xmount-mac-0.7.6"
    rebuild 1
    sha256 big_sur:  "7759a60875ac63e16cf33d1b87376be2f1cc57adc2ac4653e71d7bc10b5707db"
    sha256 catalina: "9e25523204f40e98d32026209e5380ecda4048b9f9a4abed15574fb07c50d765"
    sha256 mojave:   "2a195cb467d9df4a0152f56aa66e29a5b3e039558a60a9fb969d41fb53ddc781"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "openssl@1.1"

  patch :DATA

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl@1.1"].opt_lib/"pkgconfig"

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"xmount", "--version"
  end
end
__END__
--- xmount-0.7.6/cmake_modules/FindLibOSXFUSE.cmake.orig	2021-05-05 14:32:44.220213677 +0800
+++ xmount-0.7.6/cmake_modules/FindLibOSXFUSE.cmake	2021-05-05 14:35:07.185349574 +0800
@@ -1,6 +1,6 @@
 # Try pkg-config first
 find_package(PkgConfig)
-pkg_check_modules(PKGC_LIBOSXFUSE QUIET osxfuse)
+pkg_check_modules(PKGC_LIBOSXFUSE QUIET fuse)
 
 if(PKGC_LIBOSXFUSE_FOUND)
   # Found lib using pkg-config.
