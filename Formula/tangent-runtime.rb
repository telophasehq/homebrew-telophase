class TangentRuntime < Formula
  desc "The tangent-runtime application"
  homepage "https://github.com/telophasehq/tangent"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.4/tangent-runtime-aarch64-apple-darwin.tar.xz"
      sha256 "d1f22f56d8ea74b27eb3dae400d0a52c68f036072dee3357ddacc1275eeab0e5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.4/tangent-runtime-x86_64-apple-darwin.tar.xz"
      sha256 "3640276692b8e6f2a1ffec8293b3a725fc5f0149f5c7e31fb32aa226dbca15bb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.4/tangent-runtime-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3c5a3c6cbfe4b3a4699d125bbcb27d19fbeec4a45633e59202f0a781ef5d2978"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.4/tangent-runtime-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "01e54b2478367f7dd3cd3c23a780ab499c4e9417b41559e20129b566fe425d0b"
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
    bin.install "tangentd" if OS.mac? && Hardware::CPU.arm?
    bin.install "tangentd" if OS.mac? && Hardware::CPU.intel?
    bin.install "tangentd" if OS.linux? && Hardware::CPU.arm?
    bin.install "tangentd" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
