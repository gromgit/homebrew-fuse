require_relative "../require/macfuse"

class RcloneMac < Formula
  desc "Rsync for cloud storage (with macOS FUSE mount support)"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.62.2.tar.gz"
  sha256 "6741c81ae5b5cb48a04055f280f6e220ed4b35d26fe43f59510d0f7740044748"
  license "MIT"
  head "https://github.com/rclone/rclone.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/rclone-mac-1.62.2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83fd26fe9ac9fea9ce01c50e51e68e15de4d16486960a8260200a9305da5dfe7"
    sha256 cellar: :any_skip_relocation, monterey:       "eb442e32a816e0eb7293e8c6b41b63bcc85653b453660da412972665f35bcbb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9df31fc8adcb9e123cf8c9c9ee87ea878bd12053ba86eb7279ad35a863dbf5a"
  end

  depends_on "go" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    system "go", "build",
      "-ldflags", "-s -X github.com/rclone/rclone/fs.Version=v#{version}",
      "-tags", "cmount", *std_go_args
    (libexec/"rclone").install_symlink bin/name.to_s => "rclone"
    man1.install "rclone.1" => "#{name}.1"
    system bin/name.to_s, "genautocomplete", "bash", "rclone.bash"
    system bin/name.to_s, "genautocomplete", "bash", "#{name}.bash"
    system bin/name.to_s, "genautocomplete", "zsh", "_rclone"
    system bin/name.to_s, "genautocomplete", "zsh", "_#{name}"
    system bin/name.to_s, "genautocomplete", "fish", "rclone.fish"
    system bin/name.to_s, "genautocomplete", "fish", "#{name}.fish"
    bash_completion.install "rclone.bash" => "rclone"
    bash_completion.install "#{name}.bash" => name.to_s
    zsh_completion.install "_rclone"
    zsh_completion.install "_#{name}"
    fish_completion.install "rclone.fish" => "rclone"
    fish_completion.install "#{name}.fish" => name.to_s
  end

  def caveats
    <<~EOS
      The rclone binary has been installed as `#{name}`,
      to avoid conflict with the core `rclone` formula.
      If you need to use it as `rclone`, add the "rclone" directory
      to your PATH like:
        PATH="#{opt_libexec}/rclone:$PATH"
    EOS
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system bin/name.to_s, "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
    system opt_libexec/"rclone/rclone", "copy", testpath/"file1.txt", testpath/"dast"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dast/file1.txt")
  end
end
