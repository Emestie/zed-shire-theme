# Shire — a Zed theme

A dark, warm, earthy theme for [Zed](https://zed.dev), ported from OpenChamber's
**Fields of the Shire** (dark): the same burnt-umber background, sage-green accent,
clay-orange numbers and slate-blue keywords.

- Theme family: **Shire**
- Variants: **Shire Dark** and **Shire Light** (`appearance: "dark"` / `"light"`)
- Palette sources: [`fields-of-the-shire-dark.json`](https://github.com/openchamber/openchamber/blob/main/packages/ui/src/lib/theme/themes/fields-of-the-shire-dark.json), [`fields-of-the-shire-light.json`](https://github.com/openchamber/openchamber/blob/main/packages/ui/src/lib/theme/themes/fields-of-the-shire-light.json)

## What is in this repo

```
shire/
├── extension.toml          # Zed extension manifest
├── Cargo.toml              # Rust crate (theme extensions are wasm crates)
├── src/shire.rs            # no-op Extension impl
├── themes/shire.json       # ← the theme itself: one family, dark + light
├── scripts/check-theme.ps1 # JSON + hex-color sanity check
├── LICENSE
└── README.md
```

`themes/shire.json` is the only file that matters for the look. Everything else
exists so Zed can install it as an extension.

## Prerequisites

| Path | Needs |
| --- | --- |
| **A — drop-in file** | only Zed |
| **B — extension** | Zed + Rust toolchain (`rustup`, `cargo`) |

This machine has no `cargo`/`rustup` on `PATH`, so **Path A works out of the box**
and Path B needs one install step first: `winget install Rustlang.Rustup`, then open
a new terminal.

## Check the theme file

```pwsh
pwsh -File .\scripts\check-theme.ps1
# Checking ...\themes\shire.json
#   OK  2 theme(s), 410 color values, all valid hex.
```

The check validates the JSON, the required family keys (`name`, `author`, `themes`),
`appearance`, and every color string as `#RGB` / `#RRGGBB` / `#RRGGBBAA`.
The file also validates against [Zed's theme schema v0.2.0](https://zed.dev/schema/themes/v0.2.0.json)
— all 141 style keys and 35 syntax keys it uses are real schema entries, so the
`$schema` line in the file gives you completion and validation in Zed itself.

## Path A — add it as a plain theme file (fastest)

1. Copy the family file into Zed's themes directory:

   ```pwsh
   Copy-Item .\themes\shire.json "$env:APPDATA\Zed\themes\shire.json" -Force
   ```

   | OS | Directory |
   | --- | --- |
   | Windows | `%APPDATA%\Zed\themes\` |
   | macOS | `~/.config/zed/themes/` |
   | Linux | `~/.config/zed/themes/` |

2. Quit and reopen Zed (themes are read at startup).

3. Pick it: `ctrl-shift-p` → **theme selector: toggle** → **Shire Dark** or
   **Shire Light**, or set it in `settings.json`:

   ```jsonc
   "theme": {
     "mode": "system",          // or "dark" / "light"
     "dark": "Shire Dark",
     "light": "Shire Light"
   }
   ```

Editing the copy in `themes/` afterwards means re-copying it and restarting Zed.

## Path B — install it as a dev extension (recommended)

This is how you develop the theme with live rebuilds, and the shape the registry expects.

1. Install Rust once (if missing):

   ```pwsh
   winget install Rustlang.Rustup
   rustup target add wasm32-wasip1   # new terminal after install
   ```

2. In Zed: `ctrl-shift-p` → **zed: install dev extension** → select this folder
   (`C:\Users\valery.murashko\dev2\shire`). Zed compiles the crate to wasm itself;
   the first build takes ~1 minute.

3. `ctrl-shift-p` → **theme selector: toggle** → **Shire Dark** or **Shire Light**.

After editing `themes/shire.json`, run `ctrl-shift-p` → **zed: rebuild dev extensions**
(no full restart needed). Uninstall the same way: **zed: extensions** → Shire → Uninstall.

The dev extension is installed from the working tree, so no `cargo build` or copying
is required — Zed does both. To build by hand anyway:

```pwsh
cargo build --release --target wasm32-wasip1
```

## Variants

Both variants live in the same family file, so Zed's picker lists one **Shire** entry
with a dark and a light side, and `"mode": "system"` follows the OS:

| Variant | `appearance` | Base / editor | Accent |
| --- | --- | --- | --- |
| Shire Dark | `dark` | `#1b1815` / `#191613` | sage `#809062` |
| Shire Light | `light` | `#f9f5eb` / `#f6f2e8` | forest `#4a6030` |

The dark side is a 1:1 port, alpha overlays included. On the light side the source's
alpha borders (`#1a161215`) and selections are resolved to opaque tones of the same
warm paper, and two values are nudged for readability: doc comments go from `#b8b0a4`
(≈1.9:1) to `#8f8375` (≈3.3:1), gutter numbers from `#a99e90` to `#9a8f80`.

A third variant (for example a blurred "Shire Soft") is just another object in the
`themes` array with its own `name` and `appearance`; the family `name` stays `"Shire"`.

## Promoting to the extension registry (optional)

1. Create a public repo from this folder and uncomment `repository` in `extension.toml`
   (replace the placeholder).
2. Fork [`zed-industries/extensions`](https://github.com/zed-industries/extensions),
   add your repo as a submodule under `extensions/shire`, and add a matching entry to
   `extensions.toml`:

   ```toml
   [shire]
   submodule = "extensions/shire"
   version = "0.1.0"
   ```

3. Open a PR. After merge, **Shire** shows up in **zed: extensions** for everyone.

## How the OpenChamber palette maps to Zed

Dark-side values below; the light side uses the light source's equivalents
(`#514a40` text, `#4a6030` accent, `#3d4f5a` keywords, `#f9f5eb` / `#f6f2e8` surfaces).

| OpenChamber token | Zed key(s) |
| --- | --- |
| `surface.background` `#1b1815` | `background`, `surface.background`, `panel.background` |
| `syntax.base.background` `#191613` | `editor.background`, `editor.gutter.background`, `tab.active_background` |
| `surface.muted` `#161311` | `status_bar`, `title_bar`, `tab_bar`, `terminal.background` |
| `surface.elevated` `#24211e` | `elevated_surface.background`, `element.background` |
| `surface.foreground` `#e9decf` | `text`, `editor.foreground`, `syntax.variable` |
| `surface.mutedForeground` `#948b7c` | `text.muted`, `icon.muted`, `editor.active_line_number` (brightened) |
| `primary.base` `#809062` | `accents[0]`, `text.accent`, `icon.accent`, `border.focused`, `created` |
| `interactive.border` `#2e2b28` | `border`, `pane_group.border` |
| `interactive.selection` | `ghost_element.selected`, `editor.document_highlight.*` |
| `syntax.base.comment` `#6a5e52` | `syntax.comment`, `editor.line_number`, `ignored` |
| `syntax.base.keyword` `#5a6d7a` | `syntax.keyword`, `syntax.property`, `syntax.preproc`, `modified` |
| `syntax.base.string` `#93a56b` | `syntax.string`, `syntax.attribute`, `syntax.function.method` |
| `syntax.base.number` `#c47a3a` | `syntax.number`, `syntax.function`, `syntax.tag`, `warning` |
| `syntax.base.type` `#7a8a5a` | `syntax.type`, `syntax.enum`, `syntax.boolean`, `success` |
| `syntax.base.operator` `#a89888` | `syntax.operator`, `syntax.punctuation` |
| `syntax.tokens.commentDoc` `#4a4238` | `syntax.comment.doc` |
| `syntax.highlights.diff*` | `created` / `modified` / `deleted` (`*` uses `#RRGGBBAA` for backgrounds) |
| `status.*` | `error`, `warning`, `success`, `info` + their `.background` / `.border` |
| `markdown.link` `#75858f` | `syntax.link_text`; `link_text.hover` uses the sage accent |
| `pr.merged` `#9a82ad` | `renamed`, `syntax.keyword`-adjacent purple accents |

Colors are plain hex; the `#RRGGBBAA` form is used only for overlays
(selection, hovers, diff backgrounds), exactly like the source theme's `…80` / `…1f` values.

## Tweaking

- Warm it up / cool it down: change `background` `#1b1815` and `editor.background` `#191613`
  together (light: `#f9f5eb` / `#f6f2e8`).
- More or less accent: `accents[]`, `text.accent`, `border.focused`, `pane.focused_border`
  (dark `#809062`, light `#4a6030`).
- Comment legibility: `syntax.comment` is intentionally low contrast — `#6a5e52` on dark,
  `#8a7e72` on light; raise toward `#7d6f60` / `#7a6e62` if it fades.
- Re-run `scripts/check-theme.ps1` after any edit, then rebuild the dev extension.

## License

MIT — see [LICENSE](LICENSE). Palette derived from OpenChamber's Fields of the Shire theme.
