cask "holdings" do
  version "0.3.0"
  sha256 "876815ee6c50df1b25019e140f9edd17f83ba8349d751f9f0964260a994f4425"

  # Tailnet only: static.p.twidex.com skips Cloudflare Access but is reachable only with Tailscale on.
  # The repository is private, so the build is not published anywhere public.
  url "http://static.p.twidex.com/public/holdings-app/Holdings-mac-#{version}.zip"
  name "Holdings"
  desc "IBKR holdings dashboard with desktop widgets"
  homepage "https://github.com/Grynn/holdings-widget"

  depends_on macos: :sonoma

  app "Holdings.app"

  # Signed with a personal Apple Development certificate, not notarised: without this,
  # Gatekeeper blocks the first open of a quarantined download.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Holdings.app"]
  end

  zap trash: [
    "~/Library/Containers/com.grynn.holdings.mac",
    "~/Library/Containers/com.grynn.holdings.mac.widgets",
    "~/Library/Group Containers/G3CWP62SH7.com.grynn.holdings",
  ]

  caveats <<~EOS
    Needs Tailscale on for the download.

    Open Holdings, then Settings: paste the Base URL, Token and the two
    Cloudflare Access fields from the Secrets section of the New Mac page
    (static.twidex.com/public/mac-setup/#secrets), Save, Test connection.

    Add the widget: right-click the desktop, Edit Widgets, search Holdings.
  EOS
end
