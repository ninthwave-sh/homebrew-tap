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
  version "0.3.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ninthwave-sh/ninthwave/releases/download/v0.3.2/ninthwave-0.3.2-darwin-arm64.tar.gz"
      sha256 "46ed91365fb751c9a1e4518b3a75081a987271cc90fa6a700fd1ea0bced0a3b5"
    else
      url "https://github.com/ninthwave-sh/ninthwave/releases/download/v0.3.2/ninthwave-0.3.2-darwin-x64.tar.gz"
      sha256 "74ebc164279a49bd070a6b4b85dab9d454c68a685a3b30306dd5cfea97d72839"
    end
  end

  on_linux do
    url "https://github.com/ninthwave-sh/ninthwave/releases/download/v0.3.2/ninthwave-0.3.2-linux-x64.tar.gz"
    sha256 "fd8abe1434c525a0514f1a859c244f1d0b59bbd2687769c93b084cd3d189e39a"
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
    assert_predicate share/"ninthwave/skills/work/SKILL.md", :exist?
    assert_predicate share/"ninthwave/VERSION", :exist?
  end
end
