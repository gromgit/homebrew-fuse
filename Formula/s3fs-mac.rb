require_relative "../require/macfuse"

class S3fsMac < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.91.tar.gz"
  sha256 "f130fec375dc6972145c56f53e83ea7c98c82621406d0208a328989e5d900b0f"
  license "GPL-2.0-or-later"
  head "https://github.com/s3fs-fuse/s3fs-fuse.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/s3fs-mac-1.91"
    sha256 cellar: :any, arm64_monterey: "a433fd964e67240ff3135f19aa4de7e1dcdbe331a339ba52f7803241032810ea"
    sha256 cellar: :any, monterey:       "35fafafd91eaa1995e4fe5fa3b6944232d245a5c75697f4aa5c97263f1328979"
    sha256 cellar: :any, big_sur:        "b9e8bb0525cd245c65cc7008d81898f918e12589dcd6cebf1dbe5f0157988ed2"
    sha256 cellar: :any, catalina:       "694c4f8d8a2fc059226df89992438ee12a2dc420775ff52e48e9a85c7c868612"
    sha256 cellar: :any, mojave:         "6888b53265c1e3d0432d308acdc3b86779a949d89a77162555bafed73641508a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "nettle"

  def install
    setup_fuse
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--with-gnutls", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/s3fs", "--version"
  end
end
