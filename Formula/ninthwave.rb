# Homebrew formula for ninthwave.
#
# This is the template formula kept in-repo. The release workflow
# (.github/workflows/release.yml) substitutes version and SHA256 values,
# then pushes the result to the ninthwave-io/homebrew-tap repository.
#
# Install: brew install ninthwave-io/tap/ninthwave
# Update:  brew upgrade ninthwave

class Ninthwave < Formula
  desc "Parallel AI coding orchestration — human-sized PRs"
  homepage "https://github.com/ninthwave-io/ninthwave"
  license "Apache-2.0"
  version "0.4.5"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ninthwave-io/ninthwave/releases/download/v0.4.5/ninthwave-0.4.5-darwin-arm64.tar.gz"
      sha256 "ef4643ef66c6263540daf3b7057ce75d386e5555f9d3cd6e3fbdb07af820592c"
    else
      url "https://github.com/ninthwave-io/ninthwave/releases/download/v0.4.5/ninthwave-0.4.5-darwin-x64.tar.gz"
      sha256 "a1fd6e3d00f1ebc965248586819cf210fa1549a117110bc29834ccf3dff1794a"
    end
  end

  on_linux do
    url "https://github.com/ninthwave-io/ninthwave/releases/download/v0.4.5/ninthwave-0.4.5-linux-x64.tar.gz"
    sha256 "aff01e97261c82a26adfb22fa463023ba26e87048bc19db4bd5f084eded23d02"
  end

  def install
    bin.install "ninthwave"
    # Short alias: `nw` is the daily-driver command (2 chars, no conflicts).
    bin.install_symlink "ninthwave" => "nw"

    # Resource files (skills, agents, templates, docs) used by `nw init`.
    # Install everything except the binary — future-proof as new resources are added.
    (share/"ninthwave").install Dir["*"] - ["ninthwave"]
  end

  def caveats
    <<~EOS
      ninthwave requires cmux for parallel sessions.
        Install: brew install --cask manaflow-ai/cmux/cmux
        Or download from: https://cmux.com

      Run `nw doctor` to verify your setup.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ninthwave version")
    # Verify nw symlink works
    assert_match version.to_s, shell_output("#{bin}/nw version")
    # Verify resource files are discoverable (BUNDLE_MARKER)
    assert_predicate share/"ninthwave/skills/decompose/SKILL.md", :exist?
    assert_predicate share/"ninthwave/VERSION", :exist?
  end
end
