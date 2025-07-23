require_relative "../require/macfuse"

class RatarmountMac < Formula
  include Language::Python::Virtualenv

  desc "Mount and efficiently access archives as filesystems"
  homepage "https://github.com/mxmlnkn/ratarmount"
  url "https://github.com/mxmlnkn/ratarmount/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "fc692adbefcd2d885d2fe758b7c2c429436af0ebbe67960b9d126930adaf48d6"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any, arm64_sonoma: "48ce1f9037b95ece449eefbfd39f8ed02c21592606108dcb4079e0b91eb40e87"
    sha256 cellar: :any, ventura:      "cf0502ac4e82d4d3afc2ad9713b71529e5161566623eb22ce0bdd437ecd6f36b"
  end

  depends_on "libgit2"
  depends_on MacfuseRequirement
  depends_on :macos
  depends_on "python@3.13"
  depends_on "zstd"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "fast-zip-decryption" do
    url "https://files.pythonhosted.org/packages/47/c8/0fbde8b9c8314e4fde35f4841015a6143967d5fd4d141e84a6cf14e62178/fast_zip_decryption-3.0.0.tar.gz"
    sha256 "5267e45aab72161b035ddc4dda4ffa2490b6da1ca752e4ff7eaedd4dd18aa85d"
  end

  resource "indexed-gzip" do
    url "https://files.pythonhosted.org/packages/e7/c4/54bb145774c8b1563308899580142dd17ff6da584ee8c8c6ee307733d14e/indexed_gzip-1.9.5.tar.gz"
    sha256 "105366567759db6c7df866d869611ded3bb83d5c0e50fbb01d02c1922b98b457"
  end

  resource "indexed-zstd" do
    url "https://files.pythonhosted.org/packages/52/22/5b908d5e987043ce8390b0d9101c93fae0c0de0c9c8417c562976eeb8be6/indexed_zstd-1.6.1.tar.gz"
    sha256 "8b74378f9461fceab175215b65e1c489864ddb34bd816058936a627f0cca3a8b"
  end

  resource "inflate64" do
    url "https://files.pythonhosted.org/packages/e3/a7/974e6daa6c353cf080b540c18f11840e81b36d18106963a0a857b1fc2adf/inflate64-1.0.3.tar.gz"
    sha256 "a89edd416c36eda0c3a5d32f31ff1555db2c5a3884aa8df95e8679f8203e12ee"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/26/23/e72434d5457c24113e0c22605cbf7dd806a2561294a335047f5aa8ddc1ca/libarchive_c-5.3.tar.gz"
    sha256 "5ddb42f1a245c927e7686545da77159859d5d4c6d00163c59daff4df314dae82"
  end

  resource "mfusepy" do
    url "https://files.pythonhosted.org/packages/39/09/b9a9e61ae0845c3de0249772dfee2294d269a7d644a9778bc42df97af6ae/mfusepy-1.1.1.tar.gz"
    sha256 "3647727a6e7775d47fdeff61355935f1ed5edb31c5124d233138f2a91ea01f9f"
  end

  resource "multivolumefile" do
    url "https://files.pythonhosted.org/packages/50/f0/a7786212b5a4cb9ba05ae84a2bbd11d1d0279523aea0424b6d981d652a14/multivolumefile-0.2.3.tar.gz"
    sha256 "a0648d0aafbc96e59198d5c17e9acad7eb531abea51035d08ce8060dcad709d6"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "py7zr" do
    url "https://files.pythonhosted.org/packages/97/62/d6f18967875aa60182198a0dd287d3a50d8aea1d844239ea00c016f7be88/py7zr-1.0.0.tar.gz"
    sha256 "f6bfee81637c9032f6a9f0eb045a4bfc7a7ff4138becfc42d7cb89b54ffbfef1"
  end

  resource "pybcj" do
    url "https://files.pythonhosted.org/packages/ce/75/bbcf098abf68081fa27c09d642790daa99d9156132c8b0893e3fecd946ab/pybcj-1.0.6.tar.gz"
    sha256 "70bbe2dc185993351955bfe8f61395038f96f5de92bb3a436acb01505781f8f2"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pyppmd" do
    url "https://files.pythonhosted.org/packages/f6/d7/b3084ff1ac6451ef7dd93d4f7627eeb121a3bed4f8a573a81978a43ddb06/pyppmd-1.2.0.tar.gz"
    sha256 "cc04af92f1d26831ec96963439dfb27c96467b5452b94436a6af696649a121fd"
  end

  resource "python-xz" do
    url "https://files.pythonhosted.org/packages/fe/2f/7ed0c25005eba0efb1cea3cdf4a325852d63167cc77f96b0a0534d19e712/python-xz-0.4.0.tar.gz"
    sha256 "398746593b706fa9fac59b8c988eab8603e1fe2ba9195111c0b45227a3a77db3"
  end

  resource "pyzstd" do
    url "https://files.pythonhosted.org/packages/8f/a2/54d860ccbd07e3c67e4d0321d1c29fc7963ac82cf801a078debfc4ef7c15/pyzstd-0.17.0.tar.gz"
    sha256 "d84271f8baa66c419204c1dd115a4dec8b266f8a2921da21b81764fa208c1db6"
  end

  resource "rapidgzip" do
    url "https://files.pythonhosted.org/packages/a6/b6/27975b6e7ec25c3fac16cbc73270954fb36ad239dda8b1f7bfb3f424dd2c/rapidgzip-0.14.5.tar.gz"
    sha256 "faed46013a1a62a5193c49615a896683ea5c14ed4744bcb4bd1869b1420551d8"
  end

  resource "rarfile" do
    url "https://files.pythonhosted.org/packages/26/3f/3118a797444e7e30e784921c4bfafb6500fb288a0c84cb8c32ed15853c16/rarfile-4.2.tar.gz"
    sha256 "8e1c8e72d0845ad2b32a47ab11a719bc2e41165ec101fd4d3fe9e92aa3f469ef"
  end

  resource "ratarmountcore" do
    url "https://files.pythonhosted.org/packages/7b/46/facff13ddb28a5b01fdb58fefbe1d287b4f41271b44d001622c4c25fcf4b/ratarmountcore-0.9.1.tar.gz"
    sha256 "c5fedc9985d616fca46ae97eaaf43e3da8d3b8542e506f7da19df580e05a97d5"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/1c/dc/0aff23d6036a4d3bf4f1d8c8204c5c79c4437e25e0ae94ffe4bbb55ee3c2/texttable-1.7.0.tar.gz"
    sha256 "2d2068fb55115807d3ac77a4ca68fa48803e84ebb0ee2340f858107a36522638"
  end

  def install
    setup_fuse
    virtualenv_install_with_resources
  end

  test do
    assert_match "ratarmount #{version}", shell_output("#{bin}/ratarmount --version 2>&1")
    tarball = test_fixtures("tarballs/testball2-0.1.tbz")
    assert_match "Operation not permitted", shell_output("#{bin}/ratarmount #{tarball} 2>&1", 1)
  end
end
