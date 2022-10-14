require_relative "../require/macfuse"

class RcloneMac < Formula
  desc "Rsync for cloud storage (with macOS FUSE mount support)"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.59.2.tar.gz"
  sha256 "ef263bbb8c05ddf9d9309a88cc3b5c928467179b71d3ba3b442bfeafb94ed24b"
  license "MIT"
  head "https://github.com/rclone/rclone.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/rclone-mac-1.59.2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d7defd1be44c2bbdb858d561bd53d3ed32845f62460f444eee0c8f62eebc6bb"
    sha256 cellar: :any_skip_relocation, monterey:       "cb24f9f5ab75ea77ad730a319d2651f3eb6cf12a72f928c8341761cca984ddb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "33b14a1abd80704f2a73265dc7d337880299476f008e698d1d21490c0ee4f3a4"
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
