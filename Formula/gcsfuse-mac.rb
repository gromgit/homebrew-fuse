require_relative "../require/macfuse"

class GcsfuseMac < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/v0.35.0.tar.gz"
  sha256 "7d1f9586cb9645ab9d4a6eba6ece6eab78591e01e8149797bb48d7b72ab9031f"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/gcsfuse-mac-0.35.0"
    sha256 cellar: :any_skip_relocation, big_sur: "1a43e1ffed4c8a8c1924d3165ac28a6ffe9744d53972533083b735b16596c22e"
  end

  depends_on "go" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
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
