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
  version "0.3.7"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ninthwave-sh/ninthwave/releases/download/v0.3.7/ninthwave-0.3.7-darwin-arm64.tar.gz"
      sha256 "828436ef96b5dca2f9eb3778a81fcd84786474798fd7f159d97c61b33f24afd4"
    else
      url "https://github.com/ninthwave-sh/ninthwave/releases/download/v0.3.7/ninthwave-0.3.7-darwin-x64.tar.gz"
      sha256 "668ea132bc88b5f51e09cd7dd4093e1e0ea2dd3e5c084defb31dd1149228105e"
    end
  end

  on_linux do
    url "https://github.com/ninthwave-sh/ninthwave/releases/download/v0.3.7/ninthwave-0.3.7-linux-x64.tar.gz"
    sha256 "1e9d88c274a7233bd37eca298310e11f8005478286ea17749296ac93b241cd4b"
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
