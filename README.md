# dotfiles
Versioned and shared config files

## How does this work

Here's an article that's a good intro to the workflow:
https://robots.thoughtbot.com/manage-team-and-personal-dotfiles-together-with-rcm

Using [rcm](https://github.com/thoughtbot/rcm), this workflow manages your config dotfiles in version control and symlinks them into your home directory.

## Grok Build CLI privacy

Whole-repo / session-trace upload and product telemetry are disabled by default:

```bash
# after clone / rcup, or standalone:
./scripts/install-grok-privacy.sh
```

- Fragment: `grok/privacy.toml` (also linked as `~/.grok/privacy.toml` via rcm)
- Merges into `~/.grok/config.toml` without wiping MCP/permission settings
- On Raspberry Pi: also run from `scripts/rpi/0_setup.sh`
