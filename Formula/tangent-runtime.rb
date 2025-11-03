class TangentRuntime < Formula
  desc "The tangent-runtime application"
  homepage "https://github.com/telophasehq/tangent"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.8/tangent-runtime-aarch64-apple-darwin.tar.xz"
      sha256 "5ec730e804a196d7da7efc13bb090e5fd824d0498e02bfd826dd2b80f4877597"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.8/tangent-runtime-x86_64-apple-darwin.tar.xz"
      sha256 "b8e0020b6ccc07f68ac7b5bddf13709ca3d01979e581a03ba8de3bc121c02276"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.8/tangent-runtime-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "67dc97668cc3c007d0fa333acb99c06cab10db398b691609c44e749dd0e6b3e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.8/tangent-runtime-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f35c948912dc245bc161914b4f357ec586ea43cce056d75180cbbd6d9ad45a84"
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
