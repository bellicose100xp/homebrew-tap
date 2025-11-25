class Jiq < Formula
  desc "Interactive JSON query tool with real-time filtering using jq"
  homepage "https://github.com/bellicose100xp/jiq"
  version "2.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bellicose100xp/jiq/releases/download/v2.10.0/jiq-aarch64-apple-darwin.tar.xz"
      sha256 "e93e85b06702908dc543ca83f378e5ebe584517b1da45f0f097f76299b8070ca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bellicose100xp/jiq/releases/download/v2.10.0/jiq-x86_64-apple-darwin.tar.xz"
      sha256 "c30c9afc67ca7572747ce9dbf48d73a2c7856b24f6ea639491fbc5fc4b2fc7a3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bellicose100xp/jiq/releases/download/v2.10.0/jiq-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e8b89a030d00bab2f4bec573fde96fae15c2452c29c467f2a3961cdf8ace4693"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bellicose100xp/jiq/releases/download/v2.10.0/jiq-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7ab3dc41387f5e82134d854adc3586645680813d7a93f707a2a3f00413ffa4b5"
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
