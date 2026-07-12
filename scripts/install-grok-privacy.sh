#!/usr/bin/env bash
# Merge Grok privacy kill-switches into ~/.grok/config.toml (idempotent).
# Safe on macOS and Raspberry Pi. Does not wipe existing MCP/permission config.
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FRAGMENT="${GROK_PRIVACY_FRAGMENT:-$DOTFILES_ROOT/grok/privacy.toml}"
# also accept rcm-linked fragment
if [[ ! -f "$FRAGMENT" && -f "$HOME/.grok/privacy.toml" ]]; then
  FRAGMENT="$HOME/.grok/privacy.toml"
fi
CFG="${GROK_CONFIG:-$HOME/.grok/config.toml}"

if [[ ! -f "$FRAGMENT" ]]; then
  echo "error: privacy fragment not found at $FRAGMENT" >&2
  exit 1
fi

mkdir -p "$(dirname "$CFG")"

python3 - "$CFG" "$FRAGMENT" <<'PY'
import re
import sys
from pathlib import Path

cfg_path = Path(sys.argv[1])
frag_path = Path(sys.argv[2])

MARKER_BEGIN = "# --- grok privacy (managed by install-grok-privacy.sh) ---"
MARKER_END = "# --- end grok privacy ---"

desired_block = f"""
{MARKER_BEGIN}
# Source: {frag_path}
# Whole-repo trace/codebase upload off; product telemetry off.
# Does not stop model-turn data for files the agent reads.
[features]
telemetry = false

[telemetry]
trace_upload = false
mixpanel_enabled = false

[harness]
disable_codebase_upload = true
{MARKER_END}
""".lstrip("\n")

if cfg_path.exists():
    text = cfg_path.read_text()
else:
    text = "# ~/.grok/config.toml — created by install-grok-privacy.sh\n"

# Remove prior managed block if present
if MARKER_BEGIN in text:
    text = re.sub(
        re.escape(MARKER_BEGIN) + r".*?" + re.escape(MARKER_END) + r"\n?",
        "",
        text,
        flags=re.S,
    )

# Also strip the older one-off comment block if present
text = re.sub(
    r"\n*# Privacy: disable whole-repo trace/codebase upload.*?\n\[harness\]\ndisable_codebase_upload = true\n?",
    "\n",
    text,
    flags=re.S,
)

# If unmanaged sections already set the keys correctly, still replace with
# managed block so future updates are one place — but first drop conflicting
# key lines inside existing [features]/[telemetry]/[harness] only when we
# re-append the managed block at the end (TOML last-key-wins is NOT guaranteed
# across tables; duplicate tables merge in most parsers with last key winning
# for same key — grok's toml crate typically last-wins for keys).

def ensure_no_conflicting_true(text: str) -> str:
    """Flip known keys if they appear as true outside managed block."""
    replacements = [
        (r"(?m)^(\s*telemetry\s*=\s*)true(\s*(?:#.*)?)?$", r"\1false\2"),
        (r"(?m)^(\s*trace_upload\s*=\s*)true(\s*(?:#.*)?)?$", r"\1false\2"),
        (r"(?m)^(\s*mixpanel_enabled\s*=\s*)true(\s*(?:#.*)?)?$", r"\1false\2"),
        (r"(?m)^(\s*disable_codebase_upload\s*=\s*)false(\s*(?:#.*)?)?$", r"\1true\2"),
    ]
    for pat, rep in replacements:
        text = re.sub(pat, rep, text)
    return text

text = ensure_no_conflicting_true(text)
text = text.rstrip() + "\n\n" + desired_block
if not text.endswith("\n"):
    text += "\n"

cfg_path.write_text(text)
print(f"updated {cfg_path}")
print("  [features] telemetry = false")
print("  [telemetry] trace_upload = false, mixpanel_enabled = false")
print("  [harness] disable_codebase_upload = true")
PY

# also install fragment into ~/.grok for reference / rcm-less machines
cp "$FRAGMENT" "$HOME/.grok/privacy.toml"
echo "wrote $HOME/.grok/privacy.toml"
echo "done. restart grok for changes to take effect."
