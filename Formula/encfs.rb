require_relative "../require/macfuse" if OS.mac?

class Encfs < Formula
  desc "Encrypted pass-through FUSE file system"
  homepage "https://vgough.github.io/encfs/"
  url "https://github.com/vgough/encfs/archive/v1.9.5.tar.gz"
  sha256 "4709f05395ccbad6c0a5b40a4619d60aafe3473b1a79bafb3aa700b1f756fd63"
  license all_of: ["GPL-3.0-only", "LGPL-3.0-only", "MIT", "Zlib"]
  head "https://github.com/vgough/encfs.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/encfs-1.9.5"
    sha256 big_sur:      "a3ad5e221f05f624c74ff3015164ae6e2bac3a99537b3b0a9d8f0b546130abe7"
    sha256 catalina:     "41efd14389d04bf5d2a0bc957972b15b6e1ff511452c89749ddc68b6bca6e3e7"
    sha256 mojave:       "aaf2aa568786ed055114cf54ee4b46acd66f74a7bc10715b446198164afa1871"
    sha256 x86_64_linux: "8f4401c6165c596ce0e9f4e526c355cd573581c64da5661e754afde9300e71b5"
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
