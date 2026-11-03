require_relative "../require/macfuse"

class HfsfuseMac < Formula
  desc "FUSE driver for HFS+ filesystems (read-only)"
  homepage "https://github.com/0x09/hfsfuse"
  url "https://github.com/0x09/hfsfuse/releases/download/0.469/hfsfuse-0.469.tar.gz"
  sha256 "49856a4a539436fd879236e1a098cfdacdac569be786a757ed68fcbbe983d22b"
  license all_of: ["BSD-2-Clause", "MIT"]
  head "https://github.com/0x09/hfsfuse.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "4966b406fce382e7946599bcfafb7f03b87e17ddea0533aa4f16d0f746c53990"
    sha256 cellar: :any, arm64_sequoia: "0d3167ad8b135c5f90e57838e472f05b6eba85c6c8fe17af78b81ff4a96a7059"
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
