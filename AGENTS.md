# Tap scope

This tap distributes or links personal CLI tools, desktop apps/widgets,
iPhone/Watch apps/widgets, and menu-bar utilities. Core examples: proclick,
fplot, rr, share-to-claw, open-in-browser, GlucoScan, Alfred workflows, and
Desktop Timer.

Prefer source installs/builds. Use bottles only when necessary. Clearly
separate installable formulas from source-linked projects; do not imply that
Homebrew installs iPhone/Watch apps. Preserve private repository visibility.

Do not turn this into the full project registry. Architecture-specific backend
systems remain standalone: IBKR Reporting App, SixBot, crons, IBind Proxy,
backend/frontend applications, database/worker stacks, and host/network setup.
A small client such as ytq may be listed, but its backend deployment must not be
bundled into the tap.

Use GlucoScan as the glucose-tool product name in the directory. Until the
upstream project migrates, retain its actual source paths, commands, and links
so build instructions remain accurate. Do not silently change bundle IDs,
App Groups, stored data, signing settings, or upstream repository names as part
of a tap documentation edit.
