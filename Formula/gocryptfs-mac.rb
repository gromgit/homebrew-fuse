require_relative "../require/macfuse"

class GocryptfsMac < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.7.0/gocryptfs_v2.7.0_src-deps.tar.gz"
  sha256 "52a271a12bcab3b2e51c0e7baa53a2beeebc9f811d8b28d6b23662a2b70e5680"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "6d596be4c32c0e5c956ac1b4b7e33e51e71f792d795a98f50b68bf4467fe39eb"
    sha256 cellar: :any, arm64_sequoia: "1d6cacbe07df9eac2871ee1aa28d83d6e068a980af63585e32b62130ef46a4c1"
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
