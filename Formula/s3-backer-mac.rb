require_relative "../require/macfuse"

class S3BackerMac < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  url "https://archie-public.s3.amazonaws.com/s3backer/s3backer-2.0.1.tar.gz"
  sha256 "f902c0f3740a9117a3de6dd619141c08e52fbb967399fc051d6a67d57e715208"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/s3-backer-mac-1.6.3"
    sha256 cellar: :any, arm64_monterey: "b61d30670b020cb27c8acc9ce7888774dc1ce4f2aa42df4cc96cbc3ec98be389"
    sha256 cellar: :any, monterey:       "fbba88dee405e54a779e2d44d00cf35c6fd07fcba8df09edd9c8dc354113ac46"
    sha256 cellar: :any, big_sur:        "08a15a5a5096c36e415caf1e3de2c79566b7c515558f844801f0dd6055cbe3aa"
    sha256 cellar: :any, catalina:       "693c50b9164d039d82af8417cbdf40da26cb6a8e847b4a8de90572ad56cc3c2d"
    sha256 cellar: :any, mojave:         "6d73421febd44083336ff46ac5d1c9f16cb4a1709097ae61fbf8b4e7c29be114"
  end

  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "openssl@1.1"

  def install
    setup_fuse
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"s3backer", "--version"
  end
end
