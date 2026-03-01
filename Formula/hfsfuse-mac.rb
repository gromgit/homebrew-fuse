require_relative "../require/macfuse"

class HfsfuseMac < Formula
  desc "FUSE driver for HFS+ filesystems (read-only)"
  homepage "https://github.com/0x09/hfsfuse"
  url "https://github.com/0x09/hfsfuse/releases/download/0.406/hfsfuse-0.406.tar.gz"
  sha256 "8603d0f77255e8ba001aaff3cfeddcf1aba0881fc8b5b980a7a94bdef60c4bf3"
  license all_of: ["BSD-2-Clause", "MIT"]
  head "https://github.com/0x09/hfsfuse.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "8ceb06f6dec4263a153987272df6649356287fa7eaae43991287e5259e563b76"
    sha256 cellar: :any, arm64_sequoia: "3c3a7dbfbd828311d55ae83f60fa067306510582c52ad4f40dd3dd8f7b54cb00"
  end

  depends_on "libarchive"
  depends_on "lzfse"
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hfsfuse --version 2>&1")
    system bin/"hfsdump"
  end
end
