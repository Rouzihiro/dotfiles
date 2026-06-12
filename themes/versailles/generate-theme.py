#!/usr/bin/env python3
"""
Theme compiler (clean + stable version)

Core idea:
- Theme file stores colors as #hex
- Script normalizes to hex (NO #)
- Templates decide formatting:
    Foot      -> raw hex
    Hyprland  -> rgb(...)
    Rofi/Wofi -> #hex

No transformations beyond normalization.
"""

import re
import sys
from pathlib import Path

try:
    import tomllib
except ModuleNotFoundError:
    try:
        import tomli as tomllib
    except ModuleNotFoundError:
        print("Error: install tomli or use Python 3.11+")
        sys.exit(1)


TEMPLATES_DIR = Path.home() / "dotfiles" / "templates"

# {{key}} or {{key:format}} (format ignored for simplicity now)
PLACEHOLDER = re.compile(r"\{\{(\w+)(?::(\w+))?\}\}")


# ─────────────────────────────
# COLOR NORMALIZATION
# ─────────────────────────────
def normalize_hex(v: str) -> str:
    """Strip leading '#' so all backends are consistent."""
    return v.lstrip("#")


# ─────────────────────────────
# LOAD THEME
# ─────────────────────────────
def load_theme(path: Path) -> dict[str, str]:
    with open(path, "rb") as f:
        data = tomllib.load(f)

    colors: dict[str, str] = {}

    for section in ("palette", "ansi"):
        raw = data.get(section, {})
        for k, v in raw.items():
            colors[k] = normalize_hex(v)

    return colors


# ─────────────────────────────
# TEMPLATE ENGINE
# ─────────────────────────────
def apply_template(content: str, colors: dict[str, str]) -> tuple[str, list[str]]:
    unknown = []

    def replace(match: re.Match) -> str:
        key = match.group(1)

        if key not in colors:
            unknown.append(key)
            return match.group(0)

        return colors[key]

    return PLACEHOLDER.sub(replace, content), unknown


# ─────────────────────────────
# MAIN
# ─────────────────────────────
def main() -> None:
    if len(sys.argv) != 2:
        print("Usage: apply_theme.py /path/to/theme.toml")
        sys.exit(1)

    theme_path = Path(sys.argv[1]).resolve()

    if not theme_path.exists():
        print(f"Theme not found: {theme_path}")
        sys.exit(1)

    if not TEMPLATES_DIR.exists():
        print(f"Templates dir not found: {TEMPLATES_DIR}")
        sys.exit(1)

    colors = load_theme(theme_path)

    templates = sorted(
        p for p in TEMPLATES_DIR.iterdir()
        if p.is_file()
    )

    print(f"Loaded {len(colors)} colors from {theme_path.name}")
    print(f"Processing {len(templates)} templates\n")

    for template in templates:
        out_path = theme_path.parent / template.name

        try:
            content = template.read_text(encoding="utf-8")
        except Exception:
            print(f"skip {template.name}")
            continue

        rendered, unknown = apply_template(content, colors)
        out_path.write_text(rendered, encoding="utf-8")

        msg = f"ok   {template.name}"
        if unknown:
            msg += f"  (unknown: {', '.join(sorted(set(unknown)))})"

        print(msg)

    print("\nDone.")


if __name__ == "__main__":
    main()
