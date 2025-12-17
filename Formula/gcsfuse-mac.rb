require_relative "../require/macfuse"

class GcsfuseMac < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/refs/tags/v3.5.5.tar.gz"
  sha256 "ae5f26ee6969081ecd71bdc581871ebb88cb7b03a00d3bab6f9939b80bcfa39a"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72efecafe04a39bb4d0cdb4b16ca8a18d95b53ff28b87e6f5b703399b9d54f3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34bb4e27327eeba7eac836cf7f8aed6657e35d7ade98c46c775eb42697906cf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb6323689c2567287d512d737b89cf036db1267d24df3a5e8275abf80d24e8e1"
  end

  depends_on "go" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  patch do
    url "https://raw.githubusercontent.com/gromgit/formula-patches/f69773ce21e06e4c6407da25af33486f5ec6185d/gcsfuse-mac/macos.patch?full_index=1"
    sha256 "ab3e204bf099cbabefee825f634cfb9c33349002059b1522488c12bf5790ef11"
  end

  patch :DATA

  def install
    setup_fuse
    # Build the build_gcsfuse tool. Ensure that it doesn't pick up any
    # libraries from the user's GOPATH; it should have no dependencies.
    ENV.delete("GOPATH")
    system "go", "build", "./tools/build_gcsfuse"

    # Use that tool to build gcsfuse itself.
    gcsfuse_version = build.head? ? Utils.git_short_head : version.to_s
    system "./build_gcsfuse", buildpath, prefix, gcsfuse_version
  end

  def caveats
    <<~EOS
      Upstream doesn't actively support macOS (https://github.com/GoogleCloudPlatform/gcsfuse/issues/1299).
    EOS
  end

  test do
    system bin/"gcsfuse", "--help"
    system "#{sbin}/mount_gcsfuse", "--help"
  end
end

__END__
diff --git a/tools/build_gcsfuse/main.go b/tools/build_gcsfuse/main.go
index b1a4022..678f747 100644
--- a/tools/build_gcsfuse/main.go
+++ b/tools/build_gcsfuse/main.go
@@ -134,8 +134,6 @@ func buildBinaries(dstDir, srcDir, version string, buildArgs []string) (err erro
 		cmd := exec.Command(
 			"go",
 			"build",
-			"-C",
-			srcDir,
 			"-o",
 			path.Join(dstDir, bin.outputPath))
 

