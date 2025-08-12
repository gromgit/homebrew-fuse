require_relative "../require/macfuse"

class GocryptfsMac < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.6.1/gocryptfs_v2.6.1_src-deps.tar.gz"
  sha256 "9a966c1340a1a1d92073091643687b1205c46b57017c5da2bf7e97e3f5729a5a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_sequoia: "56a4955f379ccb148f2e269679c91af0202bb67725dc6f1ed661bb5f8c9f0b68"
    sha256 cellar: :any, arm64_sonoma:  "8c4634a99acb568f25b96fc752b3bdb7a16d830e96126b93ee5a354a4dc67b2d"
    sha256 cellar: :any, ventura:       "40cda455675c2f6a0970c1c5388797da874758bf8f50d57fa4bf6ff448ab1edd"
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
