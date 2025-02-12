require_relative "../require/macfuse"

class Mp3fsMac < Formula
  desc "Read-only FUSE file system: transcodes audio formats to MP3"
  homepage "https://khenriks.github.io/mp3fs/"
  url "https://github.com/khenriks/mp3fs/releases/download/v1.1.1/mp3fs-1.1.1.tar.gz"
  sha256 "942b588fb623ea58ce8cac8844e6ff2829ad4bc9b4c163bba58e3fa9ebc15608"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    rebuild 1
    sha256 cellar: :any, arm64_sonoma: "4171a0e1383f1c17150ed12ecb88fb766df4a105ce789e79e3d67130208c4b60"
    sha256 cellar: :any, ventura:      "6d3d1bd7f5db566dbe51bf16dfd5c63ed79cc1ea98904d48921953ccc9b77c01"
  end

  depends_on "pkgconf" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libid3tag"
  depends_on "libvorbis"
  depends_on MacfuseRequirement
  depends_on :macos

  patch :DATA

  def install
    setup_fuse
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "mp3fs version: #{version}", shell_output("#{bin}/mp3fs -V")
  end
end
__END__
diff --git a/src/mp3fs.cc b/src/mp3fs.cc
index f846da9..f215f10 100644
--- a/src/mp3fs.cc
+++ b/src/mp3fs.cc
@@ -28,9 +28,6 @@
 #include <fuse.h>
 #include <fuse_common.h>
 #include <fuse_opt.h>
-#ifdef __APPLE__
-#include <fuse_darwin.h>
-#endif
 
 #include <cstddef>
 #include <cstdlib>
@@ -166,9 +163,6 @@ void print_versions(std::ostream&& out) {
     print_codec_versions(out);
     out << "FUSE library version: " << FUSE_MAJOR_VERSION << "."
         << FUSE_MINOR_VERSION << std::endl;
-#ifdef __APPLE__
-    out << "OS X FUSE version: " << osxfuse_version() << std::endl;
-#endif
 }
 
 int mp3fs_opt_proc(void* /*unused*/, const char* arg, int key,
