require_relative "../require/macfuse"

class GocryptfsMac < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v1.8.0/gocryptfs_v1.8.0_src-deps.tar.gz"
  sha256 "c4ca576c2a47f0ed395b96f70fb58fc8f7b4beced8ae67e356eeed6898f8352a"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/gocryptfs-mac-1.8.0"
    sha256 cellar: :any, big_sur:  "dbaf4cf915cf5753752a82b2558de4df5c0afeedbb721a670e383f87dcf0ac23"
    sha256 cellar: :any, catalina: "5dc85ece4509ea6fb4b2c4954c30d103f3da87ebe4cf54626624d84276d0af9f"
    sha256 cellar: :any, mojave:   "6f9ea595c99e7786fbb45fe65fe4f8b1665265314f1f8823464673c69dd7ef95"
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
