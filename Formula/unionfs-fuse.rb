require_relative "../require/macfuse"

class UnionfsFuse < Formula
  desc "Union filesystem using FUSE"
  homepage "https://github.com/rpodgorny/unionfs-fuse"
  url "https://github.com/rpodgorny/unionfs-fuse/archive/refs/tags/v3.6.tar.gz"
  sha256 "e6c9fac4e0f0ca82b3e515ca2c82c07dc51ed6da168c465c4b6f50c47bfeddd7"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "5a0c0f743d06d272dac36193370071247d72beb391f7d95f8445d5a86079a1c5"
    sha256 cellar: :any,                 ventura:      "053749fc797bf0ece88d571b7213d79082e112678a758c6e8ec6120f4e69a7d5"
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
