require_relative "../require/macfuse"

class TupMac < Formula
  desc "File-based build system"
  homepage "http://gittup.org/tup/"
  url "https://github.com/gittup/tup/archive/refs/tags/v0.8.tar.gz"
  sha256 "45ca35c4c1d140f3faaab7fabf9d68fd9c21074af2af9a720cff4b27cab47d07"
  license "GPL-2.0-only"
  head "https://github.com/gittup/tup.git"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "c560a370134cbe065d983bc0f40a3fb7481524eeae8463c891b91853ff2813a8"
    sha256 cellar: :any,                 ventura:      "1553e833231b266f2c270dfe8e7e21933af45ffe8c37aba141cd3ce2706f6f46"
  end

  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    ENV["TUP_LABEL"] = version
    system "./build.sh"
    bin.install "build/tup"
    man1.install "tup.1"
    doc.install (buildpath/"docs").children
    pkgshare.install "contrib/syntax"
  end

  test do
    system "#{bin}/tup", "-v"
  end
end
