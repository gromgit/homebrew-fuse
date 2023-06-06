require_relative "../require/macfuse"

class SquashfuseMac < Formula
  desc "FUSE filesystem to mount squashfs archives"
  homepage "https://github.com/vasi/squashfuse"
  url "https://github.com/vasi/squashfuse/releases/download/0.1.104/squashfuse-0.1.104.tar.gz"
  sha256 "aa52460559e0d0b1753f6b1af5c68cfb777ca5a13913285e93f4f9b7aa894b3a"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/squashfuse-mac-0.1.104"
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "d54920002790e1cbf24e78ae5e0bfdd4d88ab8f0b8282c20d902e9202f474569"
    sha256 cellar: :any, big_sur:        "d90a812d02c57e0515044fb7294d50216e8d68503da793234f5759444bf8f079"
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzo"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "squashfs"
  depends_on "xz"
  depends_on "zstd"

  def install
    setup_fuse
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  # Unfortunately, making/testing a squash mount requires sudo privileges, so
  # just test that squashfuse execs for now.
  test do
    output = shell_output("#{bin}/squashfuse --version 2>&1", 254)
    assert_match version.to_s, output
  end
end
