require_relative "../require/macfuse"

class WdfsMac < Formula
  desc "Webdav file system"
  homepage "http://noedler.de/projekte/wdfs/"
  url "http://noedler.de/projekte/wdfs/wdfs-1.4.2.tar.gz"
  sha256 "fcf2e1584568b07c7f3683a983a9be26fae6534b8109e09167e5dff9114ba2e5"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    rebuild 1
    sha256 cellar: :any, arm64_sonoma: "470836a78df1eefa59cf45a46d2592313bdb32a51d0797266fe2c6ee1c588867"
    sha256 cellar: :any, ventura:      "d4350a182eeecb7003c5ff582c5a1329e156f894d9ac0a0aa64485f607fdc55d"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "neon"

  def install
    setup_fuse
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"wdfs", "-v"
  end
end
