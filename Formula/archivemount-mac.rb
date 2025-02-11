require_relative "../require/macfuse"

class ArchivemountMac < Formula
  desc "File system for accessing archives using libarchive"
  homepage "https://www.cybernoia.de/software/archivemount.html"
  url "https://www.cybernoia.de/software/archivemount/archivemount-0.9.1.tar.gz"
  sha256 "c529b981cacb19541b48ddafdafb2ede47a40fcaf16c677c1e2cd198b159c5b3"

  livecheck do
    url "https://raw.githubusercontent.com/cybernoid/archivemount/refs/heads/master/CHANGELOG"
    regex(/\*\s+v?(\d+(?:\.\d+)+)\s+/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/archivemount-mac-0.9.1"
    sha256 cellar: :any, arm64_monterey: "c79ff7d0b53fbdad256912dbfd3e92727e0f68d5248281e1ffdac941b1b1cfc5"
    sha256 cellar: :any, monterey:       "b938c74e2a690d66ebb85a82e75cbca0a9724d7fdb8596818588975a1f1adad5"
    sha256 cellar: :any, big_sur:        "84dfb26c79c5d3cd6596bbbbb1398dd7d0a855eab32ff2b1192cd36235c34ab9"
    sha256 cellar: :any, catalina:       "0d838c1b6684201cf9ff7bcc1120052bfce87c31950622961852a9e17243cd94"
    sha256 cellar: :any, mojave:         "42170c737f1fd151a4e36276c6929fe49aa69137886238ec38f04a84c123f26b"
  end

  depends_on "pkg-config" => :build
  depends_on "libarchive"
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    ENV.append_to_cflags "-I/usr/local/include/osxfuse"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system bin/"archivemount", "--version"
  end
end
