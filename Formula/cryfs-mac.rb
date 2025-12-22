require_relative "../require/macfuse"

class CryfsMac < Formula
  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/1.0.3/cryfs-1.0.3.tar.xz"
  sha256 "1f30cc406e5c811490ba14174518a797a80442bfff317a2fdfbc5d21205b9dfe"
  license "LGPL-3.0-or-later"
  head "https://github.com/cryfs/cryfs.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_sonoma: "b5175d3198f2be05e267ffdee0000ce54a2f2a56dba534e71a3755b1abcedda3"
    sha256 cellar: :any, ventura:      "38006b9bbd045368a952af0dc34997a2f51eb2b0a5d41feccd75e8e699aee0d0"
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
