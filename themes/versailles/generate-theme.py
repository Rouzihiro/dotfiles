#!/usr/bin/env python3
"""
Theme compiler (multi-backend safe version)

Supports:
    {{key}}              -> #hex
    {{key:hex}}          -> #hex
    {{key:raw}}          -> hex (no #)   <-- FOOT / HYPR safe base
    {{key:rgb}}          -> rgb(r g b)
    {{key:rgb_spaced}}   -> r g b

All colors stored internally WITHOUT '#'
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
        print("Install tomli or use Python 3.11+")
        sys.exit(1)


TEMPLATES_DIR = Path.home() / "dotfiles" / "templates"
PLACEHOLDER = re.compile(r"\{\{(\w+)(?::(\w+))?\}\}")


# ─────────────────────────────
# COLOR HELPERS
# ─────────────────────────────
def normalize(v: str) -> str:
    return v.lstrip("#")


def to_rgb_triplet(hexv: str) -> str:
    r = int(hexv[0:2], 16)
    g = int(hexv[2:4], 16)
    b = int(hexv[4:6], 16)
    return f"{r} {g} {b}"


def format_color(v: str, fmt: str | None) -> str:
    v = normalize(v)

    if fmt is None or fmt == "hex":
        return f"#{v}"

    if fmt == "raw":
        return v

    if fmt == "rgb":
        return f"rgb({to_rgb_triplet(v)})"

    if fmt == "rgb_spaced":
        return to_rgb_triplet(v)

    return f"#{v}"


# ─────────────────────────────
# LOAD THEME
# ─────────────────────────────
def load_theme(path: Path) -> dict[str, str]:
    with open(path, "rb") as f:
        data = tomllib.load(f)

    colors = {}
    for section in ("palette", "ansi"):
        for k, v in data.get(section, {}).items():
            colors[k] = normalize(v)

    return colors


# ─────────────────────────────
# TEMPLATE ENGINE
# ─────────────────────────────
def apply_template(content: str, colors: dict[str, str]):
    unknown = []

    def repl(m: re.Match) -> str:
        key = m.group(1)
        fmt = m.group(2)

        if key not in colors:
            unknown.append(key)
            return m.group(0)

        return format_color(colors[key], fmt)

    return PLACEHOLDER.sub(repl, content), unknown


# ─────────────────────────────
# MAIN
# ─────────────────────────────
def main():
    if len(sys.argv) != 2:
        print("Usage: apply_theme.py theme.toml")
        sys.exit(1)

    theme_path = Path(sys.argv[1]).resolve()

    colors = load_theme(theme_path)

    templates = sorted(TEMPLATES_DIR.iterdir())

    print(f"Loaded {len(colors)} colors")
    print(f"Templates: {len(templates)}\n")

    for t in templates:
        out_path = theme_path.parent / t.name

        try:
            content = t.read_text()
        except Exception:
            print(f"skip {t.name}")
            continue

        rendered, unknown = apply_template(content, colors)
        out_path.write_text(rendered)

        print("ok  ", t.name, "unknown:" if unknown else "")

    print("\nDone.")


if __name__ == "__main__":
    main()
