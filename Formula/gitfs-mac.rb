require_relative "../require/macfuse"

class GitfsMac < Formula
  include Language::Python::Virtualenv

  desc "Version controlled file system"
  homepage "https://www.presslabs.com/gitfs"
  url "https://github.com/vtemian/gitfs/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "75835c6e4cad400c06e86ecb2efedfa7a8ffe5c5939c4e70040f6e861b4e85d3"
  license "Apache-2.0"
  head "https://github.com/vtemian/gitfs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_sequoia: "e48dd7b94f4ff6bbec3b51fa4c607a04bdb2338267315d3da988c1d9f6254bd5"
    sha256 cellar: :any, arm64_sonoma:  "903d6859b1d8cb7d0fa54ee4294e6bd3c57d796495b4850ba4cb50b6c5bf7d63"
  end

  depends_on "libgit2"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "atomiclong" do
    url "https://files.pythonhosted.org/packages/86/8c/70aea8215c6ab990f2d91e7ec171787a41b7fbc83df32a067ba5d7f3324f/atomiclong-0.1.1.tar.gz"
    sha256 "cb1378c4cd676d6f243641c50e277504abf45f70f1ea76e446efcdbb69624bbe"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/73/f7/f14b46d4bcd21092d7d3ccef689615220d8a08fb25e564b65d20738e672e/certifi-2025.6.15.tar.gz"
    sha256 "d747aa5a8b9bbbb1bb8c22bb13e22bd1f18e9796defa16bab421f7f7a317323b"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/fc/97/c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90d/cffi-1.17.1.tar.gz"
    sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
  end

  resource "mfusepy" do
    url "https://files.pythonhosted.org/packages/1c/94/c9d5dcba4a6a2b32ba23e22fd13ca08e6f5408420b2dfe42984af22277b6/mfusepy-3.0.0.tar.gz"
    sha256 "eddade33e427bac9c455464cd0a7d12d63c033255ec6b1e0d6ada143a945c6f2"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/c1/4a/72a5f3572912d93d8096f8447a20fe3aff5b5dc65aca08a2083eae54d148/pygit2-1.18.0.tar.gz"
    sha256 "fbd01d04a4d2ce289aaa02cf858043679bf0dd1f9855c6b88ed95382c1f5011a"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/04/4c/af31e0201b48469786ddeb1bf6fd3dfa3a291cc613a0fe6a60163a7535f9/sentry_sdk-2.30.0.tar.gz"
    sha256 "436369b02afef7430efb10300a344fb61a11fe6db41c2b11f41ee037d2dd7f45"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      gitfs clones repos in /var/lib/gitfs. You can either create it with
      sudo mkdir -m 1777 /var/lib/gitfs or use another folder with the
      repo_path argument.
    EOS
  end

  test do
    xy = Language::Python.major_minor_version Formula["python@3.13"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    (testpath/"test.py").write <<~EOS
      import gitfs
      import pygit2
      pygit2.init_repository('testing/.git', True)
    EOS

    system Formula["python@3.13"].opt_bin/"python3", "test.py"
    assert_path_exists testpath/"testing/.git/config"
    cd "testing" do
      system "git", "remote", "add", "homebrew", "https://github.com/Homebrew/homebrew-core.git"
      assert_match "homebrew", shell_output("git remote")
    end
  end
end
