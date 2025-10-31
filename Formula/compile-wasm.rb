class CompileWasm < Formula
  desc "The compile-wasm application"
  homepage "https://github.com/telophasehq/tangent"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.7/compile-wasm-aarch64-apple-darwin.tar.xz"
      sha256 "06f912bf5c6561fa4a5c677783d6c413b3ad4f603849dad0b4f7b532701aade3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.7/compile-wasm-x86_64-apple-darwin.tar.xz"
      sha256 "822f9f7f0b3e70035349d888fbf961dd1ba9ab04641a21ed98380e97dbb368b3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.7/compile-wasm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dfd1e1b1a235ea22c9c9a1c5a69a02aa4ffbb29e2fa7b9ca04f7aafd495e967e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.7/compile-wasm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e68358b1781e9370254eb77071f8eae114bef8b78766557c6ea5bb5b9942f81d"
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
    bin.install "compile-wasm" if OS.mac? && Hardware::CPU.arm?
    bin.install "compile-wasm" if OS.mac? && Hardware::CPU.intel?
    bin.install "compile-wasm" if OS.linux? && Hardware::CPU.arm?
    bin.install "compile-wasm" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
