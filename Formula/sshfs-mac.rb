require_relative "../require/macfuse"

class SshfsMac < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://github.com/libfuse/sshfs"
  url "https://github.com/libfuse/sshfs/archive/refs/tags/sshfs-3.7.5.tar.gz"
  sha256 "99d294101f1b8997653a84c35674c2e50c18323ea2c449412c0ed46b9d31ac35"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/sshfs-mac-2.10"
    sha256 cellar: :any, arm64_monterey: "422abbbbd1804e67c27a21b976e4e82cfdffd977b5aa2cf7ee4e21fc2b548167"
    sha256 cellar: :any, monterey:       "ffbc11b371d196dd6a32c13b21dfc28af7f7577145a62a165062228c2c661263"
    sha256 cellar: :any, big_sur:        "9e021d24580ec55f4ab034dba0e264906d9db5c57036fe83710bc601bc6885c6"
    sha256 cellar: :any, catalina:       "09f254420411218a784c783df760d2c652acd280eecc875d60e41014f80011cc"
    sha256 cellar: :any, mojave:         "6389b69b921295f5be6eb35336649f558375eb24da60573b376a313331a4d18c"
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
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac?
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system "#{bin}/sshfs", "--version"
  end
end
