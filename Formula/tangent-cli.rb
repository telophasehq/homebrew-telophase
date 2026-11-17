class TangentCli < Formula
  desc "The tangent-cli application"
  homepage "https://github.com/EthanBlackburn/tangent"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EthanBlackburn/tangent/releases/download/v0.2.0/tangent-cli-aarch64-apple-darwin.tar.xz"
      sha256 "934fcda898bed184033bac59a558679f1432cf75ec884aa2ffac0d4ea35187e0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EthanBlackburn/tangent/releases/download/v0.2.0/tangent-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8631c22d95a08e7ac9dca670f7d8fc71181840117cbd3096a8463a1da423555a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/EthanBlackburn/tangent/releases/download/v0.2.0/tangent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3e594a17b85117f21053187b44cc39241a4923860c95f72cb9c0784a40ed7c75"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EthanBlackburn/tangent/releases/download/v0.2.0/tangent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "de69e18818875eacf3626bd69f21f8c4d6afd539b6a69c12b488c3230c352780"
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
      bin.install "tangent"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "tangent"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "tangent"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "tangent"
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
