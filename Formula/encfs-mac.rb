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
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 arm64_sonoma: "e487eff9455449dd1c22e5381732fb040c20c124e436dce941c891b2d24d7c51"
    sha256 ventura:      "8d8411520042ab3ee86816119cdd99761fbadaf2064e22ba20df571bb9fcba5c"
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
