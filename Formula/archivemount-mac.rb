require_relative "../require/macfuse"

class ArchivemountMac < Formula
  desc "File system for accessing archives using libarchive"
  homepage "https://git.sr.ht/~nabijaczleweli/archivemount-ng"
  url "https://git.sr.ht/~nabijaczleweli/archivemount-ng/archive/0.9.1.tar.gz"
  sha256 "882faf07fe9241a5015eff9691c4702fdadb177265833b385135562a1c2c2059"
  license "LGPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    rebuild 1
    sha256 cellar: :any, arm64_sonoma: "abe39d7d99aae950033e62df6c1ac3c33b7b8a7863eeb92d2bb82c1b3b5662fc"
    sha256 cellar: :any, ventura:      "be2622a6cb26b8dc581c35b1cad1f07ddafbfea379e5f4db250258ab6583f615"
  end

  depends_on "pkgconf" => :build
  depends_on "libarchive"
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"archivemount", "--version"
  end
end
