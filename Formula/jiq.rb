class Jiq < Formula
  desc "Interactive JSON query tool with real-time output"
  homepage "https://github.com/bellicose100xp/jiq"
  version "3.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bellicose100xp/jiq/releases/download/v3.8.0/jiq-aarch64-apple-darwin.tar.xz"
      sha256 "144c42825ecd0c216aae8d77e1ff51c7610821ea620a15d63cbc2dfe33315563"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bellicose100xp/jiq/releases/download/v3.8.0/jiq-x86_64-apple-darwin.tar.xz"
      sha256 "8f5d9da97cd375c779d79ba32ff5c2e7869e24a6cf1174e8b433c417a4bc96a3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bellicose100xp/jiq/releases/download/v3.8.0/jiq-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ed65033904c68ba0bce6f647ec0bfe12f9badf687ca127ed313563cda6e93e12"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bellicose100xp/jiq/releases/download/v3.8.0/jiq-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "87de6a4ba3fd8305786eb2a2bac7c48f1d82f891038da552c833f8a7849825c5"
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
