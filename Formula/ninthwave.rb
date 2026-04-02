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
  version "0.3.10"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ninthwave-sh/ninthwave/releases/download/v0.3.10/ninthwave-0.3.10-darwin-arm64.tar.gz"
      sha256 "aa061e5cb7eebd6fea45f4fb9559aa38a11f2a51582d7bc17b64051d2def5de0"
    else
      url "https://github.com/ninthwave-sh/ninthwave/releases/download/v0.3.10/ninthwave-0.3.10-darwin-x64.tar.gz"
      sha256 "52790a62475becc79ff58dfca786efa0a0d06ae15c9c36d345142bf76af6a943"
    end
  end

  on_linux do
    url "https://github.com/ninthwave-sh/ninthwave/releases/download/v0.3.10/ninthwave-0.3.10-linux-x64.tar.gz"
    sha256 "9c970d6841f1d8127f9db36e47900653dddab534997afa54d0124611e63b9614"
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
