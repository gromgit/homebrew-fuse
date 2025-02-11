require_relative "../require/macfuse"

class CryfsMac < Formula
  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/1.0.1/cryfs-1.0.1.tar.xz"
  sha256 "7ad4cc45e1060431991538d3e671ec11285896c0d7a24880290945ef3ca248ed"
  license "LGPL-3.0-or-later"
  head "https://github.com/cryfs/cryfs.git", branch: "develop"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/cryfs-mac-0.11.3"
    sha256 cellar: :any, arm64_monterey: "225fae9b8f7deff22021f8246b0c5cfcb7ed2148a203db913129f51fd2127e70"
    sha256 cellar: :any, monterey:       "86109f34aee00d844c118284841f01c76913506a3ab91799b8fcba37dd2872fc"
    sha256 cellar: :any, big_sur:        "1db05c98160e1a5a27374df23cb23ccb16aa3b8480441ad655c4634773339f25"
    sha256 cellar: :any, catalina:       "2bb057bb09d92948c76f563fa2347b0260b2c00872655b30dc83b4a54ca4bd74"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "boost"
  depends_on "curl"
  depends_on "fmt"
  depends_on "libomp"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "range-v3"
  depends_on "spdlog"

  def install
    setup_fuse
    libomp = Formula["libomp"]
    libomp_args = [
      "-DBUILD_TESTING=off",
      "-DOpenMP_CXX_FLAGS='-Xpreprocessor -fopenmp -I#{libomp.include}'",
      "-DOpenMP_CXX_LIB_NAMES=omp",
      "-DOpenMP_omp_LIBRARY=#{libomp.lib}/libomp.dylib",
    ]

    system "cmake", "-B", "build", "-S", ".",
                    "-DCRYFS_UPDATE_CHECKS=OFF",
                    "-DDEPENDENCY_CONFIG=cmake-utils/DependenciesFromLocalSystem.cmake",
                    *libomp_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["CRYFS_FRONTEND"] = "noninteractive"

    # Test showing help page
    assert_match "CryFS", shell_output("#{bin}/cryfs 2>&1", 10)

    # Test mounting a filesystem. This command will ultimately fail because homebrew tests
    # don't have the required permissions to mount fuse filesystems, but before that
    # it should display "Mounting filesystem". If that doesn't happen, there's something
    # wrong. For example there was an ABI incompatibility issue between the crypto++ version
    # the cryfs bottle was compiled with and the crypto++ library installed by homebrew to.
    mkdir "basedir"
    mkdir "mountdir"
    assert_match "Operation not permitted", pipe_output("#{bin}/cryfs -f basedir mountdir 2>&1", "password")
  end
end
