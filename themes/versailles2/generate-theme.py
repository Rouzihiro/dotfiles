#!/usr/bin/env python3
"""
Apply a theme.toml to all templates in ~/dotfiles/templates/.
Placeholders in templates use {{key}} syntax, where key is any
entry from [palette] or [ansi] in theme.toml.

Usage: python apply_theme.py /path/to/theme.toml
Output files are written next to theme.toml, mirroring template filenames.
Templates are never modified.
"""

import re
import sys
from pathlib import Path

try:
    import tomllib
except ModuleNotFoundError:
    # Python < 3.11
    try:
        import tomli as tomllib
    except ModuleNotFoundError:
        print("Error: requires Python 3.11+ or `pip install tomli`")
        sys.exit(1)

TEMPLATES_DIR = Path.home() / "dotfiles" / "templates"
PLACEHOLDER = re.compile(r"\{\{(\w+)\}\}")


def load_theme(toml_path: Path) -> dict[str, str]:
    """Flatten [palette] and [ansi] into one lookup dict."""
    with open(toml_path, "rb") as f:
        data = tomllib.load(f)

    colors: dict[str, str] = {}
    for section in ("palette", "ansi"):
        colors.update(data.get(section, {}))
    return colors


def apply_template(content: str, colors: dict[str, str]) -> tuple[str, list[str]]:
    """
    Replace all {{key}} placeholders.
    Returns (rendered_content, list_of_unknown_keys).
    """
    unknown: list[str] = []

    def replace(match: re.Match) -> str:
        key = match.group(1)
        if key in colors:
            return colors[key]
        unknown.append(key)
        return match.group(0)  # leave unknown placeholders intact

    return PLACEHOLDER.sub(replace, content), unknown


def main() -> None:
    if len(sys.argv) != 2:
        print("Usage: python apply_theme.py /path/to/theme.toml")
        sys.exit(1)

    toml_path = Path(sys.argv[1]).resolve()
    if not toml_path.exists():
        print(f"Error: {toml_path} not found.")
        sys.exit(1)

    output_dir = toml_path.parent

    if not TEMPLATES_DIR.exists():
        print(f"Error: templates directory not found: {TEMPLATES_DIR}")
        sys.exit(1)

    colors = load_theme(toml_path)
    templates = [p for p in TEMPLATES_DIR.iterdir() if p.is_file()]

    if not templates:
        print(f"No files found in {TEMPLATES_DIR}")
        sys.exit(0)

    print(f"Loaded {len(colors)} color entries from {toml_path.name}")
    print(f"Processing {len(templates)} template(s) → {output_dir}\n")

    for template in sorted(templates):
        out_path = output_dir / template.name

        try:
            content = template.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            print(f"  skip  {template.name} (binary file)")
            continue

        rendered, unknown = apply_template(content, colors)

        out_path.write_text(rendered, encoding="utf-8")

        status = f"  ok    {template.name}"
        if unknown:
            status += f"  [unknown keys: {', '.join(sorted(set(unknown)))}]"
        print(status)

    print("\nDone.")


if __name__ == "__main__":
    main()
