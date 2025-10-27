class CompileWasm < Formula
  desc "The compile-wasm application"
  homepage "https://github.com/telophasehq/tangent"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.3/compile-wasm-aarch64-apple-darwin.tar.xz"
      sha256 "684b1c29bfeffe688d4bc2dfc7bf403df6757e612fbfec6d8b15b493501bb593"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.3/compile-wasm-x86_64-apple-darwin.tar.xz"
      sha256 "ff96eced09f9200a2167931e93736c2472b90d398ac3f324ba3faff2884095be"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.3/compile-wasm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "25235911ffb99ac68ed0dcbc990366c2b67f8c4a5aa42298d957d05b8e7e52a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.3/compile-wasm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "64e17f5af63d008d51ccfcfec7ba41ec443c6bced78e6456e25499c145f1b53c"
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
