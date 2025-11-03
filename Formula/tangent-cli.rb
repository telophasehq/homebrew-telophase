class TangentCli < Formula
  desc "The tangent-cli application"
  homepage "https://github.com/telophasehq/tangent"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.8/tangent-cli-aarch64-apple-darwin.tar.xz"
      sha256 "927232baa35959ed6e151f19a84eaecfb3ab79b04fc00da2f80329f7535956bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.8/tangent-cli-x86_64-apple-darwin.tar.xz"
      sha256 "eaf08e417918a0c5d98bbb86ccb1d13a40e24ab5d1b7274b68da45126c7e70a2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.8/tangent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7dd92ea40d848e6662120b5e0c841b6c448aca215a7cfca646896b29b1097e0b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.8/tangent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a5f1b0401fcdb7729229e022a95e6821913ade4c8e6ce145ba6fa460421e40c1"
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
