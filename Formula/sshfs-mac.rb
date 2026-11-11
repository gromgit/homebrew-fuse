require_relative "../require/macfuse"

class SshfsMac < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://github.com/libfuse/sshfs"
  url "https://github.com/libfuse/sshfs/archive/refs/tags/sshfs-3.7.7.tar.gz"
  sha256 "3f2873a2b7e7bdd3179ce2a5ee00d219a043cbd75d5be42ccb9707123a90418f"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "7d760b60854885933941ef9482cbf4cbb5088067af264c927f5af7d22d89fd51"
    sha256 cellar: :any, arm64_sequoia: "06ec2ea56ad23c597dfd9caede0d8b199becbae1de40966e9df305bca1821f0f"
  end

  depends_on "coreutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse3
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin"
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "SSHFS version #{version}", shell_output("#{bin}/sshfs --version")
  end
end
