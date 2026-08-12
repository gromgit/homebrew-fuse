require_relative "../require/macfuse"

class HfsfuseMac < Formula
  desc "FUSE driver for HFS+ filesystems (read-only)"
  homepage "https://github.com/0x09/hfsfuse"
  url "https://github.com/0x09/hfsfuse/releases/download/0.430/hfsfuse-0.430.tar.gz"
  sha256 "7744543091446350bbb53223bf00e0c11946ee1a0f9e77a8f4912134c4301641"
  license all_of: ["BSD-2-Clause", "MIT"]
  head "https://github.com/0x09/hfsfuse.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "7edaf3e87a538b24bd17a0275e66d2aae4ec899917baccbbe40e903121a6e46d"
    sha256 cellar: :any, arm64_sequoia: "fb01ae03d9886d3657b6bb8cdbe7459b7202a844d802fa530ad9c9e8abc22a4d"
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
