require_relative "../require/macfuse"

class GocryptfsMac < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.5.3/gocryptfs_v2.5.3_src-deps.tar.gz"
  sha256 "4b6d874b5383be5ed33d7ef7a5a6152d2b6a5d1965215a426ec855c043138ee2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_sonoma: "4abd9d34815e2858278ff38ff2eb30b7ddc1b12b94452d5294ad6b0e4be5f3e8"
    sha256 cellar: :any, ventura:      "75331c2d30f380316d4817dcf0c5a667de2d9337239eb0a6c8a8a9ee6378270e"
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
