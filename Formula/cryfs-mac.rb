require_relative "../require/macfuse"

class CryfsMac < Formula
  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/0.11.2/cryfs-0.11.2.tar.xz"
  sha256 "951ef565d37521df5586b00ed898f1cb76188739c27b9db866cc91ca14fdf1bd"
  license "LGPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/cryfs-mac-0.11.2"
    sha256 cellar: :any, arm64_monterey: "f4b9f8c635f85b06dc55ef6f1bf44c2b30d2d6635fa43834df73b973399b2032"
    sha256 cellar: :any, monterey:       "b6385cbf5baa774ef3b68cdedcba883523b768238be6318b2613bed61d5b0aea"
    sha256 cellar: :any, big_sur:        "b0bd3cfc1c8f466df9edd09abb9927561a2d057561137889931a95f94fe915bb"
    sha256 cellar: :any, catalina:       "e75d601613188573b09714d0829c1309f3b7acaa822e1046484ed8df93881b9c"
    sha256 cellar: :any, mojave:         "1d9df6d37cfe7f8c36ef942bcc093a3e8a50318ace2ebc5a7500af9120a589b2"
  end

  head do
    url "https://github.com/cryfs/cryfs.git", branch: "develop", shallow: false
  end

  depends_on "cmake" => :build
  depends_on "conan" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "curl"
  depends_on "libomp"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "openssl@1.1"

  def install
    setup_fuse

    libomp = Formula["libomp"]
    configure_args = [
      "-GNinja",
      "-DBUILD_TESTING=off",
      "-DOpenMP_CXX_FLAGS='-Xpreprocessor -fopenmp -I#{libomp.include}'",
      "-DOpenMP_CXX_LIB_NAMES=omp",
      "-DOpenMP_omp_LIBRARY=#{libomp.lib}/libomp.dylib",
    ]

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
