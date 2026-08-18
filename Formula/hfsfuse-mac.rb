require_relative "../require/macfuse"

class HfsfuseMac < Formula
  desc "FUSE driver for HFS+ filesystems (read-only)"
  homepage "https://github.com/0x09/hfsfuse"
  url "https://github.com/0x09/hfsfuse/releases/download/0.443/hfsfuse-0.443.tar.gz"
  sha256 "b86dd144d36b43f08a1c962fbb211380af0c345f630fe0699fbea8a2ff147df8"
  license all_of: ["BSD-2-Clause", "MIT"]
  head "https://github.com/0x09/hfsfuse.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "a311c88c80110f62df3915480a81450e322327b76f9db68798958bb0197f430f"
    sha256 cellar: :any, arm64_sequoia: "23036aa34685abbc09e898d133b23f89c0057a5553263e44af51e21eac515578"
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
