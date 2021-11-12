require_relative "../require/macfuse"

class UnionfsFuse < Formula
  desc "Union filesystem using FUSE"
  homepage "https://github.com/rpodgorny/unionfs-fuse"
  url "https://github.com/rpodgorny/unionfs-fuse/archive/refs/tags/v2.1.tar.gz"
  sha256 "c705072a33a18cbc73ffe799331d43410b6deef5d6f2042038f8fd3ab17b6e2e"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/unionfs-fuse-2.1"
    sha256 cellar: :any, monterey: "0c1c5cd2c5fba1a924e5cf6f9b1435cb8920c48eb87d6b7f434829dc19064227"
  end

  depends_on MacfuseRequirement

  def install
    setup_fuse
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
      system "umount #{testpath}/t3"
    end
  end
end
