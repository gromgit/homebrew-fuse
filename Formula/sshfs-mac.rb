require_relative "../require/macfuse"

class SshfsMac < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://github.com/libfuse/sshfs"
  url "https://github.com/libfuse/sshfs/archive/refs/tags/sshfs-3.7.6.tar.gz"
  sha256 "67a3e166a39b07708497ee0aee308547dba386053cf8d816b4ce8a9b3066a6ce"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_tahoe:   "114ec7f6cac5db3f7b4e4a63381f11958f3e20ea614eb9dda1356ed70ffbf4e5"
    sha256 cellar: :any, arm64_sequoia: "211b6ce7c0e73abcca42f646fda6ad8573ff10de6f846636f382f8258f35d562"
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
