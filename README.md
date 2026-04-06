# AstroNvim User Configuration

Personal [AstroNvim](https://github.com/AstroNvim/AstroNvim) configuration, based on the
[AstroNvim template](https://github.com/AstroNvim/template) (v6+).

This config lives at `~/.config/nvim-astronvim` and is activated via the `NVIM_APPNAME`
environment variable, allowing multiple Neovim configs to coexist.

```shell
alias nvim-astro='NVIM_APPNAME=nvim-astronvim nvim'
```

---

## Installation

### Prerequisites

- Neovim v0.11+
- [Nerd Font](https://www.nerdfonts.com/font-downloads) configured in your terminal
- `git`, `curl`, a C compiler, `ripgrep` (optional but recommended)
- `kcl-language-server` (for KCL language support — see below)

### Clone and initialize

```shell
git clone https://github.com/kukacz/astronvim_config.git ~/.config/nvim-astronvim
NVIM_APPNAME=nvim-astronvim nvim --headless -c 'quitall'
```

Neovim will install all plugins automatically on first launch.

---

## Configuration Structure

```
~/.config/nvim-astronvim/
├── init.lua                  # Bootstraps lazy.nvim (do not modify)
├── lazy-lock.json            # Pins exact plugin versions (commit this)
└── lua/
    ├── lazy_setup.lua        # lazy.nvim + AstroNvim wiring (do not modify)
    ├── community.lua         # AstroCommunity imports (language packs, etc.)
    ├── polish.lua            # Arbitrary Lua that runs last
    └── plugins/              # All user plugin specs live here
        ├── astrocore.lua     # Filetypes, keymaps, options, autocmds
        ├── astrolsp.lua      # LSP features and server configuration
        ├── astroui.lua       # Colorscheme and UI options
        ├── mason.lua         # Tools to auto-install via Mason
        ├── none-ls.lua       # Formatters and linters
        ├── treesitter.lua    # Treesitter parser configuration
        ├── user.lua          # Miscellaneous custom plugins
        └── kcl.lua           # KCL language support
```

**Where to put things:**

| What | Where |
|------|-------|
| New plugin | New file in `lua/plugins/` (one plugin per file is recommended) |
| Filetype override | `astrocore.lua` → `opts.filetypes.extension` |
| New LSP server (pre-installed) | `astrolsp.lua` → `opts.servers` |
| New LSP server (via Mason) | `mason.lua` → `opts.ensure_installed` |
| Colorscheme | New `lua/plugins/colorscheme.lua` + set in `astroui.lua` |
| Community language pack | `community.lua` → `{ import = "astrocommunity.pack.X" }` |
| Keymaps | `astrocore.lua` → `opts.mappings` |
| Vim options | `astrocore.lua` → `opts.options.opt` |

---

## Day-to-Day Usage

| Task | Command |
|------|---------|
| Check for plugin updates | `:Lazy check` or `<Leader>pu` |
| Apply plugin updates | `:Lazy update` or `<Leader>pU` |
| Update plugins + Mason packages | `:AstroUpdate` or `<Leader>pa` |
| Install a language server | `:LspInstall <name>` |
| Install a Treesitter parser | `:TSInstall <name>` |

---

## Maintenance: Tracking Upstream Template Changes

This repo was created from the [AstroNvim template](https://github.com/AstroNvim/template).
The template is tracked as a git remote called `upstream`, allowing periodic review of
improvements made by the AstroNvim team.

> **Note:** AstroNvim *plugin* updates (the core functionality) arrive automatically via
> `:Lazy update`. The `upstream` remote here tracks only the *template scaffolding* — the
> example configs in `lua/plugins/`. These change infrequently and you adopt changes manually.

### Initial setup (already done — for reference on new machines)

```shell
git remote add upstream https://github.com/AstroNvim/template.git
git fetch upstream
git tag upstream-baseline upstream/main
git config alias.upstream-check '!git fetch upstream && echo "\n=== New upstream commits ===" && git log --oneline upstream-baseline..upstream/main && echo "\n=== File changes ===" && git diff upstream-baseline upstream/main --stat'
```

### Periodic check (run monthly or after an AstroNvim major release)

```shell
git upstream-check
```

Empty output means nothing has changed in the template since your last review.

### Reviewing and adopting a specific change

```shell
# Inspect a specific file diff
git diff upstream-baseline upstream/main -- lua/plugins/astrocore.lua

# Inspect a specific commit from upstream
git show <commit-hash>
```

Manually copy over anything useful, then commit it:

```shell
git add lua/plugins/astrocore.lua
git commit -m "merge: adopt upstream fix for astrocore example"
```

### After reviewing a batch of upstream changes, advance the baseline

```shell
git tag -f upstream-baseline upstream/main
git push origin --tags
```

---

## Custom Language Support

### KCL

[KCL](https://kcl-lang.io) (`.k` files) support is configured in `lua/plugins/kcl.lua`.

**Requirements:** `kcl-language-server` must be installed and available in `$PATH`.

```shell
which kcl-language-server   # verify installation
```

**What is configured:**
- Filetype detection: `.k` → `kcl` (overrides Vim's built-in `kwt` mapping)
- Syntax highlighting and code folding via `kcl-lang/kcl.nvim`
- LSP: `kcl-language-server` auto-starts on KCL buffers via AstroLSP
