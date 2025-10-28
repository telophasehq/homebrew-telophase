class TangentRuntime < Formula
  desc "The tangent-runtime application"
  homepage "https://github.com/telophasehq/tangent"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.5/tangent-runtime-aarch64-apple-darwin.tar.xz"
      sha256 "1d8ee2b0c435e1a5b9734f0d54dc45fff4e91568d3ae875f4da6f1b95becdf7d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.5/tangent-runtime-x86_64-apple-darwin.tar.xz"
      sha256 "613f640b16de16a4a86f64b2b99dda63f09aa0edd7e3dd290133bf3087e7d10b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.5/tangent-runtime-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7eae83794ab1a56fe013d6b5816be875979adb75e81980d7a16e19dd2b4a7f41"
    end
    if Hardware::CPU.intel?
      url "https://github.com/telophasehq/tangent/releases/download/v0.1.5/tangent-runtime-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "59ea1c79bb337a36df47e892aedbb0cfc1b0a72ed3836cde8ddbdb6c6580bfd5"
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
