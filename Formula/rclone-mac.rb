require_relative "../require/macfuse"

class RcloneMac < Formula
  desc "Rsync for cloud storage (with macOS FUSE mount support)"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.60.1.tar.gz"
  sha256 "b0037124c04fd1c31a1d9ae1c80e25555da3a22d7ab1ae714ed2c02247fbdac5"
  license "MIT"
  head "https://github.com/rclone/rclone.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/rclone-mac-1.60.1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98dd82b6632d44325ac427a9ccf1bfe49c31c60032ce8a78734d87a52ab33929"
    sha256 cellar: :any_skip_relocation, monterey:       "7a1b854c0b20ed7eaced4c63477a7a6c92506ed49751577b0053f2431a69540d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4fe64af194d4543d96dd44e986e8c92b760df77947d787712f375d4a37c8510"
    sha256 cellar: :any_skip_relocation, catalina:       "bfc3c993f6f7cdd7d5942e43abc193c7d4cb3d6634e45bd16e5bb04a6fda6338"
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
