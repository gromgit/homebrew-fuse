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
    sha256 cellar: :any, arm64_sonoma: "508aa0e067ea5bd62cdab71626d343384578d79db7ed53ad1a6cb075ca1bd6a8"
    sha256 cellar: :any, ventura:      "06146c2169ecaf61ed886a28231bec023ae7761eb85bce358c7fc8ed2fd60d12"
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
