require_relative "../require/macfuse"

class GocryptfsMac < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.2.1/gocryptfs_v2.2.1_src-deps.tar.gz"
  sha256 "8d3f66fe426de6b31dfd56122f26047cc8cda679d2fba7bc26d78448701da5e3"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/gocryptfs-mac-2.2.1"
    sha256 cellar: :any, monterey: "e0c267b091391fc0d7af3d1411dc22d68a8325427b884d9a01273918704c09d2"
    sha256 cellar: :any, big_sur:  "1c618b3a27524e560372f5d26d0718434f04a32ffe6cd0faa18b39f6019df13d"
    sha256 cellar: :any, catalina: "928575ec0f8aeeeae29a15bbc71d611338a17b672e42b2fdb512c7ee55ecf091"
    sha256 cellar: :any, mojave:   "22a05bc7c7d6c0d5b36261e3ff9f02d8e475b24efcaa82d4d650aa02348a9b0d"
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
