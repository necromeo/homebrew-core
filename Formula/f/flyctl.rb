class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.93",
      revision: "0a198d277fa3de01bc2334b493ae6bb674e11d55"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d18b6e978a92f6be68a354c7ad144b5db352bec09702d66824cc1163e3ce20be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d18b6e978a92f6be68a354c7ad144b5db352bec09702d66824cc1163e3ce20be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d18b6e978a92f6be68a354c7ad144b5db352bec09702d66824cc1163e3ce20be"
    sha256 cellar: :any_skip_relocation, ventura:        "fa38e347f733cb7dfeec9651d98bf8a591f5387703d6487e6c003728af161258"
    sha256 cellar: :any_skip_relocation, monterey:       "fa38e347f733cb7dfeec9651d98bf8a591f5387703d6487e6c003728af161258"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa38e347f733cb7dfeec9651d98bf8a591f5387703d6487e6c003728af161258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db26d5070c51d38f6c51162f41e57389b91cbff922088fda49ddf08b24d7a7c4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
