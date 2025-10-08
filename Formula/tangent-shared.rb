class TangentShared < Formula
  desc "The tangent-shared application"
  homepage "https://github.com/Santiago-Labs/tangent"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Santiago-Labs/tangent/releases/download/v0.1.0/tangent-shared-aarch64-apple-darwin.tar.xz"
      sha256 "e3a46a7fc9c6bd3e3aff09cc02f5295b1b03d97c0db0a80736453dccae0640f6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Santiago-Labs/tangent/releases/download/v0.1.0/tangent-shared-x86_64-apple-darwin.tar.xz"
      sha256 "95ce0bfd91a8639b72213cb99939f6a7153a6c676b31f6e7d2a09ed311697c0a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Santiago-Labs/tangent/releases/download/v0.1.0/tangent-shared-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "766903724e312bc577bbbfefa6b94fff2c86e1c9c6c107783a0207407ef52636"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Santiago-Labs/tangent/releases/download/v0.1.0/tangent-shared-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f9a18a4ffb69dcad8fdeb23d7027abefe967bb96eacce7a65d84a4ab78df02be"
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
    bin.install "core-cli" if OS.mac? && Hardware::CPU.arm?
    bin.install "core-cli" if OS.mac? && Hardware::CPU.intel?
    bin.install "core-cli" if OS.linux? && Hardware::CPU.arm?
    bin.install "core-cli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
