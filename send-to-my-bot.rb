class SendToMyBot < Formula
  desc "macOS share sheet to Telegram (as yourself) and the ytq video queue"
  homepage "https://github.com/Grynn/share-to-telegram"
  url "https://github.com/Grynn/share-to-telegram/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "54907e8ad7c6ebeead7ba5688bb043a7a8a615a07c2f5f07e0eead2d5146a5f7"
  license "MIT"
  head "https://github.com/Grynn/share-to-telegram.git", branch: "main"

  depends_on xcode: :build
  depends_on :macos
  depends_on "uv"

  def install
    system "./scripts/build.sh", buildpath/"out"
    prefix.install buildpath/"out/SendToMyBot.app"

    libexec.install "sender/bot_send.py"
    libexec.install "agent/relay.plist.template"
    libexec.install "scripts/register.sh", "scripts/unregister.sh"

    uv = formula_opt_bin("uv")/"uv"
    app = prefix/"SendToMyBot.app"
    (bin/"send-to-my-bot").write <<~SHELL
      #!/bin/sh
      # Installed by Homebrew (#{name} #{version})
      case "$1" in
          setup)   exec "#{libexec}/register.sh" --app "#{app}" \\
                       --script "#{libexec}/bot_send.py" --uv "#{uv}" ;;
          unsetup) exec "#{libexec}/unregister.sh" --app "#{app}" ;;
      esac
      exec "#{uv}" run "#{libexec}/bot_send.py" "$@"
    SHELL
    chmod 0755, bin/"send-to-my-bot"
  end

  def caveats
    <<~EOS
      Register the share extension and load the relay agent (once per machine):
        send-to-my-bot setup

      Then log in to Telegram (needs an api_id/api_hash from
      https://my.telegram.org/apps and the code Telegram sends you):
        send-to-my-bot login

      "Send to My Bot" then appears in every app's Share menu. Manage it under
      System Settings > General > Login Items & Extensions > Sharing.

      To undo the registration before uninstalling:
        send-to-my-bot unsetup
    EOS
  end

  test do
    assert_path_exists prefix/"SendToMyBot.app/Contents/MacOS/SendToMyBot"
    assert_match "app.sendtomybot.share",
      shell_output("codesign -dv '#{prefix}/SendToMyBot.app/Contents/PlugIns/SendToMyBotExt.appex' 2>&1")
  end
end
