require_relative "../require/macfuse"

class WdfsMac < Formula
  desc "Webdav file system"
  homepage "http://noedler.de/projekte/wdfs/"
  url "http://noedler.de/projekte/wdfs/wdfs-1.4.2.tar.gz"
  sha256 "fcf2e1584568b07c7f3683a983a9be26fae6534b8109e09167e5dff9114ba2e5"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/wdfs-mac-1.4.2"
    sha256 cellar: :any, arm64_monterey: "c3c3814f21f2e828a99f9fbed147a40ba6fbbf0ff5176245a4a6439d726c0d21"
    sha256 cellar: :any, monterey:       "2e8a0932b4f6148f09b8df5be63e3e0e69536a452820f19b0d8b3e261d4f7bc6"
    sha256 cellar: :any, big_sur:        "8e9cbe0059e88abf08f411c3b30b63c6a5b73e57a2d150a4cdfcded9e02863ac"
    sha256 cellar: :any, catalina:       "ff22c3b38115e75154a5bfd334481acc8594f04486cd667ab5f0a78fd9be67b9"
    sha256 cellar: :any, mojave:         "a8a7c080c4e56fe4b8eebaf6f66d594ebd72f5155ae01aa33e704883625e615b"
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
