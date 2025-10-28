class TangentShared < Formula
  desc "The tangent-shared application"
  homepage "https://github.com/telophasehq/tangent"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.5/tangent-shared-aarch64-apple-darwin.tar.xz"
      sha256 "143dcafcc19942a0ab41ed019b0de6a8846383b84a4a63cfc5d1a194dcadfbd9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.5/tangent-shared-x86_64-apple-darwin.tar.xz"
      sha256 "e1b772eb6c552e1cc9a0301b9d6954408348ada40061a21937ab9e795509047a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.5/tangent-shared-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e36118907d57066a673b85d267fb24419cbd6145a482b69edbc46485095af978"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.5/tangent-shared-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9345195d00c5a079ae30567bbb73bcd55dd99b7057e85c3bc23b7e973e429af3"
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
