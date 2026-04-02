# Homebrew formula for ninthwave.
#
# This is the template formula kept in-repo. The release workflow
# (.github/workflows/release.yml) substitutes version and SHA256 values,
# then pushes the result to the ninthwave-sh/homebrew-tap repository.
#
# Install: brew install ninthwave-sh/tap/ninthwave
# Update:  brew upgrade ninthwave

class Ninthwave < Formula
  desc "Parallel AI coding orchestration — human-sized PRs"
  homepage "https://github.com/ninthwave-sh/ninthwave"
  license "Apache-2.0"
  version "0.3.11"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ninthwave-sh/ninthwave/releases/download/v0.3.11/ninthwave-0.3.11-darwin-arm64.tar.gz"
      sha256 "9cfa25cb5c35bdc73d6a1c7a1e2b2a8cd3eeea2d72cdabad23393b8bf5dfd7cd"
    else
      url "https://github.com/ninthwave-sh/ninthwave/releases/download/v0.3.11/ninthwave-0.3.11-darwin-x64.tar.gz"
      sha256 "a79970784c0373b60e32d831b6e47d933712ec88d876794839b106344897e343"
    end
  end

  on_linux do
    url "https://github.com/ninthwave-sh/ninthwave/releases/download/v0.3.11/ninthwave-0.3.11-linux-x64.tar.gz"
    sha256 "93e2d90124e64f7d349cd438577257a7338b19c45ea265292f3fe03913b3ed3d"
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
