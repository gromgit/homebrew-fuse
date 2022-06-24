require_relative "../require/macfuse"

class BindfsMac < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.16.0.tar.gz"
  sha256 "02ebefaaa64e1b044fc5c743c5829aad21ed6f7145f4db0723bcc45f085781f6"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/bindfs-mac-1.15.1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32cf0fc09d3e0246378dd899b961e50b61ea78edf274f9232dc1a82d51c717f1"
    sha256 cellar: :any,                 monterey:       "e89fa355bac808effa0103fd3bdd307b111d0c937309913a9a38af808cfba8b2"
    sha256 cellar: :any,                 big_sur:        "edb43ff7dd67f03169b9e4c84b527a2ec729c743baeff1e47319008722fccb15"
    sha256 cellar: :any,                 catalina:       "eaabdbc55f58e3782705dbf4a1be9862f741939630bbd6d82e27915309995a2c"
    sha256 cellar: :any,                 mojave:         "a774f403c90cfc617385b6f1a6b0166dd19c9da44983207643cbca7d48808c46"
  end

  head do
    url "https://github.com/mpartel/bindfs.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system "#{bin}/bindfs", "-V"
  end
end
