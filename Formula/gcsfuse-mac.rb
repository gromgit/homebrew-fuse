require_relative "../require/macfuse"

class GcsfuseMac < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "07eb90d76c50b8fcf0376a43f96ecce098195062e9dced617b3bac68ff51bc79"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a1ba45e4b858af7ffa38f84fa9c2c67b7aa4eb315a6c33fc35b8955dc09c4f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d8b94e66dc99f5bdc8e292f266ddc833e74335d2a8b7a8d28270fec673948b8"
    sha256 cellar: :any_skip_relocation, ventura:       "9c3be3e52179801354fcd031871e17735dfd263dca13ce7028c46bc02978d83b"
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
 

