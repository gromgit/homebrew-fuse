require_relative "../require/macfuse"

class RofsFilteredMac < Formula
  desc "Filtered read-only filesystem for FUSE"
  homepage "https://github.com/gburca/rofs-filtered/"
  url "https://github.com/gburca/rofs-filtered/archive/rel-1.7.tar.gz"
  sha256 "d66066dfd0274a2fb7b71dd929445377dd23100b9fa43e3888dbe3fc7e8228e8"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/rofs-filtered-mac-1.7"
    sha256 cellar: :any, big_sur:  "cb7cbae756a0415b639c86a4d7998fd95bc66cde8be46f6cac08d8a158595f55"
    sha256 cellar: :any, catalina: "b1606a594b8aa539680f7796ef2dd16f8f38fb239da08b2af2a5b1914a9c480f"
    sha256 cellar: :any, mojave:   "d3fc41566f4d522148ed320f31751e48b325935fe94f79cd17293b840011bdf7"
  end

  depends_on "cmake" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/rofs-filtered", "--version"
  end
end
