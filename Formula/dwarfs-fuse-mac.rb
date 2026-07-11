require_relative "../require/macfuse"

class DwarfsFuseMac < Formula
  desc "Fast high compression read-only file system (macFUSE driver)"
  homepage "https://github.com/mhx/dwarfs"
  url "https://github.com/mhx/dwarfs/releases/download/v0.15.5/dwarfs-0.15.5.tar.xz"
  sha256 "e6315f514c2e0db099b7e1627eeed1b968ba316c4a1cb2d96306132303816c00"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 arm64_tahoe:   "ce9942e3842e0f5c4c5951558cf2ae4858450d9e0f18fc03afcbe799ceb2f4f5"
    sha256 arm64_sequoia: "ba06457481b1d8c91b1803fefe5ebb4332d8a7c57296335c140db348dc11a614"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "brotli"
  depends_on "flac"
  depends_on "fmt"
  depends_on "howard-hinnant-date"
  depends_on "libarchive"
  depends_on "llvm" if DevelopmentTools.clang_build_version <= 1500
  depends_on "lz4"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "nlohmann-json"
  depends_on "openssl@3"
  depends_on "parallel-hashmap"
  depends_on "range-v3"
  depends_on "utf8cpp"
  depends_on "xxhash"
  depends_on "xz"
  depends_on "zstd"

  conflicts_with "dwarfs", because: "both install the same binaries"

  fails_with :clang do
    build 1500
    cause "Not all required C++23 features are supported"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWITH_LIBDWARFS=ON
      -DWITH_TOOLS=ON
      -DWITH_FUSE_DRIVER=ON
      -DWITH_TESTS=ON
      -DWITH_MAN_PAGES=ON
      -DENABLE_PERFMON=ON
      -DTRY_ENABLE_FLAC=ON
      -DENABLE_RICEPP=ON
      -DENABLE_STACKTRACE=OFF
      -DDISABLE_CCACHE=ON
      -DDISABLE_MOLD=ON
      -DPREFER_SYSTEM_GTEST=ON
    ]

    if DevelopmentTools.clang_build_version <= 1500
      # No ASAN for folly
      ENV.append "CXXFLAGS", "-D_LIBCPP_HAS_NO_ASAN"

      ENV.llvm_clang

      # Needed in order to find the C++ standard library
      # See: https://github.com/Homebrew/homebrew-core/issues/178435
      ENV.prepend "LDFLAGS", "-L#{formula_opt_lib("llvm")}/unwind -lunwind"
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", formula_opt_lib("llvm")/"c++"
    end

    setup_fuse
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # produce a dwarfs image
    system bin/"mkdwarfs", "-i", prefix, "-o", "test.dwarfs", "-l4"

    # check the image
    system bin/"dwarfsck", "test.dwarfs"

    # get JSON info about the image
    info = JSON.parse(shell_output("#{bin}/dwarfsck test.dwarfs -j"))
    assert_equal info["created_by"], "libdwarfs v#{version}"
    assert_operator 10, :<=, info["inode_count"]

    # extract the image
    system bin/"dwarfsextract", "-i", "test.dwarfs"
    assert_path_exists "bin/mkdwarfs"
    assert_path_exists "share/man/man1/mkdwarfs.1"
    assert compare_file bin/"mkdwarfs", "bin/mkdwarfs"

    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <dwarfs/version.h>

      int main(int argc, char **argv) {
        int v = dwarfs::get_dwarfs_library_version();
        int major = v / 10000;
        int minor = (v % 10000) / 100;
        int patch = v % 100;
        std::cout << major << "." << minor << "." << patch << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++23", "test.cpp", "-I#{include}", "-L#{lib}", "-Wl,-rpath,#{lib}",
                    "-o", "test", "-ldwarfs_common"

    assert_equal version.to_s, shell_output("./test").chomp
  end
end
