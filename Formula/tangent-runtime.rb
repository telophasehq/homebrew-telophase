class TangentRuntime < Formula
  desc "The tangent-runtime application"
  homepage "https://github.com/telophasehq/tangent"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.3/tangent-runtime-aarch64-apple-darwin.tar.xz"
      sha256 "9dd99247aabc3276e63227e77b807dbbad45f10be0feda068a431ac982d50060"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.3/tangent-runtime-x86_64-apple-darwin.tar.xz"
      sha256 "db830366e4643c717e1730ce80d28d7783e5da014c7a8ef0260782123ee5f9de"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.3/tangent-runtime-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "86256e18e1d42c424e8ccadfc2d0f56bfd4822adbaf50f369b3e4ca248cd7c2f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.3/tangent-runtime-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "225f4553f5b1f1edd0a12d0d3317b8e0c228d1530a23fd221cb2dd9cb135f8dd"
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
