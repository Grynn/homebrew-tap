# Grynn's Homebrew tap

Personal CLI tools, desktop apps and widgets, iPhone/Watch apps and widgets,
and menu-bar utilities, distributed or linked through [Homebrew](https://brew.sh).
This repository contains the **formulas** that tell Homebrew how to download,
build, and install each tool; the applications themselves live in their linked
source repositories.

The tap is for tools you can install and use on your own devices. Prefer source
builds; use bottles only when a source build is impractical. iPhone/Watch apps
are linked with Xcode build and signing instructions, since Homebrew does not
install apps onto those devices.

Architecture-specific systems with backend/frontend deployments, databases,
workers, or network configuration stay in standalone repositories. This includes
IBKR Reporting App, SixBot, crons, IBind Proxy, and similar server applications.
A small client for an existing service can be listed; deploying that service is
outside the tap.

## Quick start

With Homebrew installed, add this tap:

```sh
brew tap grynn/tap
```

Then install the tool you want, for example:

```sh
brew install grynn/tap/share-to-claw
share-to-claw register
share-to-claw setup
```

**Tapping does not install any tools or start any background services.** It adds
this repository to Homebrew's package sources. Each tool is installed separately,
along with its declared dependencies.

You can also skip the explicit `brew tap` step: installing a fully qualified
formula such as `grynn/tap/proclick` automatically adds the tap.

## What's included?

The installable entries are **formulas**, not casks. Use `brew install`, without
`--cask`. The directory below also links tools that need a checkout or device signing.

| Formula | What it adds | Requirements |
| --- | --- | --- |
| [`share-to-claw`](https://github.com/Grynn/share-to-claw) | A macOS **Share to Claw** share-sheet extension, a delivery relay, and the `share-to-claw` command. Sends shared content to destinations you configure: webhooks, Telegram as your own account, or local CLI tools. | macOS 13+ and full Xcode for the build. Homebrew installs `uv`. |
| [`proclick`](https://github.com/Grynn/proclick) | The `proclick` command for configuring a **Razer Pro Click Mini** without Razer Synapse. | macOS and a supported mouse connected through its HyperSpeed 2.4 GHz receiver. Homebrew installs `hidapi` and Python 3.13. |
| [`telegram.sh`](https://github.com/Grynn/telegram.sh) | The `telegram` command for sending messages and files through a **Telegram bot**—useful for scripts and job notifications. | Bash, curl, and a configured Telegram bot. The formula recommends `jq` for listing chats; it has no macOS-only restriction. |
| [`tuya-ac`](https://github.com/Grynn/tuya-ac) | The `ac` command for LAN control of a **Daikin200 air conditioner** through a compatible Tuya/Smart Life IR hub. Includes Smart Life QR local-key setup. | macOS, a Tuya 3.5 IR hub using DPS 201/202, and a compatible Daikin remote. Homebrew installs Python 3.13 and `uv`. |

### Tuya AC

```sh
brew install grynn/tap/tuya-ac
ac login
ac scan
ac configure --device-id YOUR_PHYSICAL_HUB_ID --ip YOUR_LAN_IP
ac check
ac temp 28
```

In Smart Life, find **Me → Settings → Account and Security → User Code**.
`ac login` asks for that code and opens a QR image; scan it from Smart Life
and approve login. Local keys are saved directly in macOS Keychain. Configure
the physical Wi-Fi IR hub, not the virtual AC remote. Normal control runs over
the LAN without the cloud API. `ac on` selects cooling at 24°C; `ac off` sends
off; `ac temp 16` through `ac temp 30` set cooling/on temperature.

See the [source and full setup guide](https://github.com/Grynn/tuya-ac) for app
pairing, manual/developer-project key retrieval, learning, compatibility and
troubleshooting. The CLI cannot read the AC's actual state or setpoint.

### Source builds

The formulas in this tap build or install the tool from source. There are no
Homebrew bottles for the newly added tools. Homebrew may use bottles for upstream
dependencies, and uv/npm may download prebuilt third-party dependencies; building
large scientific dependencies from scratch is not required to build these tools.
Python tools use an isolated uv environment inside their Homebrew keg, not your
personal uv tool directory. Their dependency versions are resolved at installation
time; the application source itself is pinned and checksummed.

| Formula | Source | Install | Notes |
| --- | --- | --- | --- |
| `rr` | [roam-research-cli](https://github.com/Grynn/roam-research-cli) | `brew install grynn/tap/rr` | Python CLI, no runtime Python dependencies; requires Roam desktop's local API. |
| `fplot` | [grynn_cli_fplot](https://github.com/Grynn/grynn_cli_fplot) | `brew install grynn/tap/fplot` | Python charts/options CLI; scientific dependencies installed with uv. |
| `pyflexweb` | [pyflexweb](https://github.com/Grynn/pyflexweb) | `brew install grynn/tap/pyflexweb` | Configure your own IBKR Flex token/query IDs. |
| `yt-transcribe` | [yt-transcribe](https://github.com/Grynn/yt-transcribe) | `brew install grynn/tap/yt-transcribe` | Apple Silicon macOS; ffmpeg and uv included; MLX model downloads on first use. |
| `desktop-timer` | [desktop-timer](https://github.com/Grynn/desktop-timer) | `brew install grynn/tap/desktop-timer`, then `TIMER_SIGNING_TEAM=YOUR_TEAM_ID desktop-timer install` | Builds the signed macOS app and WidgetKit extension locally; requires Xcode and your signing team. |

### Personal tools directory

Private repositories below require a GitHub account with access. Their links do
not publish their contents. Authenticate with `gh auth login`, then use `gh repo
clone Grynn/REPOSITORY` and run the listed commands inside that checkout. No
credentials, user data, background jobs, or server configuration are installed by
tapping this repository.

| Tool | Repository / source | Install or build from checkout | Why linked separately |
| --- | --- | --- | --- |
| `open-in-browser` | [open-in-browser](https://github.com/Grynn/open-in-browser) | `npm install`, then `node bin/open.js URL` | Source-linked pending dependency cleanup: its current lock includes npm advisories, including critical `shell-quote`; no tap formula yet. |
| `ytq` client | [yt-queue](https://github.com/Grynn/yt-queue) (private) | `uv tool install .` | Client for an existing queue service. Backend, database, workers, and deployment remain in the standalone project. |
| GlucoScan CLI | [CLI source](https://github.com/Grynn/Vixxa-homebrew/tree/main/vixxa-cli) (private) | `uv tool install ./vixxa-cli` | Bluetooth access and sensor configuration; current executable is `vixxa`. |
| GlucoScan menu-bar utility | [macOS source](https://github.com/Grynn/Vixxa-homebrew/tree/main/VixxaBar) (private) | `VixxaBar/build.sh`, then `open VixxaBar/build/VixxaBar.app` | macOS 14+, Xcode Command Line Tools; install the CLI first. Builds/ad-hoc signs locally. |
| GlucoScan iPhone / Watch apps and widgets | [iPhone source](https://github.com/Grynn/Vixxa-homebrew/tree/main/VixxaApp), [Watch source](https://github.com/Grynn/Vixxa-homebrew/tree/main/Watch) (private) | In `VixxaApp`: `xcodegen generate`, then open `VixxaApp.xcodeproj` in Xcode and run on your device. See `Watch` for Watch build instructions. | Requires your signing team and devices; source-linked rather than installed through Homebrew. |
| Alfred scripts | [alfred-scripts](https://github.com/Grynn/alfred-scripts) (private) | `make install-new`, `make install-rr`, or `make install-ytq` | Builds and opens workflows for import into Alfred; install each workflow's CLI first. |
| Gmail attachments CLI | Local project `gmail-cli` (no origin remote configured at audit) | `npm install`, then `node bin/index.js --help` | Legacy Node tool; configure OAuth locally. `gog` is the preferred current Gmail CLI. |
| Roam MCP | [roam-research-mcp](https://github.com/2b3pro/roam-research-mcp) | Follow the repository README setup instructions. | MCP server configured in its client rather than a desktop command. |
| Alfred date utilities | [alfred-chrono](https://github.com/Grynn/alfred-chrono), [FuzzyDate](https://github.com/Grynn/FuzzyDate), [alfred-qw](https://github.com/Grynn/alfred-qw) | Follow each workflow's build/import instructions. | Existing standalone workflow projects. |
| Google Analytics CLI | [ga-stats-cli](https://github.com/Grynn/ga-stats-cli) (private) | Follow its README for source setup and authentication. | Account-specific reporting configuration. |
| Smart Life / Tuya | [tuya-ac](https://github.com/Grynn/tuya-ac) | `brew install grynn/tap/tuya-ac` | See the Tuya AC setup guide above for pairing and local keys. |
| Roam private API | Local project `roam-research-private-api` | Follow the local README. | Browser automation with local session setup; prefer `rr` for read-only search. |

GlucoScan is the product name used in this directory. The existing repository,
source directories, executable names, and Xcode targets still use their original
names; the commands above match those current sources. The standalone project
is responsible for migrating its app branding and identifiers.

This directory is curated for personal device tools, rather than mirroring the
entire project registry. Repository visibility and build metadata were checked
on 14 October 2026. Local-only projects stay local.

### Share to Claw

```sh
brew install grynn/tap/share-to-claw
share-to-claw register
share-to-claw setup
share-to-claw status
```

- **Install** builds the app and extension and adds the CLI. Full Xcode is
  required; Apple's Command Line Tools alone are not sufficient.
- **Register** registers the share extension and loads its per-user relay
  LaunchAgent. Run this once per machine, and again if registration is lost
  after a macOS upgrade.
- **Setup** configures your destinations. The wizard can be rerun to complete
  missing setup or change destinations.
- **Status** reports whether each destination is ready.

Once configured, choose **Share → Share to Claw** in a supporting macOS app to
send a URL, selected text, or a file. Supported content depends on the destination.
Delivery happens through the relay after the share sheet closes.

If the extension is missing, check **System Settings → General → Login Items &
Extensions → Sharing**. Settings labels can vary by macOS version.

An OpenClaw installation is **not required**: a webhook, Telegram, or an existing
local CLI can be used independently. This package does not install OpenClaw or
the tools used by your CLI destinations.

See the [project README](https://github.com/Grynn/share-to-claw#readme) for
destination configuration, routing, and troubleshooting.

### proclick

```sh
brew install grynn/tap/proclick
proclick --help
proclick
```

Running `proclick` without arguments shows mouse status. To change its DPI:

```sh
proclick dpi 1600
```

It also supports polling rate, DPI stages, and idle timeout. Settings are saved
to the mouse's onboard memory. It targets the **Pro Click Mini (RZ01-0399)**
through its receiver; do not assume support for other Razer mice or Bluetooth
configuration. It does not configure macOS pointer-acceleration curves.

See the [project README](https://github.com/Grynn/proclick#readme) for supported
settings and hardware details.

### telegram.sh

```sh
brew install grynn/tap/telegram.sh
telegram --help
```

The **formula is named `telegram.sh`, but the installed command is `telegram`**.
Follow the [project's configuration guide](https://github.com/Grynn/telegram.sh#installation--configuration)
to set up your bot and destination chat before sending anything.

After configuration:

```sh
telegram "Job finished"
telegram -f results.txt "Results attached"
```

Unlike Share to Claw's Telegram destination, this tool sends **as a bot**, not as
your personal Telegram account. It is not the Telegram desktop application.

## Inspect and update

List the formulas supplied by this tap:

```sh
brew tap-info grynn/tap
brew search grynn/tap/
```

Inspect a formula before installing it:

```sh
brew info grynn/tap/share-to-claw
```

Refresh Homebrew's package definitions, then upgrade an installed tool:

```sh
brew update
brew upgrade grynn/tap/share-to-claw
```

Substitute `proclick`, `telegram.sh`, or `tuya-ac` to inspect or upgrade those formulas.
`brew update` refreshes package definitions; it does not itself upgrade installed
tools.

## Uninstall

For Share to Claw, unregister the extension and relay **before** removing the
package:

```sh
share-to-claw unregister
brew uninstall grynn/tap/share-to-claw
```

Remove the other tools individually if installed:

```sh
brew uninstall grynn/tap/proclick
brew uninstall grynn/tap/telegram.sh
brew uninstall grynn/tap/tuya-ac
```

Once no installed formulas depend on this tap, remove it:

```sh
brew untap grynn/tap
```

Uninstalling a formula should not be treated as erasing its user configuration
or saved sessions. Consult the tool's documentation if you also want to remove
that data.

## Troubleshooting and issues

- For formula download, dependency, or installation problems, open an issue in
  [this tap](https://github.com/Grynn/homebrew-tap/issues).
- For application behavior or feature requests, use the corresponding source
  repository linked above.
- Include the formula name, OS version, and relevant error output. Redact
  credentials and private information from logs before posting.

Each tool's license is declared in its formula and source repository.
