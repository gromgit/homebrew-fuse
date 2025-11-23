require_relative "../require/macfuse"

class ArchivemountMac < Formula
  desc "File system for accessing archives using libarchive"
  homepage "https://git.sr.ht/~nabijaczleweli/archivemount-ng"
  url "https://git.sr.ht/~nabijaczleweli/archivemount-ng/archive/1b.tar.gz"
  version "1b"
  sha256 "de10cfee3bff8c1dd2b92358531d3c0001db36a99e1098ed0c9d205d110e903d"
  license "LGPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "50738aa449a8b214387c1cc148b30b760fb64ced8dd0c85f0d0c29db25986a73"
    sha256 cellar: :any, arm64_sequoia: "02e40045fc073d935a4abf9b83e469b1c5f50b15fa84f53b95f1164e658279aa"
    sha256 cellar: :any, arm64_sonoma:  "482da34d8d8dbd9a2ce53f4ae40e1f84ca946e188d681ef9cc72d9535e98b3cd"
  end

  depends_on "pkgconf" => :build
  depends_on "libarchive"
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse3
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"archivemount", "--version"
  end
end
