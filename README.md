# Apps-first Omarchy menu

A Quickshell menu plugin for [Omarchy](https://github.com/basecamp/omarchy). It is the
first-party `omarchy.menu` plugin with two changes: installed applications win the search,
and the application list works even when the host does not hand the plugin its app engine.

## Why

Typing `mus` in the menu and pressing Enter started an *installer* for Muse Code, because
`Muse Code` starts with the query while `YouTube Music` only contains it. Anything already
installed should come first — the installer is still there, one group down.

```
mus
┌──────────────────────────────┐
│ ▶ YouTube Music      Apps    │  ← installed apps, selected by default
│ ♪ cliamp             Apps    │
│ ───────────────────────────  │  ← divider
│ ∞ Muse Code   Setup › Agent  │  ← installers and submenus
└──────────────────────────────┘
```

## What changed

**1. Installed apps are their own search group.** Search results are partitioned into
installed apps → items in the current menu → items from submenus. Each group is sorted by
the existing relevance score, and a hairline divider separates them. Nothing is hidden: the
installer is one arrow-down away. The divider machinery was generalized so any group after
the first draws one, instead of being hardwired to the single `drilldown` section.

**2. The app list no longer depends on the host injecting `shell.appLibrary`.** A cloned
menu can be handed `null` there, which leaves the Apps submenu empty and strips every app
row out of search. The plugin now reads Quickshell's `DesktopEntries` directly when that
engine is missing, through helpers (`appEntries`, `appEntryName`, `appEntrySubtext`,
`appIconSource`, `appLaunch`, `appRemove`, `appRefreshIcons`) that prefer the host engine
whenever it is available. A `Connections` on `DesktopEntries.applications` keeps the list
live, so installing or removing an app updates the menu without restarting the shell.

What the fallback does not reproduce, because it lives in the host engine:

- the "Launching…" OSD after picking an app
- hidden-entry filtering beyond the entry's own `NoDisplay`
- the icon rescan for packages installed after the shell started (those show a generic icon
  until the next shell restart)

## Install

```bash
omarchy plugin add https://github.com/midnightslicer/omarchy-menu-apps-first.git --enable
```

`add` clones the repo into `~/.config/omarchy/plugins/midnightslicer.apps-first-menu`,
validates the manifest, and loads it into the running shell. `--enable` turns it on right
away; leave it off to review the code first, then enable it with the setup step below.

## Setup

```bash
omarchy plugin enable midnightslicer.apps-first-menu
```

Enabling does three things, because the manifest declares `"clonedFrom": "omarchy.menu"`:

- disables the first-party `omarchy.menu`, so only one menu answers
- takes over the first-party menu button's slot in the bar
- routes every existing menu keybinding (`Super+Space`, `Super+Alt+Space`, `Super+Escape`,
  …) to this plugin, since `omarchy-menu` still summons `omarchy.menu`

No keybinding or `shell.json` edits are needed. To place the bar button somewhere else,
pass a section: `omarchy plugin enable midnightslicer.apps-first-menu --section left`.

Check it is active:

```bash
omarchy plugin list | grep apps-first
```

## Update

```bash
omarchy plugin update midnightslicer.apps-first-menu
```

## Remove

```bash
omarchy plugin remove midnightslicer.apps-first-menu
```

This unloads the plugin, deletes its folder, and restores the first-party `omarchy.menu`,
including its bar button and keybindings. To switch back without deleting it, run
`omarchy plugin disable midnightslicer.apps-first-menu` instead.

## Compatibility

Built and tested against Omarchy 4.0.4 and Quickshell 0.3.1.

## Credit

Derived from the first-party menu plugin in
[basecamp/omarchy](https://github.com/basecamp/omarchy) (MIT). See [LICENSE](LICENSE).
