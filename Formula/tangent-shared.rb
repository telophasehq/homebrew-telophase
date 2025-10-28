class TangentShared < Formula
  desc "The tangent-shared application"
  homepage "https://github.com/telophasehq/tangent"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.4/tangent-shared-aarch64-apple-darwin.tar.xz"
      sha256 "c21fb4448ae9c529d3acb883bf6563fa06ab2dc68f14fee7e30e8ef678b6a18b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.4/tangent-shared-x86_64-apple-darwin.tar.xz"
      sha256 "9ead0c61cc0f2280ba93689ebfdb92e7595c98d5a4c3645c0ab718d921e544a3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.4/tangent-shared-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c0efa362963466172b17337bb7625d0c384497a99230b0a9587d23ab3f7b957b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.4/tangent-shared-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e34916f5db27fb1fbeca093f267cd4118d83c7f15b2a0369852af0286f5df64b"
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
