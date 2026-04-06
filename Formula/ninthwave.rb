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
  version "0.4.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ninthwave-sh/ninthwave/releases/download/v0.4.1/ninthwave-0.4.1-darwin-arm64.tar.gz"
      sha256 "1beac1575fab0900a5859c36f9903ca7a933ec799beee54d967c6ca5d8abe234"
    else
      url "https://github.com/ninthwave-sh/ninthwave/releases/download/v0.4.1/ninthwave-0.4.1-darwin-x64.tar.gz"
      sha256 "c16bf53d53ee54c0dbabb407972dbeefb11e62f2011732781ff5983a9b552b6a"
    end
  end

  on_linux do
    url "https://github.com/ninthwave-sh/ninthwave/releases/download/v0.4.1/ninthwave-0.4.1-linux-x64.tar.gz"
    sha256 "9198a105a328f83b0a6e0ae8d178dc1d006b8b7fb086eca84e646304a8243de3"
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
