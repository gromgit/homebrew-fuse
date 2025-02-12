require_relative "../require/macfuse"

class EncfsMac < Formula
  desc "Encrypted pass-through FUSE file system"
  homepage "https://vgough.github.io/encfs/"
  url "https://github.com/vgough/encfs/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "4709f05395ccbad6c0a5b40a4619d60aafe3473b1a79bafb3aa700b1f756fd63"
  # The code comprising the EncFS library (libencfs) is licensed under the LGPL.
  # The main programs (encfs, encfsctl, etc) are licensed under the GPL.
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/vgough/encfs.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/encfs-mac-1.9.5"
    sha256 arm64_monterey: "238100c7b23cb0b9030c72f707402947f58b354d3e9af7121100c23498d7c915"
    sha256 monterey:       "606d9e55178edbf88c29b36942740f731ace9c913e8db1c0351cc821276115a5"
    sha256 big_sur:        "1e40532f256119f88304d5fa3033b8a60e513f3c3531cd3471455a83fcebafa7"
    sha256 catalina:       "ab083e7303625337405e8f384f99d51a5208c54f4cd713dbd99b3bc196da2e90"
    sha256 mojave:         "7c363d28eac6e6582b352202db79f17f0a0efa4871a4991313c158cd04911dcd"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "openssl@3"
  depends_on "tinyxml2"

  patch do
    url "https://github.com/vgough/encfs/commit/75080681626062e5832aec0b1bb3aa37d8364822.patch?full_index=1"
    sha256 "0222bc4a4f03541b1523b03471f6af5925d4ed2a4c0d36a9a6fe39a18c036770"
  end

  def install
    setup_fuse
    ENV.cxx11
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DUSE_INTERNAL_TINYXML=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Functional test violates sandboxing, so punt.
    # Issue #50602; upstream issue vgough/encfs#151
    assert_match version.to_s, shell_output("#{bin}/encfs 2>&1", 1)
  end
end
