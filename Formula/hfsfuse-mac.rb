require_relative "../require/macfuse"

class HfsfuseMac < Formula
  desc "FUSE driver for HFS+ filesystems (read-only)"
  homepage "https://github.com/0x09/hfsfuse"
  url "https://github.com/0x09/hfsfuse/releases/download/0.451/hfsfuse-0.451.tar.gz"
  sha256 "bd358ae7e3cc3093ffe28d6f99ab0112e6ee20e7b394ac6d499b2f4a49820d70"
  license all_of: ["BSD-2-Clause", "MIT"]
  head "https://github.com/0x09/hfsfuse.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "9506020e8120ab7ffc88dc25967e20457538e6be0b3acdfded202cec509b92db"
    sha256 cellar: :any, arm64_sequoia: "0feb5ef49976319e2519953916cd55587cd79db21469b9d865d91e4572fd881b"
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
