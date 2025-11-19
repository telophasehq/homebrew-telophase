class TangentRuntime < Formula
  desc "The tangent-runtime application"
  homepage "https://github.com/telophasehq/tangent"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.9/tangent-runtime-aarch64-apple-darwin.tar.xz"
      sha256 "9f93e5048b6ca88f4cb1323e44cfa14f44d64acaabfebd7f3aa596d68933efd1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.9/tangent-runtime-x86_64-apple-darwin.tar.xz"
      sha256 "0ad0197257aa419a1905230fa2db6f2d0d942bee18f94f9ff195735822b357e9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.9/tangent-runtime-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c163b4e3e0cefee081eeac356cefaff67074be2483f7332d7613719fdce8b4d9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.9/tangent-runtime-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1d1eb1b1c2f0ead63de454d5d1f8bfb968af43d03591b86265719cdecc374a6e"
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
