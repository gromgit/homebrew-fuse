require_relative "../require/macfuse"

class HfsfuseMac < Formula
  desc "FUSE driver for HFS+ filesystems (read-only)"
  homepage "https://github.com/0x09/hfsfuse"
  url "https://github.com/0x09/hfsfuse/releases/download/0.307/hfsfuse-0.307.tar.gz"
  sha256 "7e9ce3331839452d8978e2e5e580fdde159f32754aa6e88b752740234a2f1a3e"
  license all_of: ["BSD-2-Clause", "MIT"]
  head "https://github.com/0x09/hfsfuse.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "71e4285bcaa102a8e34c7a0495988a2adc25c4bda95baddd40526b430b4cc2b2"
    sha256 cellar: :any, arm64_sequoia: "740ae64a94872e1219c22dc4f7e993375ae643793f093cfe3e29da84dd1b1abc"
    sha256 cellar: :any, arm64_sonoma:  "ab28bc6d5a69f2d433a6544ce1d893b3dbcd155dc3c02ef4c2b74eea86086a0e"
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
