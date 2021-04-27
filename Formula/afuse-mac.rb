require_relative "../require/macfuse"

class AfuseMac < Formula
  desc "Automounting file system implemented in userspace with FUSE"
  homepage "https://github.com/pcarrier/afuse/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/afuse/afuse-0.4.1.tar.gz"
  sha256 "c6e0555a65d42d3782e0734198bbebd22486386e29cb00047bc43c3eb726dca8"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/afuse-mac-0.4.1"
    sha256 cellar: :any, big_sur:  "5793a602add435689cfcd384bd1e7627568765c2417a30014525eb0e40e71ef5"
    sha256 cellar: :any, catalina: "2e3018f85263dffcd6ef7e906453ba274601219461bcda3c79d105465f55a175"
    sha256 cellar: :any, mojave:   "d98cbc816c74cdb8c7423234b9542600cb5aa29581608e98ba34c9cbf4db7b86"
  end

  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "FUSE library version", pipe_output("#{bin}/afuse --version 2>&1")
  end
end
