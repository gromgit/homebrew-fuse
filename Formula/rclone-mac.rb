require_relative "../require/macfuse"

class RcloneMac < Formula
  desc "Rsync for cloud storage (with macOS FUSE mount support)"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.55.1.tar.gz"
  sha256 "b8cbf769c8ed41c6e1dd74de78bf14ee7935ee436ee5ba018f742a48ee326f62"
  license "MIT"
  head "https://github.com/rclone/rclone.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/rclone-mac-1.55.1"
    sha256 cellar: :any_skip_relocation, big_sur: "99bad3844401b0b0ba443d16666670f0cc98f7d186215a4d5439bc7386aa4cea"
  end

  depends_on "go" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    system "go", "build",
      "-ldflags", "-s -X github.com/rclone/rclone/fs.Version=v#{version}",
      "-tags", "cmount", *std_go_args
    man1.install "rclone.1" => "#{name}.1"
    system bin/name.to_s, "genautocomplete", "bash", "#{name}.bash"
    system bin/name.to_s, "genautocomplete", "zsh", "_#{name}"
    inreplace "#{name}.bash" do |s|
      s.gsub! "commands=(\"rclone\")", "commands=(\"#{name}\")"
      s.gsub! /(-F __start_rclone) rclone$/, "\\1 #{name}"
    end
    inreplace "_#{name}", /(#compdef _rclone) rclone$/, "\\1 #{name}"
    bash_completion.install "#{name}.bash" => name.to_s
    zsh_completion.install "_#{name}"
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system bin/name.to_s, "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
