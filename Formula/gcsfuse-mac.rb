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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45a24d5fbc15ebf5c2eadc4e89dabfdd6919b8a978d79aef0aa0eb77be09793f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0a51b15c46502ea6ae80bade59b5b3be38a24dd8b48e6075b2be718c977b93f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c618a8584ece71eff0af4733f2cc886daef816c3aad52180e8c8fa436bd9f88f"
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
 

