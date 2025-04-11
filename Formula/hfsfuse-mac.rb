require_relative "../require/macfuse"

class HfsfuseMac < Formula
  desc "FUSE driver for HFS+ filesystems (read-only)"
  homepage "https://github.com/0x09/hfsfuse"
  url "https://github.com/0x09/hfsfuse/releases/download/0.289/hfsfuse-0.289.tar.gz"
  sha256 "b19597dda364a670eebf05d0681c77db4b0f625f19b9e16f4b2b65dd8d16c360"
  license all_of: ["BSD-2-Clause", "MIT"]
  head "https://github.com/0x09/hfsfuse.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_sonoma: "5c3fb573d7abe2b4ffff56c52509bd1a98d2379af89db53668b2a3ecbae58129"
    sha256 cellar: :any, ventura:      "6edd19c3dfd49a01787af0c19b652f7e7b2a6d5671810733b02d0fce92041338"
  end

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
