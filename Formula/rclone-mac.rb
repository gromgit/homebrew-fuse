require_relative "../require/macfuse"

class RcloneMac < Formula
  desc "Rsync for cloud storage (with macOS FUSE mount support)"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.61.1.tar.gz"
  sha256 "f9fb7bae1f19896351db64e3713b67bfd151c49b2b28e6c6233adf67dbc2c899"
  license "MIT"
  head "https://github.com/rclone/rclone.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/rclone-mac-1.61.1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56406f9b5505d6eb122299304869cc58298cbe870c9213cbf34b95ffb8428736"
    sha256 cellar: :any_skip_relocation, monterey:       "5405f344b42e07f0395bc72afb752116cb7fb8f584c9008ce67cdbb71c160a45"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d9a86811b7cf6217342a5ce2fba7dfd90b3223f248263cb16ede1e8f98c78bb"
    sha256 cellar: :any_skip_relocation, catalina:       "75628df5d08b32756f7f8b5c50b2717dd422c1e780c60426b324849786689225"
    sha256 cellar: :any_skip_relocation, mojave:         "8a2e69eec7079f63cdd008332eac174f3f843feb20f4744e28b618fb3155f809"
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
