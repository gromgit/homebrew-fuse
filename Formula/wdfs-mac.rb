require_relative "../require/macfuse"

class WdfsMac < Formula
  desc "Webdav file system"
  homepage "http://noedler.de/projekte/wdfs/"
  url "http://noedler.de/projekte/wdfs/wdfs-1.4.2.tar.gz"
  sha256 "fcf2e1584568b07c7f3683a983a9be26fae6534b8109e09167e5dff9114ba2e5"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/wdfs-mac-1.4.2"
    sha256 cellar: :any, big_sur: "8e9cbe0059e88abf08f411c3b30b63c6a5b73e57a2d150a4cdfcded9e02863ac"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "neon"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wdfs", "-v"
  end
end
