class Jiq < Formula
  desc "Interactive JSON query tool with real-time output"
  homepage "https://github.com/bellicose100xp/jiq"
  version "3.32.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bellicose100xp/jiq/releases/download/v3.32.0/jiq-aarch64-apple-darwin.tar.xz"
      sha256 "a1490db6b642260cc31ae77a4d91d9b2f07c99eea846fed33e6e964136b339ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bellicose100xp/jiq/releases/download/v3.32.0/jiq-x86_64-apple-darwin.tar.xz"
      sha256 "8ccb0bf479a46845432cbc19297fc9797c3bcf6e8a53e444e3060c872fda8265"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bellicose100xp/jiq/releases/download/v3.32.0/jiq-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e66848d2c35084a458240ab1f55ff0878fedffd2ad3538cdb1bd0d4d02cf5aaa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bellicose100xp/jiq/releases/download/v3.32.0/jiq-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6dff65ed8a064025d9d7e35d4b62e0443306e4506acf28b6fc698eb433244506"
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
