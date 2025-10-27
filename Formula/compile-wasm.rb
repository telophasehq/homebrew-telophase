class CompileWasm < Formula
  desc "The compile-wasm application"
  homepage "https://github.com/telophasehq/tangent"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.2/compile-wasm-aarch64-apple-darwin.tar.xz"
      sha256 "37acaf7578964eb2ed1dbb57493a58baca817b454ff5065a15600cbdbc65624c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.2/compile-wasm-x86_64-apple-darwin.tar.xz"
      sha256 "6c24870b2e0fa02b1b53b028c0256a2741de2455eaeb072bd496f8eeab672b33"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.2/compile-wasm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3247daf2d8a896fce75fa621b6439e24e205b118841c34990a51d3423b31326b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.2/compile-wasm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f7dad565abd84612aab72d5a1e7b8dc38efb923324360042f85910cd894168df"
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
