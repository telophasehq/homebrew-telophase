class TangentShared < Formula
  desc "The tangent-shared application"
  homepage "https://github.com/EthanBlackburn/tangent"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EthanBlackburn/tangent/releases/download/v0.2.0/tangent-shared-aarch64-apple-darwin.tar.xz"
      sha256 "cfe5e652071a9d75cb6975d014b473fdafc5f9f0f11d97624ff9d2d2f913da08"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EthanBlackburn/tangent/releases/download/v0.2.0/tangent-shared-x86_64-apple-darwin.tar.xz"
      sha256 "8f72a757e2e2da4e02d81c8b54ed175101f3c79df567599be0fd4f4e38da3f64"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/EthanBlackburn/tangent/releases/download/v0.2.0/tangent-shared-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3ec1d6f0762891196638433bda2490503781f61ec6564eea6ce27daf9e305f6e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EthanBlackburn/tangent/releases/download/v0.2.0/tangent-shared-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a5cef296aa2193d8738a9c8fbdf330fab6d63ac781c841bc9810abd6f1212de5"
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
      bin.install "shared-cli"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "shared-cli"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "shared-cli"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "shared-cli"
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
