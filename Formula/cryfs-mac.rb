require_relative "../require/macfuse"

class CryfsMac < Formula
  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/0.11.0/cryfs-0.11.0.tar.xz"
  sha256 "5583f84f3fcbd4bdbdcc9bfe4bb10971b2fca80a67b539b340556b5de482b737"
  license "LGPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/cryfs-mac-0.11.0"
    sha256 cellar: :any, big_sur:  "aebb5495fbbce0865daa8d78eb10bbf5f2353c80a7db15168f6579b43bb63493"
    sha256 cellar: :any, catalina: "9e60ca10a4fef208741d9c0675d529f60a8bf51f2f90a522b69887f72cb7c423"
  end

  head do
    url "https://github.com/cryfs/cryfs.git", branch: "develop", shallow: false
  end

  depends_on "cmake" => :build
  depends_on "conan" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libomp"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "openssl@1.1"

  def install
    setup_fuse
    configure_args = [
      "-GNinja",
      "-DBUILD_TESTING=off",
    ]

    if build.head?
      libomp = Formula["libomp"]
      configure_args.concat(
        [
          "-DOpenMP_CXX_FLAGS='-Xpreprocessor -fopenmp -I#{libomp.include}'",
          "-DOpenMP_CXX_LIB_NAMES=omp",
          "-DOpenMP_omp_LIBRARY=#{libomp.lib}/libomp.dylib",
        ],
      )
    end

    # macFUSE puts pkg-config into /usr/local/lib/pkgconfig, which is not included in
    # homebrew's default PKG_CONFIG_PATH. We need to tell pkg-config about this path for our build
    ENV.prepend_path "PKG_CONFIG_PATH", "#{HOMEBREW_PREFIX}/lib/pkgconfig"

    system "cmake", ".", *configure_args, *std_cmake_args
    system "ninja", "install"
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
