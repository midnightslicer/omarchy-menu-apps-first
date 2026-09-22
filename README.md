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
git clone https://github.com/midnightslicer/omarchy-menu-apps-first \
  ~/.config/omarchy/plugins/drh.menu
omarchy-restart-shell
```

The directory name does not have to match; the plugin id in `manifest.json` is what the
shell uses. To put its launcher in the bar, add the id to `~/.config/omarchy/shell.json`:

```json
{ "bar": { "layout": { "left": [{ "id": "drh.menu" }] } } }
```

Open it from a keybinding or the CLI:

```bash
omarchy-shell shell summon drh.menu '{"menu":"root"}'
```

Running it alongside the first-party menu is fine; disabling `omarchy.menu` (in
`disabledPlugins`) avoids two menus answering the same keybinding.

## Compatibility

Built and tested against Omarchy 4.0.4 and Quickshell 0.3.1.

## Credit

Derived from the first-party menu plugin in
[basecamp/omarchy](https://github.com/basecamp/omarchy) (MIT). See [LICENSE](LICENSE).
