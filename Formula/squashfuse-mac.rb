require_relative "../require/macfuse"

class SquashfuseMac < Formula
  desc "FUSE filesystem to mount squashfs archives"
  homepage "https://github.com/vasi/squashfuse"
  url "https://github.com/vasi/squashfuse/releases/download/0.1.104/squashfuse-0.1.104.tar.gz"
  sha256 "aa52460559e0d0b1753f6b1af5c68cfb777ca5a13913285e93f4f9b7aa894b3a"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/squashfuse-mac-0.1.104"
    sha256 cellar: :any, monterey: "d8cb1d3b4e8cd06e737330d505cef93b6db04ba5bc4a9532d0a95bfa155eab7d"
    sha256 cellar: :any, big_sur:  "71e48214e5e13234e5270af7a8e4332adbf0a4e5b7b45fa754f6c06776b4b132"
    sha256 cellar: :any, catalina: "2e2f3ae67cff7da3ea72bbe60c82030cee19068b2490fe28ee518339366cc59f"
    sha256 cellar: :any, mojave:   "eac9534833ef065791327d82fd7d9dfe675b3c5921e3fa41dde963917625e300"
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
