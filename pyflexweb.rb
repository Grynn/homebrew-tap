class Pyflexweb < Formula
  desc "Download Interactive Brokers Flex Query reports"
  homepage "https://github.com/Grynn/pyflexweb"
  url "https://github.com/Grynn/pyflexweb/archive/e245464cf04a7e9edfa7a2d6c92042f5c824a01e.tar.gz"
  version "0.4.1"
  sha256 "babe97888e15c76a3abdc90381017bb879bd41354f982834b5714e49caec9dab"
  license "GPL-3.0-or-later"

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
    assert_match "Usage", shell_output("#{bin}/pyflexweb --help")
  end
end
