class LinodeCli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Linode API"
  homepage "https://www.linode.com/products/cli/"
  url "https://files.pythonhosted.org/packages/37/01/2e1cfb6b008696d47e21a5f35298484988a2f3900985aeb4409cb557b302/linode-cli-5.44.0.tar.gz"
  sha256 "3c6882de9abad950491218c7c2aa900db4493e12c1c1896b98a2aaa1d2b9f56d"
  license "BSD-3-Clause"
  head "https://github.com/linode/linode-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0266c21338939440ce96f03163bcea9c9b2b627cf346c1e97d41762d707d134"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90ae49f2a78287d3860cdde3e6af62d88ca1c10bd8f1b898c0119c9f209c4f06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9672f4f5cda1c593066ac5ee6fb68cbb44447601691408fbfa29acd7acf57e50"
    sha256 cellar: :any_skip_relocation, ventura:        "2f9c8e7a488f39b1cf8587ac36784c48886301f622374cf168cce1062006177c"
    sha256 cellar: :any_skip_relocation, monterey:       "49f73dec6d568b401eeeebb8f69ec2a528f29876e167e4af9a6063d4e6a7dd19"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c8430edddba42074b372f794f03ae393f949757034b399c663404ac71deb1fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47183ae697b89514a470fa5d41cde5ed97a7cc17e82a789c2eae07adcd2f9588"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "linode-api-spec" do
    url "https://raw.githubusercontent.com/linode/linode-api-docs/refs/tags/v4.163.0/openapi.yaml"
    sha256 "089aad460d3e0ba3cf7abfbcdc411707ab04977e06d48f6ea19e91dca91369c4"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "openapi3" do
    url "https://files.pythonhosted.org/packages/94/0a/e7862c7870926ecb86d887923e36b7853480a2a97430162df1b972bd9d5b/openapi3-1.8.2.tar.gz"
    sha256 "a21a490573d89ca69ada7cbe585adb2fca4964257f6f3a1df531f12815455d2c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/1d/d6/9773d48804d085962c4f522db96f6a9ea9bd2e0480b3959a929176d92f01/rich-13.5.3.tar.gz"
    sha256 "87b43e0543149efa1253f485cd845bb7ee54df16c9617b8a893650ab84b4acb6"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources.reject { |r| r.name == "linode-api-spec" }
    buildpath.install resource("linode-api-spec")

    # The bake command creates a pickled version of the linode-cli OpenAPI spec
    system libexec/"bin/python3", "-m", "linodecli", "bake", "./openapi.yaml", "--skip-config"
    # Distribute the pickled spec object with the module
    cp "data-3", "linodecli"

    inreplace "setup.py" do |s|
      s.gsub! "version=version,", "version='#{version}',"
      # Prevent setup.py from installing the bash_completion script
      s.gsub! "data_files=get_baked_files(),", ""
    end

    bash_completion.install "linode-cli.sh" => "linode-cli"

    venv.pip_install_and_link buildpath
  end

  test do
    require "securerandom"
    random_token = SecureRandom.hex(32)
    with_env(
      LINODE_CLI_TOKEN: random_token,
    ) do
      json_text = shell_output("#{bin}/linode-cli regions view --json us-east")
      region = JSON.parse(json_text)[0]
      assert_equal region["id"], "us-east"
      assert_equal region["country"], "us"
    end
  end
end
