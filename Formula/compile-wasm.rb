class CompileWasm < Formula
  desc "The compile-wasm application"
  homepage "https://github.com/telophasehq/tangent"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.8/compile-wasm-aarch64-apple-darwin.tar.xz"
      sha256 "b3b0bf29bd95992841aefcadafb0aaac489786098c2c2ea6033dddb33c59ffd8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.8/compile-wasm-x86_64-apple-darwin.tar.xz"
      sha256 "1477ab5038ca9389701b82da6665c7a10ee7b1158a1905a7e9770e544b3a218b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.8/compile-wasm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dfb2ade27f5a51c8ce67440cfcf1fa3ddee9d1f7998a61df9bde409568d89079"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.8/compile-wasm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "72ab7724b86233c9495ec423b2874dc022d93ab0af947bea6ff390e0f181176a"
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
