class TangentCli < Formula
  desc "The tangent-cli application"
  homepage "https://github.com/telophasehq/tangent"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.5/tangent-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4358d5e6e18d3b1260b92a121015b50b983e8ffc84f78c8c75884a56c02699ac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.5/tangent-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2a752897b736e014fbc60f0ea15d7614f4c6d76c6baae11fd670702ae423f22e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.5/tangent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "41b018ffce5a9a54a1835dc118c64fa42611ff58fb2e9cb4c41557f9c2373405"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.5/tangent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ac9e5c34f2bfa13b0340ed9c3bcc223441b7678459acc3c2d1eb736325c01d31"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "tangent" if OS.mac? && Hardware::CPU.arm?
    bin.install "tangent" if OS.mac? && Hardware::CPU.intel?
    bin.install "tangent" if OS.linux? && Hardware::CPU.arm?
    bin.install "tangent" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
