require_relative "../require/macfuse"

class GocryptfsMac < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.6.0/gocryptfs_v2.6.0_src-deps.tar.gz"
  sha256 "b3848626b90d0fe87aaf81cc6ef0983089d1a93653f30e7d9b89c7c6e872a4f5"
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
