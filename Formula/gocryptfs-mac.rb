require_relative "../require/macfuse"

class GocryptfsMac < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.6.1/gocryptfs_v2.6.1_src-deps.tar.gz"
  sha256 "9a966c1340a1a1d92073091643687b1205c46b57017c5da2bf7e97e3f5729a5a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_sonoma: "eebbc5a50c39ac8749a4e163e7754d573fc91b9b6b0463c939dd3724354cac0f"
    sha256 cellar: :any, ventura:      "f889698e5f54c4bc3b66874e7bf4225c0f2f8d129bcad38e0491a712e283d805"
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
