require_relative "../require/macfuse"

class FusehfsMac < Formula
  desc "FUSE driver for HFS filesystems"
  homepage "https://thejoelpatrol.github.io/fusehfs/"
  url "https://github.com/thejoelpatrol/fusehfs/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "0f37b0cf31d38665af279b7b5bde0a185da55d7e8e6ccdb0de9133c3740143e8"
  license "GPL-2.0-or-later"
  head "https://github.com/thejoelpatrol/fusehfs.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "937bc2d207749a4a9008abc5961f683c6b6753703ef8e78704746bec751e6dd3"
    sha256 cellar: :any,                 ventura:      "1c82b43b527c4ebb8e7979172a093856d8b7ca1be38d668888799db82239ed2a"
  end

  depends_on xcode: :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    xcodebuild "-arch", Hardware::CPU.arch,
               "-target", "FS Bundle",
               "-configuration", "Release",
               "CODE_SIGN_IDENTITY=-",
               "SYMROOT=build",
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    bin.install "build/Release/hfsck"
    bin.install "build/Release/mount_fusefs_hfs"
    pkgshare.install "build/Release/fusefs_hfs.fs"
  end

  def caveats
    <<~EOS
      To add support for mounting HFS-formatted disk images via double-click,
      install and re-sign the filesystem bundle with:

        codesign -f -s - $(brew --prefix)/share/fusehfs-mac/fusefs_hfs.fs
        sudo ln -s $(brew --prefix)/share/fusehfs-mac/fusefs_hfs.fs /Library/Filesystems
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mount_fusefs_hfs --version 2>&1", 1)
  end
end
