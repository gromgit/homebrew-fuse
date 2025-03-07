require_relative "../require/macfuse"

class GcsfuseMac < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "44a9e9da84f04be59ef736d283624c116ec90d103c0f87c874b8ce5e51d5df85"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "676453470943e7c5ebf32f192a8e09d4aa7d11c4fc8411476b514bf60716e155"
    sha256 cellar: :any_skip_relocation, ventura:      "feef9dc9b3983462e6c60082f410e9e8ec05274f1712435711496aa7d1450ee5"
  end

  depends_on "go" => :build
  depends_on MacfuseRequirement
  depends_on :macos

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
      Upstream hasn't decided whether to support macOS (https://github.com/GoogleCloudPlatform/gcsfuse/issues/1299)
      and versions after v2.4.0 don't build at all on macOS.
      This formula will not be updated until macOS is officially supported.
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
 

