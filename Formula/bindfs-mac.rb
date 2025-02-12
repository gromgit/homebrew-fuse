require_relative "../require/macfuse"

class BindfsMac < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.17.7.tar.gz"
  sha256 "c0b060e94c3a231a1d4aa0bcf266ff189981a4ef38e42fbe23296a7d81719b7a"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "d4478d1def846dbd6b0bdefd01d29b4b9e08890b088ccd788a3a11927695f196"
    sha256 cellar: :any,                 ventura:      "05629478d5bdb21cd1ef3001fcddc6fba0c3b16feb58ec3d09e6d3c2ba45a172"
  end

  head do
    url "https://github.com/mpartel/bindfs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-macos-fs-link", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/bindfs", "-V"
  end
end
