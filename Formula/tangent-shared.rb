class TangentShared < Formula
  desc "The tangent-shared application"
  homepage "https://github.com/telophasehq/tangent"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.9/tangent-shared-aarch64-apple-darwin.tar.xz"
      sha256 "110e8ff873768cb004e4481fa55efd4586c5f65dd39b708a8415d315492b0052"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.9/tangent-shared-x86_64-apple-darwin.tar.xz"
      sha256 "4087194f8c94cd3e142032447ace9895001964328673f9c130f4fa38358e2cd8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.9/tangent-shared-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "890c62e511c4cd015bc2a6c3d96b801c185d7c6779a6b16aa4f7b8d342be51bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.9/tangent-shared-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "10e1e6b3f2a58e7d3567891991afa7a65a06c8acb9612fe1c13ce9a6c629ff99"
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
    bin.install "shared-cli" if OS.mac? && Hardware::CPU.arm?
    bin.install "shared-cli" if OS.mac? && Hardware::CPU.intel?
    bin.install "shared-cli" if OS.linux? && Hardware::CPU.arm?
    bin.install "shared-cli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
