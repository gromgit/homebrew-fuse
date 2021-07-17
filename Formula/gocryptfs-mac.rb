require_relative "../require/macfuse"

class GocryptfsMac < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.0.1/gocryptfs_v2.0.1_src-deps.tar.gz"
  sha256 "31be3f3a9400bd5eb8a4d5f86f7aee52a488207e12d312f2601ae08e7e26dd02"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/gocryptfs-mac-2.0.1"
    sha256 cellar: :any, big_sur: "27ebed45ea3f76615889f61306ead4d8f718a569f9916b25a2961211ecadd521"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "openssl@1.1"

  # Remove SOURCE_DATE_EPOCH support (requires GNU date)
  patch :DATA

  def install
    setup_fuse
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rfjakob/gocryptfs").install buildpath.children
    cd "src/github.com/rfjakob/gocryptfs" do
      system "./build.bash"
      bin.install "gocryptfs"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"encdir").mkpath
    pipe_output("#{bin}/gocryptfs -init #{testpath}/encdir", "password", 0)
    assert_predicate testpath/"encdir/gocryptfs.conf", :exist?
  end
end
__END__
diff --git a/build.bash b/build.bash
index b5a0c4d..11f2f4c 100755
--- a/build.bash
+++ b/build.bash
@@ -57,12 +57,6 @@ if [[ -z ${BUILDDATE:-} ]] ; then
 	BUILDDATE=$(date +%Y-%m-%d)
 fi
 
-# If SOURCE_DATE_EPOCH is set, it overrides BUILDDATE. This is the
-# standard environment variable for faking the date in reproducible builds.
-if [[ -n ${SOURCE_DATE_EPOCH:-} ]] ; then
-	BUILDDATE=$(date --utc --date="@${SOURCE_DATE_EPOCH}" +%Y-%m-%d)
-fi
-
 # Only set GOFLAGS if it is not already set by the user
 if [[ -z ${GOFLAGS:-} ]] ; then
 	GOFLAGS=""
