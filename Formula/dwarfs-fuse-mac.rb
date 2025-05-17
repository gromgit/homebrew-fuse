require_relative "../require/macfuse"

class DwarfsFuseMac < Formula
  desc "Fast high compression read-only file system (macFUSE driver)"
  homepage "https://github.com/mhx/dwarfs"
  url "https://github.com/mhx/dwarfs/releases/download/v0.12.4/dwarfs-0.12.4.tar.xz"
  sha256 "352d13a3c7d9416e0a7d0d959306a25908b58d1ff47fb97e30a7c8490fcff259"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_sonoma: "90f3d989da230bc700c53503d32ca75dfff4452dd3883d7deef88767b3972112"
    sha256 cellar: :any, ventura:      "549f3ecb3236964c7ecb36cb967de29872ed5257de5a37491577762a660f2cb8"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "dwarfs"
  depends_on "llvm" if DevelopmentTools.clang_build_version <= 1500
  depends_on MacfuseRequirement
  depends_on :macos

  fails_with :clang do
    build 1500
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

    if DevelopmentTools.clang_build_version <= 1500
      ENV.llvm_clang

      # Needed in order to find the C++ standard library
      # See: https://github.com/Homebrew/homebrew-core/issues/178435
      ENV.prepend "LDFLAGS", "-L#{Formula["llvm"].opt_lib}/unwind -lunwind"
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib/"c++"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--parallel"
    system "cmake", "--install", "build"
  end

  test do
    system sbin/"dwarfs", "--help"
  end
end
