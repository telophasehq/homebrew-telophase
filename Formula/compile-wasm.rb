class CompileWasm < Formula
  desc "The compile-wasm application"
  homepage "https://github.com/Santiago-Labs/tangent"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Santiago-Labs/tangent/releases/download/v0.1.0/compile-wasm-aarch64-apple-darwin.tar.xz"
      sha256 "6d12dce1f398cc13b6f011466e59958cb4664129493fcdf80248c2f2f73d2df1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Santiago-Labs/tangent/releases/download/v0.1.0/compile-wasm-x86_64-apple-darwin.tar.xz"
      sha256 "f26ba09bf4d3d02ab525a3ab5b3b2ff2881c86bdcf77d8309f5d5c01bf5c54c9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Santiago-Labs/tangent/releases/download/v0.1.0/compile-wasm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "938891ab327f4937222d8c533864900ad9536dbc7a15b7ee0a3fb75aef1578d8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Santiago-Labs/tangent/releases/download/v0.1.0/compile-wasm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "526b788a881b55e22eb851f70214a5db6b24e41d1a04a6e42a8a46e32de96b37"
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
