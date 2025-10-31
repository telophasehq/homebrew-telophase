class TangentCli < Formula
  desc "The tangent-cli application"
  homepage "https://github.com/telophasehq/tangent"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.7/tangent-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a96d8bf487d114b10f7ec14afe2eb5ea9c951be4620f03289abe1ef332d9ab88"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.7/tangent-cli-x86_64-apple-darwin.tar.xz"
      sha256 "be02ef86039fed01a4a683c0ce4580c0a183443c24b0aef9bccacad2c1414105"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.7/tangent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "367a6563ab80191e69de48113bed42929f474f42a4b6a4912cbc1669127c2c1d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.7/tangent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fc423f8c6bc61eb82778bebb0a74a6297fa6f669ff0ad9856016d8d56180cbce"
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
