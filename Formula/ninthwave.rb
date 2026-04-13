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
  version "0.4.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ninthwave-io/ninthwave/releases/download/v0.4.3/ninthwave-0.4.3-darwin-arm64.tar.gz"
      sha256 "7a902b16548bb6bb7eaada860737a3174211d2c1c87200ff917f4c9eab7f8c28"
    else
      url "https://github.com/ninthwave-io/ninthwave/releases/download/v0.4.3/ninthwave-0.4.3-darwin-x64.tar.gz"
      sha256 "ee1c8f9d85d066140cb6cb28c5e349076c5396eaa3ae3da4f3264c4a7ac5fc07"
    end
  end

  on_linux do
    url "https://github.com/ninthwave-io/ninthwave/releases/download/v0.4.3/ninthwave-0.4.3-linux-x64.tar.gz"
    sha256 "4418a37fd65882091b5c44096a1547d69b27bf6204ea0d9a34e64de0f72f5a58"
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
