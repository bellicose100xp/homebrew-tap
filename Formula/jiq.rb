class Jiq < Formula
  desc "Interactive JSON query tool with real-time filtering using jq"
  homepage "https://github.com/bellicose100xp/jiq"
  version "2.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bellicose100xp/jiq/releases/download/v2.0.3/jiq-aarch64-apple-darwin.tar.xz"
      sha256 "1fde71771271248e2bf8d09aa8a8f2fa487771a29b198bbe52d37e5bb89c4047"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bellicose100xp/jiq/releases/download/v2.0.3/jiq-x86_64-apple-darwin.tar.xz"
      sha256 "72d173efc6dd4da60b895fc6d4ffbfc41bb37d01b59eb7298de0c875b4f0956e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bellicose100xp/jiq/releases/download/v2.0.3/jiq-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e593fcb575dd753807e9537cf231c6830e8d3a7f5a76e0f3478a0907debda3d4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bellicose100xp/jiq/releases/download/v2.0.3/jiq-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "32b316c50f74afc1fcd8824ac4e048d7167118800d10e8fd123c02e23154ec20"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "jiq" if OS.mac? && Hardware::CPU.arm?
    bin.install "jiq" if OS.mac? && Hardware::CPU.intel?
    bin.install "jiq" if OS.linux? && Hardware::CPU.arm?
    bin.install "jiq" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
