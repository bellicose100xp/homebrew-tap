class Jiq < Formula
  desc "Interactive JSON query tool with real-time output"
  homepage "https://github.com/bellicose100xp/jiq"
  version "3.10.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bellicose100xp/jiq/releases/download/v3.10.7/jiq-aarch64-apple-darwin.tar.xz"
      sha256 "3f72f15a9e92dd88d43e7d93d2a3ac8467cae16526f35cbfc948b504083fd1ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bellicose100xp/jiq/releases/download/v3.10.7/jiq-x86_64-apple-darwin.tar.xz"
      sha256 "5df0422ac1dc03af9579f2f3064590b4b03c54f4f5fce952e582219833618f34"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bellicose100xp/jiq/releases/download/v3.10.7/jiq-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fc6f3cacdaaa2b6a863022e789f16d3abf7f48aebf491ab691b23d250785b46c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bellicose100xp/jiq/releases/download/v3.10.7/jiq-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d3d00fc9d64a4361eef5b3bd3dfc327988ac1da9111f7e9cc4f34c1dc0dea060"
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
