# Shire — a Zed theme

A warm, earthy theme family for [Zed](https://zed.dev), adapted from OpenChamber's
**Fields of the Shire**: the same burnt-umber background and sage-green accent on the
dark side, warm paper and forest green on the light side.

- Theme family: **Shire**
- Variants: **Shire Dark** and **Shire Light** (`appearance: "dark"` / `"light"`)
- Palette sources: [`fields-of-the-shire-dark.json`](https://github.com/openchamber/openchamber/blob/main/packages/ui/src/lib/theme/themes/fields-of-the-shire-dark.json), [`fields-of-the-shire-light.json`](https://github.com/openchamber/openchamber/blob/main/packages/ui/src/lib/theme/themes/fields-of-the-shire-light.json)

## What is in this repo

```
shire/
├── extension.toml          # Zed extension manifest
├── themes/shire.json       # ← the theme itself: one family, dark + light
├── scripts/check-theme.ps1 # JSON + hex-color sanity check
├── LICENSE                 # MIT, for this project's code and theme JSON
├── THIRD_PARTY_NOTICES.md  # OpenChamber MIT notice for the derived palette
├── RELEASING.md            # registry submission checklist and PR text
└── README.md
```

`themes/shire.json` is the only file that matters for the look. Everything else
exists so Zed can install it as an extension. The extension is asset-only — there is
no Rust crate, so Zed has nothing to compile and installation is instant.

## Prerequisites

| Path | Needs |
| --- | --- |
| **A — drop-in file** | only Zed |
| **B — dev extension** | only Zed |

No Rust toolchain is involved: the extension ships only theme JSON, so Zed compiles
nothing. If you later add Rust code, install Rust via rustup (Zed adds the
`wasm32-wasip2` target itself), and on Windows also the MSVC build tools — `rustc`
needs `link.exe` for build scripts even when the final artifact is wasm.

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
There is no Rust crate in this repo, so no toolchain is needed.

1. In Zed: `ctrl-shift-p` → **zed: install dev extension** → select this folder
   (`C:\Users\valery.murashko\dev2\shire`). Zed reads `themes/shire.json` directly;
   there is no compile step, so the install finishes immediately.

2. `ctrl-shift-p` → **theme selector: toggle** → **Shire Dark** or **Shire Light**.

After editing `themes/shire.json`, run `ctrl-shift-p` → **zed: rebuild dev extensions**
(no full restart needed). Uninstall the same way: **zed: extensions** → Shire → Uninstall.

If installation fails, `ctrl-shift-p` → **zed: open log** shows why; relaunching Zed from
a terminal with `zed --foreground` prints more.

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

1. Create a public repo from this folder; `repository` in `extension.toml` already
   points at it. The extension ID is `shire-theme` — Zed's publishing prerequisites
   require a theme-only extension to be suffixed with `-theme`, and the ID may not
   contain `zed` or `extension`.
2. Fork [`zed-industries/extensions`](https://github.com/zed-industries/extensions),
   add your repo as a submodule under `extensions/shire-theme`, and add a matching
   entry to `extensions.toml`:

   ```toml
   [shire-theme]
   submodule = "extensions/shire-theme"
   version = "1.0.0"
   ```

3. Open a PR. After merge, **Shire** shows up in **zed: extensions** for everyone.
   Keep `LICENSE` at the extension root — CI rejects submissions without an accepted
   license, and this one is MIT.

Before submitting, test the theme from a clean checkout at the exact commit you push,
and keep `THIRD_PARTY_NOTICES.md` with the repo: the palette is derived from
OpenChamber's MIT-licensed theme, and MIT requires its copyright and permission
notice to travel with substantial portions of the work.

The full checklist, the exact `extensions.toml` patch and a ready-to-paste PR body
live in [RELEASING.md](RELEASING.md).

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
- AI ghost text (edit predictions) uses `predictive`: `#535d64` on dark and `#9aa3a8` on
  light, both ~2.5:1 against the editor background so they read as shadow text rather
  than code. `syntax.predictive` is kept in sync; `#RRGGBBAA` is allowed if you want it
  even fainter.
- Re-run `scripts/check-theme.ps1` after any edit, then rebuild the dev extension.

## License

This project is MIT — see [LICENSE](LICENSE).

The palette is adapted from OpenChamber's **Fields of the Shire** theme, which is
MIT-licensed (© 2025 Bohdan Triapitsyn). That copyright and permission notice is
reproduced in [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md), as MIT requires for
substantial portions of a work. The name "Fields of the Shire" is used descriptively
to credit the source; this project is not affiliated with OpenChamber.
