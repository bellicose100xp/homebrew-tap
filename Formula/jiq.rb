class Jiq < Formula
  desc "Interactive JSON query tool with real-time filtering using jq"
  homepage "https://github.com/bellicose100xp/jiq"
  version "2.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bellicose100xp/jiq/releases/download/v2.3.1/jiq-aarch64-apple-darwin.tar.xz"
      sha256 "8a9b105277546931cb06e635794be041fd1885e26de7f46a10d6f2e6fb95255b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bellicose100xp/jiq/releases/download/v2.3.1/jiq-x86_64-apple-darwin.tar.xz"
      sha256 "cdec85a6a4dd0f8bdd4a93cb2de14e43d6ab77acd9074a0e800b6bd44d316abd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bellicose100xp/jiq/releases/download/v2.3.1/jiq-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8e308b70d0d9eef18fb63dfc8eb31aa5028c80070944361724b079c281f439f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bellicose100xp/jiq/releases/download/v2.3.1/jiq-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6c80c0c6abef27a7a8ce5a3acbe7680c00f6f17636f37702786b70401c5a9828"
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
