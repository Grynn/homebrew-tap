class TelegramSh < Formula
  desc "Send telegram messages right from your command-line"
  homepage "https://github.com/Grynn/telegram.sh"
  url "https://github.com/Grynn/telegram.sh/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "b0c1aa31dfca42120cc00a7febd426ef225c77ca5ffea09dd73761ca58fa2953"
  license "GPL-3.0-or-later"
  head "https://github.com/Grynn/telegram.sh.git", branch: "homebrew-support"

  depends_on "jq" => :recommended

  def install
    bin.install "telegram"
  end

  test do
    system "#{bin}/telegram", "--help"
  end
end
