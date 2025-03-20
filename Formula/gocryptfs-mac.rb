require_relative "../require/macfuse"

class GocryptfsMac < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.5.2/gocryptfs_v2.5.2_src-deps.tar.gz"
  sha256 "cc45bdc774592d392c4625c242529c2632bcf1e55ed16d8e81b142fc58616a60"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_sonoma: "5e46fef0657f37ac1990b1b83f4d8d1af06bf66735faa89983026bd115b00de1"
    sha256 cellar: :any, ventura:      "b5afded46b2a7493da7923de46fe8ee7a7c2bca2f73047a466e9f861ffa40769"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "openssl@3"

  def install
    setup_fuse
    system "./build.bash"
    bin.install "gocryptfs", "gocryptfs-xray/gocryptfs-xray"
    man1.install "Documentation/gocryptfs.1", "Documentation/gocryptfs-xray.1"
  end

  test do
    (testpath/"encdir").mkpath
    pipe_output("#{bin}/gocryptfs -init #{testpath}/encdir", "password", 0)
    assert_path_exists testpath/"encdir/gocryptfs.conf"
  end
end
