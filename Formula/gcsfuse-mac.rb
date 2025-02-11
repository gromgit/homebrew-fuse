require_relative "../require/macfuse"

class GcsfuseMac < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/refs/tags/v0.42.5.tar.gz"
  sha256 "272ad522ebbbfe3da87ee00aeff5fe347d25a4a49499c254e482a59bbed5c692"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/gcsfuse-mac-0.42.5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c8fe0405b5bd69ad29b9a2d64034c332a190d5c6772fd51c83a40e431ad9ac2"
    sha256 cellar: :any_skip_relocation, monterey:       "293e9a8e9e00e58df3ff3dd90c9bb81a53d3345c412c4d6cf8b1e344484e1283"
    sha256 cellar: :any_skip_relocation, big_sur:        "7aae298075c4ab1a56635d3bec54360e6986c59596b66a132fcc2cdba8633a14"
  end

  deprecate! date: "2025-02-11", because: :does_not_build

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

  def caveats
    <<~EOS
      Upstream doesn't officially support macOS (https://github.com/GoogleCloudPlatform/gcsfuse/issues/1299)
      and current versions don't build at all on macOS.
      This formula will not be updated until macOS is officially supported.
    EOS
  end

  test do
    system "#{bin}/gcsfuse", "--help"
    system "#{sbin}/mount_gcsfuse", "--help"
  end
end
