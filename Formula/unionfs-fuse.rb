require_relative "../require/macfuse"

class UnionfsFuse < Formula
  desc "Union filesystem using FUSE"
  homepage "https://github.com/rpodgorny/unionfs-fuse"
  url "https://github.com/rpodgorny/unionfs-fuse/archive/refs/tags/v3.6.tar.gz"
  sha256 "e6c9fac4e0f0ca82b3e515ca2c82c07dc51ed6da168c465c4b6f50c47bfeddd7"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/unionfs-fuse-2.2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0bf63f52a20a6ff3703b0225243c35837d620696c261208e7e2256050c486fb"
    sha256 cellar: :any,                 monterey:       "5325c885b86d7da9a263b0dccb5f40fa0b59b431bf8d9c5efb48d8b3cd043dc6"
    sha256 cellar: :any,                 big_sur:        "4ce1e7bf69c4d4b47af623ace7a33f2ff467e3a944181e910e8ae81e27d1db80"
    sha256 cellar: :any,                 catalina:       "a1961f1ecf7bfb8f6ce0af19ff3f1529986da999da813551bd58b6023e7f5a3f"
    sha256 cellar: :any,                 mojave:         "0042e85328d5f2a83db5673882579fc4a71bc96148f165ad93d571fb7dbec988"
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
