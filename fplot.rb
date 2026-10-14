class Fplot < Formula
  desc "Financial charts and options analysis from the command-line"
  homepage "https://github.com/Grynn/grynn_cli_fplot"
  url "https://github.com/Grynn/grynn_cli_fplot/archive/f75947749c770987cfe5bac9be01bb4facbbf3a0.tar.gz"
  version "0.4.10"
  sha256 "c941f57e5600dc1644df198f0dd4731f2ebb3951eba1e9e557e753f93f934e9b"
  license "MIT"

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
    assert_match "Usage", shell_output("#{bin}/fplot --help")
  end
end
