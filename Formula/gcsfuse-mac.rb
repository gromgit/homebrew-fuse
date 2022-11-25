require_relative "../require/macfuse"

class GcsfuseMac < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/v0.41.8.tar.gz"
  sha256 "c8d340121fce011015d74f347bf4071101ef24689fcb354cacc3e1e5797a8733"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/gcsfuse-mac-0.41.8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff2183a35b6b4487a931c661cdff8f888e561bcaa0a9ca6a435d5f01bc501a64"
    sha256 cellar: :any_skip_relocation, monterey:       "e944f02ecd94ad63c6c400446d6708a1e59437842e9676c4b7dca9483c4c4912"
    sha256 cellar: :any_skip_relocation, big_sur:        "76803b177e5dd106e4b2ec9e52632403ad28c45ebb6cbd217f28954b50c2eabd"
    sha256 cellar: :any_skip_relocation, catalina:       "251f95ed856e0c2efbb1002adbde378886440b1ebfedee330c20157157a7d797"
    sha256 cellar: :any_skip_relocation, mojave:         "5595710d215702e2524b26eb5666fec587fe36f21754e7db9e770ef4eaa08d69"
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
