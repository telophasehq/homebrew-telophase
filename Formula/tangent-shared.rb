class TangentShared < Formula
  desc "The tangent-shared application"
  homepage "https://github.com/telophasehq/tangent"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.3/tangent-shared-aarch64-apple-darwin.tar.xz"
      sha256 "c7dec145e15339e296a175286b63db93a60a37996dc27392e79119def0eb8c6c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.3/tangent-shared-x86_64-apple-darwin.tar.xz"
      sha256 "4fe88fbac1005a8dd86e5883f775371acd495d6e9b8ee434645dc3082aa06a32"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.3/tangent-shared-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2923a3c05febee4dc9b3e509c42e6fc3114553714695e0353c8c4b4a105fb3c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.3/tangent-shared-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5ab18edb9cdf4857cf4bd3897fe4c7254daa484c142c2ce4af64fc2b6e07a7a3"
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
