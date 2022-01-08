require_relative "../require/macfuse"

class GcsfuseMac < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/v0.35.1.tar.gz"
  sha256 "effcbffa238cf0a97488b4a3b836c0996b1db17a18ad91bf76b5c195a4f5bfed"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/gcsfuse-mac-0.35.1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42983de1de81aba6500d6e84f926eeffa97ec1081f39bfe5f06a565d427fe65c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c49e2ba988a1fda0ca3f28ca2745c37f1e6b8abd2eff55b91b857b1907fe068"
    sha256 cellar: :any_skip_relocation, catalina:       "9824cf0f7e905dc207a5591a233f12a6c9130bfafa6e04c2447506b447a6c52f"
    sha256 cellar: :any_skip_relocation, mojave:         "6322a98c0157d6d5cf7ea56f564dfb90f1bd6bc51f0786d24fb8aca3460fbe22"
  end

  depends_on "go" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    # Build the build_gcsfuse tool. Ensure that it doesn't pick up any
    # libraries from the user's GOPATH; it should have no dependencies.
    ENV.delete("GOPATH")
    system "go", "build", "./tools/build_gcsfuse"

    # Use that tool to build gcsfuse itself.
    gcsfuse_version = build.head? ? Utils.git_short_head : version
    system "./build_gcsfuse", buildpath, prefix, gcsfuse_version
  end

  test do
    system "#{bin}/gcsfuse", "--help"
    system "#{sbin}/mount_gcsfuse", "--help"
  end
end
