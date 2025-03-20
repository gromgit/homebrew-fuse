require_relative "../require/macfuse"

class DwarfsFuseMac < Formula
  desc "Fast high compression read-only file system (macFUSE driver)"
  homepage "https://github.com/mhx/dwarfs"
  url "https://github.com/mhx/dwarfs/releases/download/v0.11.2/dwarfs-0.11.2.tar.xz"
  sha256 "1b38faf399a6d01cd0e5f919b176e1cab76e4a8507088d060a91b92c174d912b"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_sonoma: "ecea742dda5358d0f577cf942c7ee112ff2bdb27bebeafe15fdd86295972b77c"
    sha256 cellar: :any, ventura:      "34501094d48380aeed79217f28c0fbed893b9e7112caa021145e41d760eef5dc"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "dwarfs"
  depends_on "llvm" if DevelopmentTools.clang_build_version < 1500
  depends_on MacfuseRequirement
  depends_on :macos

  fails_with :clang do
    build 1499
    cause "Not all required C++20 features are supported"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWITH_LIBDWARFS=OFF
      -DWITH_TOOLS=OFF
      -DWITH_FUSE_DRIVER=ON
      -DWITH_TESTS=OFF
      -DWITH_MAN_PAGES=ON
      -DENABLE_PERFMON=ON
      -DENABLE_STACKTRACE=OFF
      -DDISABLE_CCACHE=ON
      -DDISABLE_MOLD=ON
    ]

    if DevelopmentTools.clang_build_version < 1500
      ENV.llvm_clang

      # Needed in order to find the C++ standard library
      # See: https://github.com/Homebrew/homebrew-core/issues/178435
      ENV.prepend "LDFLAGS", "-L#{Formula["llvm"].opt_lib}/c++ -L#{Formula["llvm"].opt_lib} -lunwind"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--parallel"
    system "cmake", "--install", "build"
  end

  test do
    system sbin/"dwarfs", "--help"
  end
end
