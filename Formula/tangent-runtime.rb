class TangentRuntime < Formula
  desc "The tangent-runtime application"
  homepage "https://github.com/EthanBlackburn/tangent"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EthanBlackburn/tangent/releases/download/v0.2.0/tangent-runtime-aarch64-apple-darwin.tar.xz"
      sha256 "2ceeb321e6803f4d6e58688d947bb3640ef0062db1e08e8d82e6b5935a9b42c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EthanBlackburn/tangent/releases/download/v0.2.0/tangent-runtime-x86_64-apple-darwin.tar.xz"
      sha256 "2f5a365c05e702f3baa8469989762c4f600515a2314b772d0f4b2de5716ec776"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/EthanBlackburn/tangent/releases/download/v0.2.0/tangent-runtime-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b94c6eeb3c98fffeedce63d27126bbd0e79c5ae72b930e4e9b90298e00842546"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EthanBlackburn/tangent/releases/download/v0.2.0/tangent-runtime-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "77de5a50691322879e92348d6a74e2cdc38558fca293f1e67b46489fa6f10286"
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
      bin.install "tangentd"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "tangentd"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "tangentd"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "tangentd"
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
