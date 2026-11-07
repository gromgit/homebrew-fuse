require_relative "../require/macfuse"

class ArchivemountMac < Formula
  desc "File system for accessing archives using libarchive"
  homepage "https://git.sr.ht/~nabijaczleweli/archivemount-ng"
  url "https://git.sr.ht/~nabijaczleweli/archivemount-ng/archive/1c.tar.gz"
  version "1c"
  sha256 "7bc489a1a77ce718c84b751a57779ded6bb192cf54f9cd0bf7bff2527cf98bfc"
  license "LGPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "36036fafbdaf3f07f90d2a8f3a9333425551846b29c295560a886462a89ffe20"
    sha256 cellar: :any, arm64_sequoia: "5d013b5d7d5ea3e04be4749afc2b4fedbbff117c3d8d20c014ef8fc041282b25"
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
