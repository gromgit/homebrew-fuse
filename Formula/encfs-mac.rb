require_relative "../require/macfuse"

class EncfsMac < Formula
  desc "Encrypted pass-through FUSE file system"
  homepage "https://vgough.github.io/encfs/"
  url "https://github.com/vgough/encfs/archive/v1.9.5.tar.gz"
  sha256 "4709f05395ccbad6c0a5b40a4619d60aafe3473b1a79bafb3aa700b1f756fd63"
  # The code comprising the EncFS library (libencfs) is licensed under the LGPL.
  # The main programs (encfs, encfsctl, etc) are licensed under the GPL.
  license all_of: ["GPL-3.0-only", "LGPL-3.0-only", "MIT", "Zlib"]
  head "https://github.com/vgough/encfs.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/encfs-mac-1.9.5"
    sha256 big_sur: "1e40532f256119f88304d5fa3033b8a60e513f3c3531cd3471455a83fcebafa7"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "openssl@1.1"

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    # Functional test violates sandboxing, so punt.
    # Issue #50602; upstream issue vgough/encfs#151
    assert_match version.to_s, shell_output("#{bin}/encfs 2>&1", 1)
  end
end
