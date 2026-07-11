require_relative "../require/macfuse"

class HfsfuseMac < Formula
  desc "FUSE driver for HFS+ filesystems (read-only)"
  homepage "https://github.com/0x09/hfsfuse"
  url "https://github.com/0x09/hfsfuse/releases/download/0.425/hfsfuse-0.425.tar.gz"
  sha256 "1da352d9c0c4c22d314d789aeddb64358224c371c2bd295c0fe12fb82dde17ff"
  license all_of: ["BSD-2-Clause", "MIT"]
  head "https://github.com/0x09/hfsfuse.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "846145711ae07e61f84527e88ec519b77a0950d4ed41f0da3fdab92ac20f5604"
    sha256 cellar: :any, arm64_sequoia: "b3da35d604e6ddddf97594f64a62a5d60d4e80d614f7ddab9bd25aeef7a6616e"
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
