require_relative "../require/macfuse"

class RcloneMac < Formula
  desc "Rsync for cloud storage (with macOS FUSE mount support)"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.60.0.tar.gz"
  sha256 "357ee8bb1c1589d9640f1eb87ffeb9dbe8bc7ea6f33f90f56df142515a32f4f2"
  license "MIT"
  head "https://github.com/rclone/rclone.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/rclone-mac-1.60.0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a0b4e4d87f6c492bce0f75783c88e94f390fe62399bdd85384d86592b3d506d"
    sha256 cellar: :any_skip_relocation, monterey:       "7efcd181a779b3ead3e4350966ef6176eda620de4f7103ea623d1615bfcf08bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "59d25e2659235fae87dd0baa52c9764902bd72da24a3c9bb14db49ec63880bc2"
    sha256 cellar: :any_skip_relocation, catalina:       "aaaf2a8ef8436960b72c6bed216fbbbdd67eae15c629a55cca2a950d4e569bc3"
    sha256 cellar: :any_skip_relocation, mojave:         "da00e610024ced7e0a5567343ff62cdae3623f37b8cd99008159d860bd0d166f"
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
