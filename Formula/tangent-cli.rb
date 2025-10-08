class TangentCli < Formula
  desc "The tangent-cli application"
  homepage "https://github.com/Santiago-Labs/tangent"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Santiago-Labs/tangent/releases/download/v0.1.0/tangent-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c69cb1ef18b1067fef74bb32cfbb7cca75d7a267b461b04c637ed3b728d94856"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Santiago-Labs/tangent/releases/download/v0.1.0/tangent-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c8a60f59a295a19253a61e2939fbf0da986b99a9c72ad558c83cfc0ba6a43f99"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Santiago-Labs/tangent/releases/download/v0.1.0/tangent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4266666a36ce41cded30176d7aa1a026bc5592c9e72f0e2f4e366c1ca49d0c4e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Santiago-Labs/tangent/releases/download/v0.1.0/tangent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "49323223c4bfbfc0b107ef520e614fea76b6a4733952f84d2292a377f84edff7"
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
    bin.install "tangent" if OS.mac? && Hardware::CPU.arm?
    bin.install "tangent" if OS.mac? && Hardware::CPU.intel?
    bin.install "tangent" if OS.linux? && Hardware::CPU.arm?
    bin.install "tangent" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
