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
    sha256 cellar: :any, arm64_tahoe:   "f8725b64d0011757f604ceeac28b0c0899b3609397bb1ab7acb6bca7d2e8d517"
    sha256 cellar: :any, arm64_sequoia: "a03cd998233b96666393a8b9a838643a45a0181d836b7cffd1ada4a1e146f30a"
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
