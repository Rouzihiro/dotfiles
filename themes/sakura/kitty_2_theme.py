#!/usr/bin/env python3
"""
Generate a semantic theme.toml from a Kitty config file.
The TOML is a flat color data store for downstream scripts to consume.

Usage: python kitty_to_theme.py /path/to/kitty.conf
"""

import re
import sys
from pathlib import Path
from typing import Dict

# ----------------------------------------------------------------------
# Color helpers
# ----------------------------------------------------------------------

def hex_to_rgb(hex_color: str) -> tuple[int, int, int]:
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def luminance(rgb: tuple[int, int, int]) -> float:
    """Relative luminance (0–1) per WCAG 2.1."""
    def linearize(c: int) -> float:
        v = c / 255.0
        return v / 12.92 if v <= 0.03928 else ((v + 0.055) / 1.055) ** 2.4
    r, g, b = [linearize(x) for x in rgb]
    return 0.2126 * r + 0.7152 * g + 0.0722 * b

def contrast_color(bg_hex: str, dark: str = "#090c0c", light: str = "#d7ccc8") -> str:
    """Return whichever of dark/light has better contrast against bg_hex."""
    return dark if luminance(hex_to_rgb(bg_hex)) > 0.5 else light

def blend(c1: str, c2: str, ratio: float = 0.5) -> str:
    """Linear blend: ratio=0 → c1, ratio=1 → c2."""
    r1, g1, b1 = hex_to_rgb(c1)
    r2, g2, b2 = hex_to_rgb(c2)
    r = int(r1 * (1 - ratio) + r2 * ratio)
    g = int(g1 * (1 - ratio) + g2 * ratio)
    b = int(b1 * (1 - ratio) + b2 * ratio)
    return f"#{r:02x}{g:02x}{b:02x}"

# ----------------------------------------------------------------------
# Parse kitty.conf (with basic include support)
# ----------------------------------------------------------------------

def parse_kitty_conf(path: Path, _visited: set[Path] | None = None) -> Dict[str, str]:
    """
    Extract color definitions from a kitty.conf file.
    Follows `include` directives one level deep to handle the common
    pattern of `include current-theme.conf`.
    """
    if _visited is None:
        _visited = set()
    path = path.resolve()
    if path in _visited:
        return {}
    _visited.add(path)

    colors: Dict[str, str] = {}
    color_keys = {
        'background', 'foreground', 'cursor',
        'selection_background', 'selection_foreground',
    }

    with open(path) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith('#'):
                continue

            # Handle include directives
            include_match = re.match(r'^include\s+(.+)$', line)
            if include_match:
                include_path = Path(include_match.group(1).strip())
                if not include_path.is_absolute():
                    include_path = path.parent / include_path
                if include_path.exists():
                    colors.update(parse_kitty_conf(include_path, _visited))
                continue

            match = re.match(r'^(\w+)\s+([#\w]+)$', line) or \
                    re.match(r'^(\w+)\s*=\s*([#\w]+)$', line)
            if match:
                key, value = match.groups()
                if key.startswith('color') or key in color_keys:
                    colors[key] = value

    return colors

# ----------------------------------------------------------------------
# Build semantic palette
# ----------------------------------------------------------------------

def build_palette(k: Dict[str, str]) -> Dict[str, str]:
    """
    Derive a named semantic palette from raw Kitty colors.

    Semantic slots:
      bg          – main background
      bg_subtle   – slightly lighter bg (blend bg→fg 15%)
      bg_muted    – more visible surface (blend bg→fg 30%)
      fg          – main foreground
      fg_dim      – dimmed foreground (blend fg→bg 40%)
      accent      – primary highlight / interactive color
      fg_on_accent – readable text color when placed on accent bg
      success     – positive state
      warning     – warning state
      error       – error / destructive state
      cursor      – cursor color
      sel_bg      – selection background
      sel_fg      – selection foreground
    """
    bg     = k.get('background', '#1e1e1e')
    fg     = k.get('foreground', '#dcdcdc')
    cursor = k.get('cursor', fg)
    sel_bg = k.get('selection_background', fg)
    sel_fg = k.get('selection_foreground', bg)

    # Derive semantic slots from ANSI colors where they have
    # conventional meaning; fall back to blends so the result is
    # always valid regardless of theme.
    accent  = k.get('color4') or k.get('color12') or k.get('color1') or fg
    success = k.get('color2') or k.get('color10') or fg
    warning = k.get('color3') or k.get('color11') or fg
    error   = k.get('color1') or k.get('color9')  or accent

    return {
        'bg':          bg,
        'bg_subtle':   blend(bg, fg, 0.15),
        'bg_muted':    blend(bg, fg, 0.30),
        'fg':          fg,
        'fg_dim':      blend(fg, bg, 0.40),
        'accent':      accent,
        'fg_on_accent': contrast_color(accent, dark=bg, light=fg),
        'success':     success,
        'warning':     warning,
        'error':       error,
        'cursor':      cursor,
        'sel_bg':      sel_bg,
        'sel_fg':      sel_fg,
    }

# ----------------------------------------------------------------------
# Generate flat TOML
# ----------------------------------------------------------------------

def generate_toml(palette: Dict[str, str], ansi: Dict[str, str]) -> str:
    """
    Emit a flat TOML file: one [palette] section for semantic colors
    and one [ansi] section for the raw 16-color table.
    Downstream scripts read what they need.
    """
    lines = ["# Auto-generated by kitty_to_theme.py — do not edit by hand", ""]

    lines.append("[palette]")
    for key, value in palette.items():
        lines.append(f'{key} = "{value}"')

    lines.append("")
    lines.append("[ansi]")
    for i in range(16):
        value = ansi.get(f'color{i}', palette['fg'])
        lines.append(f'color{i} = "{value}"')

    lines.append("")
    return "\n".join(lines)

# ----------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------

def main() -> None:
    if len(sys.argv) != 2:
        print("Usage: python kitty_to_theme.py /path/to/kitty.conf")
        sys.exit(1)

    kitty_conf_path = Path(sys.argv[1])
    if not kitty_conf_path.exists():
        print(f"Error: {kitty_conf_path} not found.")
        sys.exit(1)

    raw = parse_kitty_conf(kitty_conf_path)
    if not raw:
        print("Error: no color definitions found (check includes too).")
        sys.exit(1)

    palette = build_palette(raw)
    toml_content = generate_toml(palette, raw)

    output_path = kitty_conf_path.parent / "theme.toml"
    output_path.write_text(toml_content)
    print(f"Theme written to {output_path}")

if __name__ == "__main__":
    main()
