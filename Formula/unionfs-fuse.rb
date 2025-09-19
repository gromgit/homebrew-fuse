require_relative "../require/macfuse"

class UnionfsFuse < Formula
  desc "Union filesystem using FUSE"
  homepage "https://github.com/rpodgorny/unionfs-fuse"
  url "https://github.com/rpodgorny/unionfs-fuse/archive/refs/tags/v3.7.tar.gz"
  sha256 "026f5302279110ceb7465e5c9e863cd0319ea0dc32ad253d162cf9db0f5e9a81"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd96797c922e35716d4bf81b585eccff801f33d416177b3c1f64408cf9049095"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66afec09b9d1ec0d1549a8afe97a0fa6f1f65374c9e42898655f6ad9d718c02c"
    sha256 cellar: :any_skip_relocation, ventura:       "c10761c0cb52fbaa60425a8e5c3a58cc0ae7868c33943a02c9006bdcb60f8f78"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on MacfuseRequirement

  def install
    setup_fuse
    inreplace "CMakeLists.txt", "/usr/local", alt_fuse_root.to_s
    mkdir "build" do
      system "cmake", "..",
        "-DCMAKE_C_COMPILER=clang",
        "-DCMAKE_C_FLAGS=-std=gnu99",
        *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unionfs --version 2>&1")
    # TODO: fix test
    # (testpath/"t1").mkdir
    # (testpath/"t1/test1.txt").write <<~EOS
    #  This is test 1.
    # EOS
    # (testpath/"t2").mkdir
    # (testpath/"t2/test2.txt").write <<~EOS
    #  This is test 2.
    # EOS
    # (testpath/"t3").mkdir
    # begin
    #  system "#{bin}/unionfs", "-o", "cow,max_files=32768,allow_other,use_ino,nonempty",
    #         "#{testpath}/t1=RW:#{testpath}/t2=RO", testpath/"t3"
    #  assert_match "test 2", pipe_output("cat #{testpath}/t3/test2.txt")
    # ensure
    #  system "umount", "#{testpath}/t3"
    # end
  end
end
