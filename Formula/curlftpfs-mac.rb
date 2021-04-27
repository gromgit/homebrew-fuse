require_relative "../require/macfuse"

class CurlftpfsMac < Formula
  desc "Filesystem for accessing FTP hosts based on FUSE and libcurl"
  homepage "https://curlftpfs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/curlftpfs/curlftpfs/0.9.2/curlftpfs-0.9.2.tar.gz"
  sha256 "4eb44739c7078ba0edde177bdd266c4cfb7c621075f47f64c85a06b12b3c6958"
  head ":pserver:anonymous:@curlftpfs.cvs.sourceforge.net:/cvsroot/curlftpfs", using: :cvs

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/curlftpfs-mac-0.9.2"
    sha256 cellar: :any, big_sur: "cd9cee6bb3058e276f82313f91a1647466b7d7ad385aaeaae75d66f9f6fa56f4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on MacfuseRequirement
  depends_on :macos

  # TODO: depend on specific X11 formulae instead

  def install
    ENV.append "CPPFLAGS", "-D__off_t=off_t"
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/curlftpfs --version 2>&1", 1)
  end
end
