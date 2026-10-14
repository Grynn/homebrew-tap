class Rr < Formula
  desc "Fast read-only search of a running Roam Research desktop app"
  homepage "https://github.com/Grynn/roam-research-cli"
  url "https://github.com/Grynn/roam-research-cli/archive/f383b8a5138a7acf0dd4f1fa04c6a52589542a5d.tar.gz"
  version "0.1.0"
  sha256 "56c87a4f26df69bc636093cd7eb9bd3a89d919381ff242c8009f07ab9da02f8e"
  license "MIT"

  depends_on :macos
  depends_on "python@3.13"
  depends_on "uv"

  def install
    ENV["UV_TOOL_DIR"] = libexec
    ENV["UV_TOOL_BIN_DIR"] = bin
    ENV["UV_CACHE_DIR"] = buildpath/".uv-cache"
    ENV["UV_PYTHON_DOWNLOADS"] = "never"
    system "uv", "tool", "install", "--python", formula_opt_bin("python@3.13")/"python3.13", "."
  end

  test do
    assert_match "usage", shell_output("#{bin}/rr --help")
  end
end
