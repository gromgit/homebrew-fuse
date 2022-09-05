require_relative "../require/macfuse"

class BindfsMac < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.17.0.tar.gz"
  sha256 "70da57d49e7794fe54b8575bfdd6a7943aab54ada2e8e2fdf4be04e0011451dc"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/bindfs-mac-1.17.0"
    sha256 cellar: :any, monterey: "a89ee7436ed6268759ab8d118ae33f2e7ef08f9f6f4362c6b9d86c1b80660bf3"
    sha256 cellar: :any, big_sur:  "438df92ca7ec74d8d30897ad4bc9f45ba10a8a97523df5892ac8970992819bcf"
    sha256 cellar: :any, catalina: "ccb850e290a88fa78930c2920854766385d3cfeb8e4537278cc918745a88a056"
    sha256 cellar: :any, mojave:   "c48f0834685c79d272f7af5801f9b8cab86686b5d0e82b255b028f1f4a57a115"
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
