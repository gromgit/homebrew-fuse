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
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/gcsfuse-mac-0.42.5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c8fe0405b5bd69ad29b9a2d64034c332a190d5c6772fd51c83a40e431ad9ac2"
    sha256 cellar: :any_skip_relocation, monterey:       "293e9a8e9e00e58df3ff3dd90c9bb81a53d3345c412c4d6cf8b1e344484e1283"
    sha256 cellar: :any_skip_relocation, big_sur:        "7aae298075c4ab1a56635d3bec54360e6986c59596b66a132fcc2cdba8633a14"
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
 

