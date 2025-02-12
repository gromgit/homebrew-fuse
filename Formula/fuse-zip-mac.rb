require_relative "../require/macfuse"

class FuseZipMac < Formula
  desc "FUSE file system to create & manipulate ZIP archives"
  homepage "https://bitbucket.org/agalanin/fuse-zip"
  url "https://bitbucket.org/agalanin/fuse-zip/downloads/fuse-zip-0.7.2.tar.gz"
  sha256 "3dd0be005677442f1fd9769a02dfc0b4fcdd39eb167e5697db2f14f4fee58915"
  license "GPL-3.0-or-later"
  head "https://bitbucket.org/agalanin/fuse-zip", using: :hg, branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    rebuild 1
    sha256 cellar: :any, arm64_sonoma: "07d4a035c41b76adc6fa4e320ba0e002bc6ff6e8ca52e0e47d0ad42b267762f0"
    sha256 cellar: :any, ventura:      "185b074a45baad043449b409896b0425ffcdc83eeac02d903f6b5a84867cb7e2"
  end

  depends_on "pkgconf" => :build
  depends_on "libzip"
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system bin/"fuse-zip", "--help"
  end
end
