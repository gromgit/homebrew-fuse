require_relative "../require/macfuse"

class UnionfsFuse < Formula
  desc "Union filesystem using FUSE"
  homepage "https://github.com/rpodgorny/unionfs-fuse"
  url "https://github.com/rpodgorny/unionfs-fuse/archive/refs/tags/v2.2.tar.gz"
  sha256 "248a0fee9979146b79b05fc728621869da5936c1f43a27e36e7515b301817e43"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/unionfs-fuse-2.2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0bf63f52a20a6ff3703b0225243c35837d620696c261208e7e2256050c486fb"
    sha256 cellar: :any,                 monterey:       "5325c885b86d7da9a263b0dccb5f40fa0b59b431bf8d9c5efb48d8b3cd043dc6"
    sha256 cellar: :any,                 big_sur:        "4ce1e7bf69c4d4b47af623ace7a33f2ff467e3a944181e910e8ae81e27d1db80"
    sha256 cellar: :any,                 catalina:       "a1961f1ecf7bfb8f6ce0af19ff3f1529986da999da813551bd58b6023e7f5a3f"
  end

  depends_on MacfuseRequirement
  depends_on "pkg-config"

  # macOS compatibility patches
  # Review all the below on next release
  patch do
    url "https://github.com/rpodgorny/unionfs-fuse/commit/f27d75b36a128ab62f432a8c70f33747d4f76bc5.patch?full_index=1"
    sha256 "4a40c424ced2d1627c83c0b795984258057fad7c23f07cb2036db55d6a9d7c75"
  end
  patch do
    url "https://github.com/rpodgorny/unionfs-fuse/commit/b6377071716d051542024e050c372ac5b0588dcd.patch?full_index=1"
    sha256 "bbf6292c267d8c068a9bc294ed1293b63a9a8c129640dc0674ef2d61e98a6c0d"
  end
  patch do
    url "https://github.com/rpodgorny/unionfs-fuse/commit/edcf3ee1461ad839f8784ecc484070773e37c81c.patch?full_index=1"
    sha256 "3b6e129f0afd23eda43a7eccdb4d25cb176175b993ed13d252e27bc8d2a886e0"
  end

  def install
    setup_fuse
    inreplace "CMakeLists.txt", "/usr/local", alt_fuse_root.to_s
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"t1").mkdir
    (testpath/"t1/test1.txt").write <<~EOS
      This is test 1.
    EOS
    (testpath/"t2").mkdir
    (testpath/"t2/test2.txt").write <<~EOS
      This is test 2.
    EOS
    (testpath/"t3").mkdir
    begin
      system "#{bin}/unionfs", "-o", "cow,max_files=32768,allow_other,use_ino,nonempty",
             "#{testpath}/t1=RW:#{testpath}/t2=RO", testpath/"t3"
      assert_match "test 2", pipe_output("cat #{testpath}/t3/test2.txt")
    ensure
      system "umount", "#{testpath}/t3"
    end
  end
end
