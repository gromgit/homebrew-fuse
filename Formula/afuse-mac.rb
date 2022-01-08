require_relative "../require/macfuse"

class AfuseMac < Formula
  desc "Automounting file system implemented in userspace with FUSE"
  homepage "https://github.com/pcarrier/afuse/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/afuse/afuse-0.4.1.tar.gz"
  sha256 "c6e0555a65d42d3782e0734198bbebd22486386e29cb00047bc43c3eb726dca8"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/afuse-mac-0.4.1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01b0427125830477ef5e6780d4a68d2bae93c78f7b60e7973e7bb60e7b177057"
    sha256 cellar: :any,                 monterey:       "5641548745baf07dfae84ae670c96f202ae84b94e12c2fed60eed4aecf3bafc4"
    sha256 cellar: :any,                 big_sur:        "d14a7e51b8d3fd8c7b3419ab06011e5e14c89b6d8c8f46dbe66b80ea3c97fa1f"
    sha256 cellar: :any,                 catalina:       "bf5f4add8d2e8a2c9ad50e2508771f3c51fded35c21f7a23cf95b364e98f9c7a"
    sha256 cellar: :any,                 mojave:         "577023bd06623a90ca245be88fbb49041a71cc1e4852195dc5d9d3b2bbdaf617"
  end

  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "FUSE library version", pipe_output("#{bin}/afuse --version 2>&1")
  end
end
