class TangentCli < Formula
  desc "The tangent-cli application"
  homepage "https://github.com/telophasehq/tangent"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.4/tangent-cli-aarch64-apple-darwin.tar.xz"
      sha256 "0a904a52be0715ab18ca581b1ab1cc7bd858d705f8b5ffef1fdb59803ef24358"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.4/tangent-cli-x86_64-apple-darwin.tar.xz"
      sha256 "6b77f8439ca8cbfd2cbbebcba7b1ff2ccaedd4f87911dd455f74fb92ef1450b9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.4/tangent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ee78d3f68e212c8a3292e948a784f2cbed8f110978882ac81bded34113550d44"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.4/tangent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e8b6ab67e1714eb28ecce6123180896d3fe48dd0313849e920da23afafc472ce"
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
