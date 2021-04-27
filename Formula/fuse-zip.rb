require_relative "../require/macfuse"

class FuseZip < Formula
  desc "FUSE file system to create & manipulate ZIP archives"
  homepage "https://bitbucket.org/agalanin/fuse-zip"
  url "https://bitbucket.org/agalanin/fuse-zip/get/0.7.2.tar.gz"
  sha256 "bba004193db9841a8d9a59e927fffe24f1b92f7ad15a5694c687456617b638a2"
  license "GPL-3.0-or-later"
  head "https://bitbucket.org/agalanin/fuse-zip", using: :hg

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/fuse-zip-0.7.2"
    sha256 cellar: :any, big_sur:  "4e7bbaf05a17ccf3282e6a15cdbe7e46b66e3f6ebe269b3600a05a8c3cf9571a"
    sha256 cellar: :any, catalina: "bed4d00e3b56d18a4ebb7a76bcc9e1f6b4f7e0492b6956275285f8a0d5a3391c"
  end

  depends_on "pkg-config" => :build
  depends_on "libzip"
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system bin/"fuse-zip", "--help"
  end
end
