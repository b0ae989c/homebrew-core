class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.4.10",
      revision: "bd6cd2555d1bb0e57a34ce74b0add36cb7fb6c76"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41c42f7acb808aa237ed6eee92377fca0fd9637dc01aa14c57f963e8ab4b8c5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bb0b3f33ec477eeef52f7b62168d13b8d7dfc87509d1567953deaadc55897d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7929006da7b3546bf72b789d56ec6643f4aa2160538c78796a84e3ddd31ea07"
    sha256 cellar: :any_skip_relocation, ventura:        "6e1ac7cdda22ec88248346bca7973927658b78d3a6102808811bdae1437666e5"
    sha256 cellar: :any_skip_relocation, monterey:       "4e764cb2b2d9e751874c69f5cf1364f904ce57cdaf66fd927004ab59fad22fa2"
    sha256 cellar: :any_skip_relocation, big_sur:        "4421e4e18a6238452204d4e14aa55f801fcd34e68b008688ecf56b15fc0369a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "391ff564eb41701ba1c6aa1426509e10a68a3dd55af3398a619f79c1c4d7c6d3"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo"
    bin.install "dist/argo"

    generate_completions_from_executable(bin/"argo", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "argo: v#{version}", shell_output("#{bin}/argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig ./kubeconfig 2>&1", 1)
  end
end
