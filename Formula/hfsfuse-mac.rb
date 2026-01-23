require_relative "../require/macfuse"

class HfsfuseMac < Formula
  desc "FUSE driver for HFS+ filesystems (read-only)"
  homepage "https://github.com/0x09/hfsfuse"
  url "https://github.com/0x09/hfsfuse/releases/download/0.318/hfsfuse-0.318.tar.gz"
  sha256 "01a0dff1fd83c25a88250e3b4ef150fe4eaa920db02770ca126c7da9fc404a1e"
  license all_of: ["BSD-2-Clause", "MIT"]
  head "https://github.com/0x09/hfsfuse.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "f3f8f016549b023c31c1fbca1998d31d5d1452319a3152b0d21a8107c0c81cf8"
    sha256 cellar: :any, arm64_sequoia: "f3843985cb817343609f990fa7bd1c346453017814defbf4311c5f031c6ba8cd"
    sha256 cellar: :any, arm64_sonoma:  "33a1216d966ed9426cbf2be528b17556e07ce0757161d62d774a69b2b72dfd3f"
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
