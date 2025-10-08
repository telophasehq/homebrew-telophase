class TangentRuntime < Formula
  desc "The tangent-runtime application"
  homepage "https://github.com/Santiago-Labs/tangent"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Santiago-Labs/tangent/releases/download/v0.1.0/tangent-runtime-aarch64-apple-darwin.tar.xz"
      sha256 "f4871feb5ccf174c124bb71d0d24b59f8e3d5476f496a623f7036ef81f74a1eb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Santiago-Labs/tangent/releases/download/v0.1.0/tangent-runtime-x86_64-apple-darwin.tar.xz"
      sha256 "6ee69ab35c8e510f55daeb74d7619f8f27355d557ce029714d0b9bc67c56621e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Santiago-Labs/tangent/releases/download/v0.1.0/tangent-runtime-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "39548c4cf1b18cf1a06a2902a390a149b51bfaf8d6ec7eeb4553faba3b96dd9d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Santiago-Labs/tangent/releases/download/v0.1.0/tangent-runtime-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f21b27ffc63fa6d7bc8914520012508af8869ae9269ab20d9f16ca99a72102f8"
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
