# Releasing Shire to the Zed extension registry

Current state: extension ID `shire-theme`, version `1.0.0`, family `Shire` with
`Shire Dark` and `Shire Light`, MIT license at the extension root.

The requirements that CI and reviewers check are already satisfied:

- theme-only extension, ID suffixed with `-theme`, no `zed`/`extension` in the ID
- `LICENSE` at the root (MIT is on Zed's accepted list)
- one theme family file in `themes/`, valid against schema v0.2.0
- `repository` in `extension.toml` points at the public repo
- palette attribution in `THIRD_PARTY_NOTICES.md`

## 1. Publish the commit you intend to submit

The registry pins a commit, so everything must be pushed first:

```sh
git push
git rev-parse HEAD   # the SHA the submodule will point at
```

## 2. Test that commit in Zed

Install the dev extension (`zed: install dev extension`, pick this folder) and verify:
both variants in the theme picker, edit-prediction ghost text, inlay hints, terminal
ANSI/bright/dim colors, git panel status colors, and `"mode": "system"` switching.
The publishing prerequisites require testing at the submitted commit.

## 3. Fork and clone the registry

Fork `zed-industries/extensions` to your personal account, then:

```sh
git clone https://github.com/Emestie/extensions
cd extensions
git submodule init
git submodule update
```

## 4. Add the submodule

HTTPS only — SSH URLs are rejected. The directory name must equal the extension ID.

```sh
git submodule add https://github.com/Emestie/zed-shire-theme.git extensions/shire-theme
```

## 5. Add the entry to `extensions.toml`

```diff
+[shire-theme]
+submodule = "extensions/shire-theme"
+version = "1.0.0"
```

`version` must match `extension.toml` at the pinned commit. If `extensions.toml` is
kept sorted, `pnpm sort-extensions` places the block for you.

## 6. Sort and open the PR

```sh
corepack enable
pnpm install
pnpm sort-extensions
git add .gitmodules extensions.toml extensions/shire-theme
git commit -m "Add Shire theme"
git push
```

Open the PR against `zed-industries/extensions` with this body:

```md
Adds **Shire**, a warm, earthy theme family ported to Zed with dark and light variants.

- `Shire Dark` — burnt-umber base (`#1b1815`), sage accent (`#809062`)
- `Shire Light` — warm paper base (`#f9f5eb`), forest accent (`#4a6030`)
- Covers editor, panels, tabs, terminal (ANSI, bright and dim), git status, diffs,
  search matches, diagnostics and collaboration player colors
- Edit-prediction ghost text is deliberately dimmed (`predictive`) so it cannot be
  mistaken for committed code
- Ships only `themes/shire.json`; no grammars, language servers or binaries

The palette is adapted from OpenChamber's MIT-licensed **Fields of the Shire** theme.
The required copyright and permission notice is reproduced in `THIRD_PARTY_NOTICES.md`.
The name is used descriptively; this extension is not affiliated with or endorsed by
OpenChamber.

Tested in Zed on Windows at the submitted commit: both variants, edit predictions,
terminal colors and the git panel.
```

## 7. Review rules

- one extension per PR, at most three open PRs
- the submodule commit must be on a branch, never detached
- respond to maintainer feedback within 3 weeks or the PR is closed
- keep the repo public; CI rejects submissions without an accepted license

## Releasing an update

1. Bump `version` in `extension.toml`, commit, push.
2. Open a PR against `zed-industries/extensions`:
   ```sh
   git submodule update --remote extensions/shire-theme
   ```
3. Update the matching `version` in `extensions.toml`, run `pnpm sort-extensions`,
   commit and push.

Tags are optional — the registry pins the submodule commit, not a tag.
