require_relative "../require/macfuse"

class BindfsMac < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.17.4.tar.gz"
  sha256 "6fd4af9ba2ec2bdb603ef8eea2a9d12db2e5fe9cbe52b8640b415734a59f3dcc"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/bindfs-mac-1.17.4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15edc10eb2e8ed76603f8e1bb8c501c7447cb2c8ecbda7297bf7f40884ab75e5"
    sha256 cellar: :any,                 big_sur:        "f136a250b5c6caeb8cd67e7b5db5a99e169cebaf96f11f57b7a86393c906ef85"
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
