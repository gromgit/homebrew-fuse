require_relative "../require/macfuse"

class GcsfuseMac < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/refs/tags/v3.5.4.tar.gz"
  sha256 "dee76449ad43c576c69b97b49ca09894116e648afc8565a5ac97be07bbc0c285"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f284896b5576dc2a98d1c96c9f2b53f35051ac0bb01c38b8828fd5826c93f69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73758bd920293d0574c6c8ca147ffbd54c51734f8fec12307fd81bc3b5d6b633"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "658ac578828a18b15d8e68639a47fd3c2c7da1a6e04c8c5c4b0d610d0b7b5f4e"
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
 

