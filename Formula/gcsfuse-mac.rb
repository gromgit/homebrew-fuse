require_relative "../require/macfuse"

class GcsfuseMac < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/v0.42.3.tar.gz"
  sha256 "1a87747192ff4a1219d5985fa09048ddebf2b30dd4f7f1c4d786a648ceba3a90"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/gcsfuse-mac-0.42.3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a540eee3f019333851d3b3aba7ef2d34cec94e59ac4c0ebcfa47a41fd49a8b9"
    sha256 cellar: :any_skip_relocation, monterey:       "cdfa3d98d870c22ee07bd01165d6c8ee94c48c66bca795061914a81169311753"
    sha256 cellar: :any_skip_relocation, big_sur:        "c12a8e567d04163e6a6a94dcf2481195aaa06d6185acb24d3614ea699904ff69"
  end

  depends_on "go" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  # Review for removal on next release
  patch do
    url "https://github.com/GoogleCloudPlatform/gcsfuse/commit/c2abca911ff03b84ab64214b6717d8d7cc74c10f.patch?full_index=1"
    sha256 "62930a0ae8322a071d489b1dd386206742b962123312b1368589c731867945b4"
  end

  def install
    setup_fuse
    # Build the build_gcsfuse tool. Ensure that it doesn't pick up any
    # libraries from the user's GOPATH; it should have no dependencies.
    ENV.delete("GOPATH")
    system "go", "build", "./tools/build_gcsfuse"

    # Use that tool to build gcsfuse itself.
    gcsfuse_version = build.head? ? Utils.git_short_head : version
    system "./build_gcsfuse", buildpath, prefix, gcsfuse_version, "-buildvcs=false"
  end

  test do
    system "#{bin}/gcsfuse", "--help"
    system "#{sbin}/mount_gcsfuse", "--help"
  end
end
