require_relative "../require/macfuse"

class BindfsMac < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.18.4.tar.gz"
  sha256 "3266d0aab787a9328bbb0ed561a371e19f1ff077273e6684ca92a90fedb2fe24"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abe6cbec99f98023c699adf447c9673884a3d55cd4e9aa9f188226bec78750c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3d392955a8c59f9bdb757dfe9900608b2a3c54f21021d628d8adb679a352649"
  end

  head do
    url "https://github.com/mpartel/bindfs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse3
    # https://github.com/mpartel/bindfs/issues/163#issuecomment-2854763292
    ENV.append "CFLAGS", "-D_DARWIN_C_SOURCE"
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-macos-fs-link", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/bindfs", "-V"
  end
end
