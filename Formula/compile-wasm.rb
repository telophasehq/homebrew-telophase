class CompileWasm < Formula
  desc "The compile-wasm application"
  homepage "https://github.com/telophasehq/tangent"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.0/compile-wasm-aarch64-apple-darwin.tar.xz"
      sha256 "ad56456157b24c447c1fd8c92cf52a62a71b20ab06518d3747b32ef8527f4dff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.0/compile-wasm-x86_64-apple-darwin.tar.xz"
      sha256 "e6d62e37236a43a7bf0d16afdc0b9c1293a43c7b657c7810e3539074613dd36c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.0/compile-wasm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0c0f800fbe59d7239dd616d4199848de58c25c1d3970d8dd720c192dd46a006a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.0/compile-wasm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6eced5121267b2ffc2ff322f131347d100440a360e674f342441015ee14fd853"
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
