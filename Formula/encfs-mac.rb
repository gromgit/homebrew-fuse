require_relative "../require/macfuse"

class EncfsMac < Formula
  desc "Encrypted pass-through FUSE file system"
  homepage "https://vgough.github.io/encfs/"
  url "https://github.com/vgough/encfs/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "4709f05395ccbad6c0a5b40a4619d60aafe3473b1a79bafb3aa700b1f756fd63"
  # The code comprising the EncFS library (libencfs) is licensed under the LGPL.
  # The main programs (encfs, encfsctl, etc) are licensed under the GPL.
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/vgough/encfs.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 arm64_tahoe:   "37fe1d7e2c95f33fbfb33bdb7477b279c4698260aa52894467de41aece01b81d"
    sha256 arm64_sequoia: "540f91e47120bb2fd46043a6e8a9b10f72f552bf2d343985889e631d1d0c71fc"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "openssl@4"
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
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
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
