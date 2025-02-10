require_relative "../require/macfuse"

class BindfsMac < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.17.7.tar.gz"
  sha256 "c0b060e94c3a231a1d4aa0bcf266ff189981a4ef38e42fbe23296a7d81719b7a"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/bindfs-mac-1.17.4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15edc10eb2e8ed76603f8e1bb8c501c7447cb2c8ecbda7297bf7f40884ab75e5"
    sha256 cellar: :any,                 big_sur:        "f136a250b5c6caeb8cd67e7b5db5a99e169cebaf96f11f57b7a86393c906ef85"
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
