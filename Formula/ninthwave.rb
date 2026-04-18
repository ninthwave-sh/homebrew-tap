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
  version "0.4.6"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ninthwave-io/ninthwave/releases/download/v0.4.6/ninthwave-0.4.6-darwin-arm64.tar.gz"
      sha256 "19d52ac675d474a2beaa6bbeea27bc295b7003826e4d8533ab90afff5b38d33c"
    else
      url "https://github.com/ninthwave-io/ninthwave/releases/download/v0.4.6/ninthwave-0.4.6-darwin-x64.tar.gz"
      sha256 "38c8535ad7f0e399c06188c65435c169fbfc916a0c7ea4e994800ac509a89f58"
    end
  end

  on_linux do
    url "https://github.com/ninthwave-io/ninthwave/releases/download/v0.4.6/ninthwave-0.4.6-linux-x64.tar.gz"
    sha256 "10fa43f7f4af11e6c5a779bf3871aaae65ddb59257d9da126af2c574fcb80375"
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
