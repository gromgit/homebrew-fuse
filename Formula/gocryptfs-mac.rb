require_relative "../require/macfuse"

class GocryptfsMac < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.7.0/gocryptfs_v2.7.0_src-deps.tar.gz"
  sha256 "52a271a12bcab3b2e51c0e7baa53a2beeebc9f811d8b28d6b23662a2b70e5680"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "b273ecd34d6e3cb6cb9a4dd54a4411462f73bd36c4a521c6db8cf125b9d16f39"
    sha256 cellar: :any, arm64_sequoia: "9554c1d1ac369c3653c35483121860795a0811d48bc3a54cfa5e820b5d1f42a2"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "openssl@4"

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
