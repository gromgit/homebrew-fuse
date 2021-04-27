require_relative "../require/macfuse"

class ArchivemountMac < Formula
  desc "File system for accessing archives using libarchive"
  homepage "https://www.cybernoia.de/software/archivemount.html"
  url "https://www.cybernoia.de/software/archivemount/archivemount-0.9.1.tar.gz"
  sha256 "c529b981cacb19541b48ddafdafb2ede47a40fcaf16c677c1e2cd198b159c5b3"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/archivemount-mac-0.9.1"
    sha256 cellar: :any, big_sur:  "2f7b7f0fc96a3421d5ba0c2ad20b75e436aaac90cd5b63dffb001b2efad7af24"
    sha256 cellar: :any, catalina: "3fccbf62ca680170901fba2a5543c538072964d8016a1fc3c76fa9e971b8b1ec"
  end

  depends_on "pkg-config" => :build
  depends_on "libarchive"
  depends_on MacfuseRequirement
  depends_on :macos

  def install
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
