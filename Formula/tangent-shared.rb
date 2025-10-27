class TangentShared < Formula
  desc "The tangent-shared application"
  homepage "https://github.com/telophasehq/tangent"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.2/tangent-shared-aarch64-apple-darwin.tar.xz"
      sha256 "28f7327966aa6e6daa60e1a2294b7b4a2ca8492145a873997aab493600792309"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.2/tangent-shared-x86_64-apple-darwin.tar.xz"
      sha256 "5d0dbc2642b6cf7af90f47aa932012e6dca5f8af0bf822c11559c954b4ed2184"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.2/tangent-shared-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6e11001e568ec043c52910d84c4718f39129e739dedde8350735553e88ed3ff1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.2/tangent-shared-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d4832cc496ce59bb97e014a73f8fa4a921e3a309f46f9199819d49b3b12bfcc5"
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
