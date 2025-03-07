require_relative "../require/macfuse"

class GitfsMac < Formula
  include Language::Python::Virtualenv

  desc "Version controlled file system"
  homepage "https://www.presslabs.com/gitfs"
  url "https://github.com/presslabs/gitfs/archive/refs/tags/0.5.2.tar.gz"
  sha256 "921e24311e3b8ea3a5448d698a11a747618ee8dd62d5d43a85801de0b111cbf3"
  license "Apache-2.0"
  revision 1
  head "https://github.com/presslabs/gitfs.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-fuse/releases/download/gitfs-mac-0.5.2"
    sha256 cellar: :any, arm64_monterey: "5aa42d1f875f89f6860de825ba6f522435e9e78361b3eddc3b32799d3c5aa498"
    sha256 cellar: :any, monterey:       "ba780fac3f0470ed7e5a01f2bd1b0df66918bd50eac1b58e8373e3e0dc52974d"
    sha256 cellar: :any, big_sur:        "e0086949aa4b8e18713a50cacb8bf2f1f73dba28e6523273b53856da35ea9dc7"
    sha256 cellar: :any, catalina:       "aa14fd52fbd30a3d46fd57ec011ad73fefabc3350c5b962c10c71961bc9f7265"
    sha256 cellar: :any, mojave:         "7d0605b4d2d6022c607ae6dfbdf87ae984b2f73bbe43e35cddf60fef0b79d3dc"
  end

  # Last release on 2019-10-20 and upstream has locked pygit2==0.28.2, which Homebrew
  # has been ignoring and manually updating to support recent `libgit2` versions.
  disable! date: "2023-10-06", because: :unmaintained

  depends_on "libgit2"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "python@3.9"

  uses_from_macos "libffi"

  resource "atomiclong" do
    url "https://files.pythonhosted.org/packages/86/8c/70aea8215c6ab990f2d91e7ec171787a41b7fbc83df32a067ba5d7f3324f/atomiclong-0.1.1.tar.gz"
    sha256 "cb1378c4cd676d6f243641c50e277504abf45f70f1ea76e446efcdbb69624bbe"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/57/8e/0698e10350a57d46b3bcfe8eff1d4181642fd1724073336079cb13c5cf7f/cached-property-1.5.1.tar.gz"
    sha256 "9217a59f14a5682da7c4b8829deadbfc194ac22e9908ccf7c8820234e80a1504"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/66/6a/98e023b3d11537a5521902ac6b50db470c826c682be6a8c661549cb7717a/cffi-1.14.4.tar.gz"
    sha256 "1a465cbe98a7fd391d47dce4b8f7e5b921e6cd805ef421d04f5f66ba8f06086c"
  end

  resource "fusepy" do
    url "https://files.pythonhosted.org/packages/04/0b/4506cb2e831cea4b0214d3625430e921faaa05a7fb520458c75a2dbd2152/fusepy-3.0.1.tar.gz"
    sha256 "72ff783ec2f43de3ab394e3f7457605bf04c8cf288a2f4068b4cde141d4ee6bd"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/6b/23/a8c5b726a58282fe2cadcc63faaddd4be147c3c8e0bd38b233114adf98fd/pygit2-1.6.1.tar.gz"
    sha256 "c3303776f774d3e0115c1c4f6e1fc35470d15f113a7ae9401a0b90acfa1661ac"

    # libgit2 1.3 support
    # https://github.com/libgit2/pygit2/pull/1089
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/54d3a0d1f241fdd4e9229312ced0d8da85d964b1/pygit2/libgit2-1.3.0.patch"
      sha256 "4d501c09d6642d50d89a1a4d691980e3a4a2ebcb6de7b45d22cce16a451b9839"
    end
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "raven" do
    url "https://files.pythonhosted.org/packages/79/57/b74a86d74f96b224a477316d418389af9738ba7a63c829477e7a86dd6f47/raven-6.10.0.tar.gz"
    sha256 "3fa6de6efa2493a7c827472e984ce9b020797d0da16f1db67197bcc23c8fae54"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  # pygit2 1.6.1 support
  # https://github.com/presslabs/gitfs/pull/379
  patch :DATA

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
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    (testpath/"test.py").write <<~EOS
      import gitfs
      import pygit2
      pygit2.init_repository('testing/.git', True)
    EOS

    system Formula["python@3.9"].opt_bin/"python3", "test.py"
    assert_path_exists testpath/"testing/.git/config"
    cd "testing" do
      system "git", "remote", "add", "homebrew", "https://github.com/Homebrew/homebrew-core.git"
      assert_match "homebrew", shell_output("git remote")
    end
  end
end
__END__
diff --git a/gitfs/mounter.py b/gitfs/mounter.py
index 31b436d..391e899 100644
--- a/gitfs/mounter.py
+++ b/gitfs/mounter.py
@@ -19,7 +19,7 @@ import resource
 
 from fuse import FUSE
 from pygit2 import Keypair, UserPass
-from pygit2.remote import RemoteCallbacks
+from pygit2.callbacks import RemoteCallbacks
 
 from gitfs import __version__
 from gitfs.utils import Args
diff --git a/requirements.txt b/requirements.txt
index fb7d0f3..42c4d1f 100644
--- a/requirements.txt
+++ b/requirements.txt
@@ -2,6 +2,6 @@ atomiclong==0.1.1
 cffi==1.12.3
 fusepy==3.0.1
 pycparser==2.19
-pygit2==0.28.2
+pygit2==1.16.1
 raven==6.10.0
 six==1.12.0
