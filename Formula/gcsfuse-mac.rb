require_relative "../require/macfuse"

class GcsfuseMac < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/v0.41.2.tar.gz"
  sha256 "6a64c30c28651978cf51685051ea9af1d45b9f3d5b3ded894af82c17883a34c4"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/gcsfuse-mac-0.41.2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4ed90a795bb34afdf7a77aa38c6322be0d94c501a60daa0aecce138ecbdfd5b"
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
