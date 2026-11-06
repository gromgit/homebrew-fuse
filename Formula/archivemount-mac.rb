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
    sha256 cellar: :any, arm64_tahoe:   "e0aa81ce9ae8fb880b340b02077e03acaf1d4f489554a411bf4430ba3a558f31"
    sha256 cellar: :any, arm64_sequoia: "fa4e1c0bbd16a705f0746d9c1721e3a5ebf9fc664b49291dd0390129542595ae"
    sha256 cellar: :any, arm64_sonoma:  "ab28653f06c95589c740800b90187182cf45abffa2dda25146881dceaa963152"
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
