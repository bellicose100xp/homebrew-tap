class Jiq < Formula
  desc "Interactive JSON query tool with real-time output"
  homepage "https://github.com/bellicose100xp/jiq"
  version "3.12.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bellicose100xp/jiq/releases/download/v3.12.2/jiq-aarch64-apple-darwin.tar.xz"
      sha256 "a031cf984231c233afaf28a42a2c214f22a8793e811b55ed38d2ec0a80f21834"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bellicose100xp/jiq/releases/download/v3.12.2/jiq-x86_64-apple-darwin.tar.xz"
      sha256 "00fe1b382f24555191bcdc8cc0a5a1114ee6b98954d924f3eef9409e48d7cb91"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bellicose100xp/jiq/releases/download/v3.12.2/jiq-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6d62a6236225c4ad4950171a04c40a8601c4e796413e70618141cee698db49a8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bellicose100xp/jiq/releases/download/v3.12.2/jiq-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ede0fa6cf47967c2b44c61b2963fd6856eea6e9ab10574ec49fade09dfd8d7ab"
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
