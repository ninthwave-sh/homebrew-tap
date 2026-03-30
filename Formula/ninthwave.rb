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
  version "0.3.5"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ninthwave-sh/ninthwave/releases/download/v0.3.5/ninthwave-0.3.5-darwin-arm64.tar.gz"
      sha256 "650dda08932bff47708a90732fc134b57b5d1b7df731255fd25c6d0de0315a41"
    else
      url "https://github.com/ninthwave-sh/ninthwave/releases/download/v0.3.5/ninthwave-0.3.5-darwin-x64.tar.gz"
      sha256 "2aba404c627ad4bbd5fae3111ffafcfc68c5cda8c69254f270e630018db7229a"
    end
  end

  on_linux do
    url "https://github.com/ninthwave-sh/ninthwave/releases/download/v0.3.5/ninthwave-0.3.5-linux-x64.tar.gz"
    sha256 "0649b806d412c59ccacf82a1cab6a7f8474c9d2eca5b4a1bd311685bd512d14d"
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
