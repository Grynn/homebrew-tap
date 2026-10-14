class DesktopTimer < Formula
  desc "Bold 30-minute macOS desktop widget, built and signed locally"
  homepage "https://github.com/Grynn/desktop-timer"
  url "https://github.com/Grynn/desktop-timer/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1318b6535789df9167e9120c99990cbd6cc61628835f63eaf4f64a0c371f4aa0"
  license "MIT"
  head "https://github.com/Grynn/desktop-timer.git", branch: "main"

  depends_on xcode: :build
  depends_on macos: :sonoma
  depends_on "xcodegen"

  def install
    libexec.install "App", "Widget", "Shared", "Config", "Tests", "scripts", "project.yml"
    (bin/"desktop-timer").write <<~SHELL
      #!/bin/bash
      export DESKTOP_TIMER_SOURCE="#{libexec}"
      exec "#{libexec}/scripts/desktop-timer" "$@"
    SHELL
  end

  def caveats
    <<~EOS
      Build and sign the widget with your local Apple Development identity:
        TIMER_SIGNING_TEAM=YOUR_TEAM_ID desktop-timer install
      Find the team ID in Xcode Settings > Accounts. Full Xcode is required.
      Then open the app:
        desktop-timer
      Control-click your desktop > Edit Widgets > Desktop Timer.

      The app is installed in ~/Applications. After upgrading this formula,
      rerun the install command with the same team to rebuild the app.
      Source is installed by Homebrew; no prebuilt app or bottle is used.
    EOS
  end

  test do
    assert_match "Widget Gallery", shell_output("#{bin}/desktop-timer --help")
    assert_path_exists libexec/"Widget/TimerWidget.swift"
    system bin/"desktop-timer", "test"
  end
end
