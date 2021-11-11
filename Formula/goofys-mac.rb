require_relative "../require/macfuse"

class GoofysMac < Formula
  desc "Filey-System interface to Amazon S3"
  homepage "https://github.com/kahing/goofys"
  url "https://github.com/kahing/goofys.git",
      tag:      "v0.24.0",
      revision: "45b8d78375af1b24604439d2e60c567654bcdf88"
  license "Apache-2.0"
  head "https://github.com/kahing/goofys.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/goofys-mac-0.24.0"
    sha256 cellar: :any_skip_relocation, monterey: "0edf3be0d9fb22e7637e981539a5e93158d4543050a61afb5d11ce0ec80f0e17"
    sha256 cellar: :any_skip_relocation, big_sur:  "f3f73dc39927ee0a94a26a3bc8ae4b097e083d48e311b79274a85ac7f547e85a"
    sha256 cellar: :any_skip_relocation, catalina: "b61cf142b7a484520ad554d17947d7022ed0c3fdab04d6cf89da93b986d6de15"
    sha256 cellar: :any_skip_relocation, mojave:   "648d204e47b710662db2b778164346ef2b9fd77a4ec02af210fc8116eee7bb7f"
  end

  depends_on "go@1.14" => :build
  depends_on MacfuseRequirement
  depends_on :macos

  def install
    setup_fuse
    contents = Dir["*"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/kahing/goofys").install contents

    ENV["GOPATH"] = gopath

    goofys_version = build.head? ? Utils.git_head : version
    cd gopath/"src/github.com/kahing/goofys" do
      system "go", "build", *std_go_args,
        "-ldflags", "-X main.Version=#{goofys_version}",
        "-o", "#{bin}/goofys"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/goofys", "--version"
  end
end
