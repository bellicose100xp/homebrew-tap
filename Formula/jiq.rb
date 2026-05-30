class Jiq < Formula
  desc "Interactive JSON query tool with real-time output"
  homepage "https://github.com/bellicose100xp/jiq"
  version "3.30.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bellicose100xp/jiq/releases/download/v3.30.1/jiq-aarch64-apple-darwin.tar.xz"
      sha256 "09a300b397fba0ef92ea720766fe5e73130d329067ec5bdcb4f7dd21945dcbfe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bellicose100xp/jiq/releases/download/v3.30.1/jiq-x86_64-apple-darwin.tar.xz"
      sha256 "c1825659d8799e417eabf647461935e86b8d4cfb8351a42c12a114ad3367eb82"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bellicose100xp/jiq/releases/download/v3.30.1/jiq-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f988200cd4c41ff35e6c75c58327ff9a950e29827276c38774753b4ec15804b5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bellicose100xp/jiq/releases/download/v3.30.1/jiq-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "daf2f5bca2db64792a697a459b554a910392f8549a4ef330ec592a07b943e3fb"
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
