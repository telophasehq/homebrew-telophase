class TangentCli < Formula
  desc "The tangent-cli application"
  homepage "https://github.com/telophasehq/tangent"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.9/tangent-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7b13b8b6d73d2074914cc92223962c39c321a1e947cbb6259342989c575d264b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.9/tangent-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b85895bdd7972c0594f088525e9bad0fe287b0b08b1d260c2154b68c6fa6f353"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.9/tangent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eb0fc8112ba13eab16239762064a1814c72726f869c5deea987ae36a6d6c3284"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.9/tangent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5db7bdd6a758ac67828f026ed127f05eb6c0b8f9e0bdb0807a72dadd86e37c5f"
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
