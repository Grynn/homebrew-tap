class ShareToClaw < Formula
  desc "macOS share sheet to a webhook, Telegram (as yourself), or any CLI"
  homepage "https://github.com/Grynn/share-to-claw"
  url "https://github.com/Grynn/share-to-claw/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "bc3aee4fdd212de7e137080be9294fb0cd6e52ae9285f58d0933269530d69700"
  license "MIT"
  head "https://github.com/Grynn/share-to-claw.git", branch: "main"

  depends_on xcode: :build
  depends_on :macos
  depends_on "uv"

  def install
    system "./scripts/build.sh", buildpath/"out"
    prefix.install buildpath/"out/ShareToClaw.app"

    libexec.install "sender/share_to_claw.py"
    libexec.install "agent/relay.plist.template"
    libexec.install "scripts/register.sh", "scripts/unregister.sh"

    uv = formula_opt_bin("uv")/"uv"
    app = prefix/"ShareToClaw.app"
    (bin/"share-to-claw").write <<~SHELL
      #!/bin/sh
      # Installed by Homebrew (#{name} #{version})
      case "$1" in
          register)   exec "#{libexec}/register.sh" --app "#{app}" \\
                          --script "#{libexec}/share_to_claw.py" --uv "#{uv}" ;;
          unregister) exec "#{libexec}/unregister.sh" --app "#{app}" ;;
      esac
      exec "#{uv}" run "#{libexec}/share_to_claw.py" "$@"
    SHELL
    chmod 0755, bin/"share-to-claw"
  end

  def caveats
    <<~EOS
      Register the share extension and load the relay agent (once per machine):
        share-to-claw register

      Then configure destinations — a webhook, Telegram, or any CLI. The wizard
      is idempotent and only asks for what is missing:
        share-to-claw setup

      "Share to Claw" then appears in every app's Share menu. Manage it under
      System Settings > General > Login Items & Extensions > Sharing.

      To undo the registration before uninstalling:
        share-to-claw unregister
    EOS
  end

  test do
    app = prefix/"ShareToClaw.app"
    appex = app/"Contents/PlugIns/ShareToClawExt.appex"
    assert_path_exists app/"Contents/MacOS/ShareToClaw"
    assert_match "app.sharetoclaw.share", shell_output("codesign -dv '#{appex}' 2>&1")
  end
end
