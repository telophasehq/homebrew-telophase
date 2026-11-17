class CompileWasm < Formula
  desc "The compile-wasm application"
  homepage "https://github.com/EthanBlackburn/tangent"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EthanBlackburn/tangent/releases/download/v0.2.0/compile-wasm-aarch64-apple-darwin.tar.xz"
      sha256 "662a9c297bd16c00b044a535e1e886af0d719052c94f5f3720c14c99596b442f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EthanBlackburn/tangent/releases/download/v0.2.0/compile-wasm-x86_64-apple-darwin.tar.xz"
      sha256 "bbd83595107c894d38f26404091daebf48b593f604a6bd3a22b314cf2c2b8911"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/EthanBlackburn/tangent/releases/download/v0.2.0/compile-wasm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6143a49fe31780f1f5f702c4811a3b7a243f3ebcc4ac3b8d55e2706d56ba2796"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EthanBlackburn/tangent/releases/download/v0.2.0/compile-wasm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b91e2bc5e82b477c0e92092c63a7abf51b813410e0c953766bb6d565d4e9d08c"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "compile-wasm"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "compile-wasm"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "compile-wasm"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "compile-wasm"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
