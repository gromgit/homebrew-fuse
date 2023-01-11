require_relative "../require/macfuse"

class GcsfuseMac < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/v0.41.11.tar.gz"
  sha256 "58daf7ac3658bd0a6857bd0a8a2b73672b791662973e2a7bfbfcbc1b6f18102e"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/gcsfuse-mac-0.41.11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "927150a05873cc6fbf15511020f793d93e801d91e3403ddb6a2bcf53d9a8d053"
    sha256 cellar: :any_skip_relocation, monterey:       "58634af2757fe864ab88434a14c65a6bc6553932ecae5df710c3b6b8b7633dfe"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f3732befab0314648952cdf238a74e520de9cb345071cad6c037eb1f637a1be"
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
