require_relative "../require/macfuse"

class GocryptfsMac < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.5.1/gocryptfs_v2.5.1_src-deps.tar.gz"
  sha256 "80c3771c9f7e65af9326b107ddb7a30e9c3c7bf8823412b9615b7f77352cdde7"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/gocryptfs-mac-2.3.2"
    sha256 cellar: :any, arm64_monterey: "42e024906747e1cd13cf1c91e550ef37332e4d0ce296d866894e828efebfa7ef"
    sha256 cellar: :any, monterey:       "8bd935e607d5e40c55b580bcafb4c0799409c48025795056d980c4412f6f6dc9"
    sha256 cellar: :any, big_sur:        "8fda3199d4b9b8bd1523ffe8b20e4965cfbacdb706b6b7a4f4d8e1b694ca6992"
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
