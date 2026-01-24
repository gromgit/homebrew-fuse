require_relative "../require/macfuse"

class HfsfuseMac < Formula
  desc "FUSE driver for HFS+ filesystems (read-only)"
  homepage "https://github.com/0x09/hfsfuse"
  url "https://github.com/0x09/hfsfuse/releases/download/0.358/hfsfuse-0.358.tar.gz"
  sha256 "dd34720a4184665224e3328249c47934f1230243250a809b145b76c37e1762fb"
  license all_of: ["BSD-2-Clause", "MIT"]
  head "https://github.com/0x09/hfsfuse.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "40bc7ca7da883db1de616e8269ae321b7fe2d0c86d9daa74c5a926e0039acdd8"
    sha256 cellar: :any, arm64_sequoia: "3891ac7d10aeab4f0101b8631e42fe31aaff5f8ecb2957253369053a3daff406"
    sha256 cellar: :any, arm64_sonoma:  "2dd4ecd2b46025de7f1a78c2edb0d4af03c7f6e1f2f38da410e315c73db9cdc2"
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
