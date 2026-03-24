# frozen_string_literal: true

# Homebrew formula for ninthwave — parallel AI coding session orchestrator.
class Ninthwave < Formula
  desc "Parallel AI coding session orchestrator"
  homepage "https://github.com/ninthwave-sh/ninthwave"
  url "https://github.com/ninthwave-sh/ninthwave/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "placeholder"
  license "MIT"
  head "https://github.com/ninthwave-sh/ninthwave.git", branch: "main"

  depends_on "oven-sh/bun/bun" => :build

  def install
    system "bun", "install", "--frozen-lockfile"
    system "bun", "build", "--compile", "core/cli.ts", "--outfile", "dist/ninthwave"

    libexec.install "dist/ninthwave" => "ninthwave"

    pkgshare.install "skills", "agents", "VERSION"
    (pkgshare/"docs").install "core/docs/todos-format.md"

    # Wrapper sets NINTHWAVE_HOME to the opt prefix so that symlinks created by
    # `ninthwave setup` survive `brew upgrade` (opt symlink is updated atomically).
    (bin/"ninthwave").write_env_script libexec/"ninthwave",
                                       NINTHWAVE_HOME: opt_pkgshare.to_s
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ninthwave version")
  end
end
