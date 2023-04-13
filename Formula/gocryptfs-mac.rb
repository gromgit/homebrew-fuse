require_relative "../require/macfuse"

class GocryptfsMac < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.3.1/gocryptfs_v2.3.1_src-deps.tar.gz"
  sha256 "62a856a9771307b34a75a1e9ab9489abe4a4e7e7f9230c2b1046ca037ea2ba50"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/gocryptfs-mac-2.3.1"
    sha256 cellar: :any, arm64_monterey: "8eebd6792d724b5cb7fe33bc039d7ce7e76e83bc1a46898a52a92157b1e90362"
    sha256 cellar: :any, monterey:       "d8bdf670abdb1812d342113b706421af3de574f7ee59715bb85ef6898e04ad7e"
    sha256 cellar: :any, big_sur:        "70b47719af058eeca3eaa26ad0c9e76bc485ba032240109d0281d177aabd8d60"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "openssl@1.1"

  def install
    setup_fuse
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rfjakob/gocryptfs").install buildpath.children
    cd "src/github.com/rfjakob/gocryptfs" do
      system "./build.bash"
      bin.install "gocryptfs"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"encdir").mkpath
    pipe_output("#{bin}/gocryptfs -init #{testpath}/encdir", "password", 0)
    assert_predicate testpath/"encdir/gocryptfs.conf", :exist?
  end
end
