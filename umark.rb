class Umark < Formula
  desc "Menu-bar universal bookmarks: one hotkey links what's in front of you"
  homepage "https://github.com/Grynn/umark"
  # Private repository: fetching needs GitHub credentials for git over HTTPS
  # (for example `gh auth login` followed by `gh auth setup-git`).
  url "https://github.com/Grynn/umark.git",
      revision: "e825bed3f4f02f0760b1e775d21f06a3b9504f27"
  version "0.2.0"
  license "MIT"
  head "https://github.com/Grynn/umark.git", branch: "main"

  depends_on xcode: :build
  depends_on macos: :sequoia

  def install
    # SwiftPM sandboxes its manifest build, which can't nest inside Homebrew's sandbox.
    inreplace "scripts/build.sh", "swift build -c release", "swift build --disable-sandbox -c release"
    system "./scripts/build.sh", "--no-install"
    prefix.install "build/umark.app"

    # macOS ties umark's permissions to the app's signature and location, so
    # the app runs from ~/Applications rather than from this versioned keg.
    # `umark install` copies it there (re-signing with your Apple Development
    # certificate when you have one) and starts it; other commands go to the
    # installed app.
    (bin/"umark").write <<~SHELL
      #!/bin/bash
      # Installed by Homebrew (#{name} #{version})
      set -euo pipefail
      SRC="#{opt_prefix}/umark.app"
      DEST="$HOME/Applications/umark.app"
      if [[ "${1:-}" == "install" ]]; then
          pkill -x umark || true
          for _ in {1..40}; do pgrep -x umark >/dev/null || break; sleep 0.1; done
          rm -rf "$DEST"
          mkdir -p "$HOME/Applications"
          ditto "$SRC" "$DEST"
          IDENTITY=$(security find-identity -p codesigning -v 2>/dev/null | awk -F'"' '/Apple Development/ {print $2; exit}' || true)
          codesign --force --sign "${IDENTITY:--}" "$DEST"
          /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$DEST"
          for attempt in 1 2 3 4 5; do
              open -g "$DEST" && break
              (( attempt < 5 )) || { echo "error: could not start $DEST" >&2; exit 1; }
              sleep 1
          done
          echo "installed $DEST (signed: ${IDENTITY:-ad hoc})"
          echo "umark is in the menu bar (the link icon). If a permission is missing, its Settings window lists what to grant."
          echo "Check from here: umark doctor"
          exit 0
      fi
      if [[ -x "$DEST/Contents/MacOS/umark" ]]; then
          exec "$DEST/Contents/MacOS/umark" "$@"
      fi
      exec "$SRC/Contents/MacOS/umark" "$@"
    SHELL
    chmod 0755, bin/"umark"
  end

  def caveats
    <<~EOS
      Copy umark to ~/Applications and start it (rerun after every upgrade):
        umark install

      Then grant Accessibility in umark's Settings window, which opens by
      itself while it's missing. Check what is granted with:
        umark doctor

      Without an "Apple Development" certificate (Xcode > Settings > Accounts),
      umark is signed ad hoc and macOS asks for its permissions again after
      each upgrade.
    EOS
  end

  test do
    app = prefix/"umark.app"
    assert_path_exists app/"Contents/MacOS/umark"
    assert_match "com.vishal.umark", shell_output("codesign -dv '#{app}' 2>&1")
    assert_match version.to_s, shell_output("#{app}/Contents/MacOS/umark version")
  end
end
