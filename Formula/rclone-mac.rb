require_relative "../require/macfuse"

class RcloneMac < Formula
  desc "Rsync for cloud storage (with macOS FUSE mount support)"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.59.1.tar.gz"
  sha256 "3eb56502c49ffe53da0360b66d5c9ee6147433f1a9b0238686c1743855cc891f"
  license "MIT"
  head "https://github.com/rclone/rclone.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/rclone-mac-1.59.1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e53d325873d6ad26303fd23ba4c14d793b70c703df056a0e4ba2226edb9041ca"
    sha256 cellar: :any_skip_relocation, monterey:       "4362bcdf29a86e5398227c90470215850fc77c375b8355241d6a4ed3bb7fd6db"
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
    inreplace "#{name}.bash" do |s|
      s.gsub! "commands=(\"rclone\")", "commands=(\"#{name}\")"
      s.gsub!(/(-F __start_rclone) rclone$/, "\\1 #{name}")
    end
    inreplace "_#{name}", /(#compdef _rclone) rclone$/, "\\1 #{name}"
    bash_completion.install "rclone.bash" => "rclone"
    bash_completion.install "#{name}.bash" => name.to_s
    zsh_completion.install "_rclone"
    zsh_completion.install "_#{name}"
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
