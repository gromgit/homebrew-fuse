require_relative "../require/macfuse"

class BindfsMac < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.17.1.tar.gz"
  sha256 "edb4989144d28f75affc4f5b18074fb97a58d6ee35ad6919ac75eb6a4cbfe352"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/bindfs-mac-1.17.1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41730479fb8fa81ff002c07d33fcc21a734dab1b59b5dcaec943b8103bc369bd"
    sha256 cellar: :any,                 monterey:       "a1ba8e02ea9cc9495ddd397a6d0bd49a862b191e8bee8b8ce432b965125a709e"
    sha256 cellar: :any,                 big_sur:        "1749f4dc83b556ccc1ac40b743645d1939f9e0726bddbc004d901c6f32454fa6"
    sha256 cellar: :any,                 catalina:       "e265bd4c3015d7ce7e8c6efe0a0e0010aae344bff9081e23723978949dece36e"
    sha256 cellar: :any_skip_relocation, mojave:         "890df2360d6f8ae37ab269220f34e048052d4dc096e9a492da18548adfda5914"
  end

  head do
    url "https://github.com/mpartel/bindfs.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system "#{bin}/bindfs", "-V"
  end
end
