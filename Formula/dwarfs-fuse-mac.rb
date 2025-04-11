require_relative "../require/macfuse"

class DwarfsFuseMac < Formula
  desc "Fast high compression read-only file system (macFUSE driver)"
  homepage "https://github.com/mhx/dwarfs"
  url "https://github.com/mhx/dwarfs/releases/download/v0.12.1/dwarfs-0.12.1.tar.xz"
  sha256 "5523a5c3aea244cbfbccfe64f1df6053b3901e6af8916fac1530faf0f7a5f07f"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_sonoma: "a9f1b2e86f644ab0c04dc30d2da11a79c69854b7eab84d24c9550fae87a93afc"
    sha256 cellar: :any, ventura:      "e67abab474d287ab1b81373f30180beae2451001d22308f9ad649ddda544c5dc"
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
