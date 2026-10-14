class YtTranscribe < Formula
  desc "Transcribe and summarize videos on Apple Silicon"
  homepage "https://github.com/Grynn/yt-transcribe"
  url "https://github.com/Grynn/yt-transcribe/archive/6a0563107339c26b2926f4a79b3a555ee4bd07bd.tar.gz"
  version "0.2.6"
  sha256 "e65bcb688c94fbc001e44ae119e981d878b6da994f4904d6fb74ed45fdea73e9"
  license "MIT"

  depends_on arch: :arm64
  depends_on "ffmpeg"
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

  def caveats
    <<~EOS
      Configure ~/.config/yt-transcribe/config.toml before use.
      Transcription runs MLX Whisper through uvx and downloads its model on first use.
      Summary and delivery features need their configured external services.
    EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/yt-transcribe --help")
  end
end
