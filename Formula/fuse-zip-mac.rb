require_relative "../require/macfuse"

class FuseZipMac < Formula
  desc "FUSE file system to create & manipulate ZIP archives"
  homepage "https://bitbucket.org/agalanin/fuse-zip"
  url "https://bitbucket.org/agalanin/fuse-zip/get/0.7.2.tar.gz"
  sha256 "bba004193db9841a8d9a59e927fffe24f1b92f7ad15a5694c687456617b638a2"
  license "GPL-3.0-or-later"
  head "https://bitbucket.org/agalanin/fuse-zip", using: :hg

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/fuse-zip-mac-0.7.2"
    sha256 cellar: :any, big_sur:  "2fc541f86072d8faba8a4aa99ab1de342f38e6f4af8ffecf8764a45b1b747e2b"
    sha256 cellar: :any, catalina: "b2e45519d7a30220bcbb666abc00e299436965dd64c55abe4d656542a1e0fa29"
    sha256 cellar: :any, mojave:   "f4c68265733a7625566fbdaa7addf5696f52909920fd940630ece3e90b80309e"
  end

  depends_on "pkg-config" => :build
  depends_on "libzip"
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    system "make", "prefix=#{prefix}", "PKG_CONFIG=#{fuse_pkgconfig}", "install"
  end

  test do
    system bin/"fuse-zip", "--help"
  end
end
