require_relative "../require/macfuse"

class Mp3fsMac < Formula
  desc "Read-only FUSE file system: transcodes audio formats to MP3"
  homepage "https://khenriks.github.io/mp3fs/"
  url "https://github.com/khenriks/mp3fs/releases/download/v1.1.1/mp3fs-1.1.1.tar.gz"
  sha256 "942b588fb623ea58ce8cac8844e6ff2829ad4bc9b4c163bba58e3fa9ebc15608"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/mp3fs-mac-1.1.1"
    sha256 cellar: :any, monterey: "6a87fa45e92a95ef436a88352494dd2d3b2907d02e213cb24af9612a8475fa4c"
    sha256 cellar: :any, big_sur:  "f5d8b429073bd633bb0e3bfdf0fa5d72170e3e2c50ea35498169203c3aeb7b5a"
    sha256 cellar: :any, catalina: "87445edbdfdec0ee366b5bbfb57349b4b7fc380fda83fe0c866049055ecfcda7"
    sha256 cellar: :any, mojave:   "64aeb9e00ab95135f27a62319c607ee47ecbaf24459e27289da40ff8c70366a2"
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libid3tag"
  depends_on "libvorbis"
  depends_on MacfuseRequirement
  depends_on :macos

  patch :DATA

  def install
    setup_fuse
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
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
