require_relative "../require/macfuse"

class DwarfsFuseMac < Formula
  desc "Fast high compression read-only file system (macFUSE driver)"
  homepage "https://github.com/mhx/dwarfs"
  url "https://github.com/mhx/dwarfs/releases/download/v0.10.2/dwarfs-0.10.2.tar.xz"
  sha256 "36767290a39f92782e41daaa3eb45e39550ad1a4294a6d8365bc0f456f75f00c"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_sonoma: "012c2ee263305d9ba037ff8a3c3656ab879b8e212b409f74d4558a83e832bf78"
    sha256 cellar: :any, ventura:      "764733f3f8b03b4bbd27bce1de3537f4934a0665653beeb57eb637b87c6710d2"
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
