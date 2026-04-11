require_relative "../require/macfuse"

class HfsfuseMac < Formula
  desc "FUSE driver for HFS+ filesystems (read-only)"
  homepage "https://github.com/0x09/hfsfuse"
  url "https://github.com/0x09/hfsfuse/releases/download/0.416/hfsfuse-0.416.tar.gz"
  sha256 "c99e854c73d12281d1005cd8b89e5e1fdf0b9fb1f5ffa1845c91de3d48fac666"
  license all_of: ["BSD-2-Clause", "MIT"]
  head "https://github.com/0x09/hfsfuse.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "b1235e5caeab0fca9fb9569f9fe8de0b872ed7777c463be31a59336caf193dce"
    sha256 cellar: :any, arm64_sequoia: "f570d92405466a189eaecdb7c499b80319d0025686a8400ec707f9ea395d3afd"
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
