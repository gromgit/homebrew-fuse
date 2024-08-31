require_relative "../require/macfuse"

class UnionfsFuse < Formula
  desc "Union filesystem using FUSE"
  homepage "https://github.com/rpodgorny/unionfs-fuse"
  url "https://github.com/rpodgorny/unionfs-fuse/archive/refs/tags/v3.5.tar.gz"
  sha256 "d33bddea64d4974387a8c88292f5a8424bac5da1cf8b7f4f394c803305de73f3"
  license "BSD-3-Clause"


  depends_on MacfuseRequirement
  depends_on "pkg-config"

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
