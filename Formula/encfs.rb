require_relative "../require/macfuse" if OS.mac?

class Encfs < Formula
  desc "Encrypted pass-through FUSE file system"
  homepage "https://vgough.github.io/encfs/"
  url "https://github.com/vgough/encfs/archive/v1.9.5.tar.gz"
  sha256 "4709f05395ccbad6c0a5b40a4619d60aafe3473b1a79bafb3aa700b1f756fd63"
  license all_of: ["GPL-3.0-only", "LGPL-3.0-only", "MIT", "Zlib"]
  head "https://github.com/vgough/encfs.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-new-life/releases/download/encfs-1.9.5"
    sha256 "956caa8a19ee1ef925f29d5878a86a024a871782852c542929b84fd5d93f7ed2" => :catalina
    sha256 "e5a654f8ce30c13ee37630e8a5aec04f8f7c2ec75cfccf5fe07dc0ba48cf2706" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl@1.1"
  on_macos do
    depends_on MacfuseRequirement
  end
  on_linux do
    depends_on "libfuse"
  end

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
