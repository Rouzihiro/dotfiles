import re
import os
import shutil
import colorsys
from pathlib import Path
from . import BaseGenerator


class I3blocksGenerator(BaseGenerator):
    def default_filename(self):
        return "config"

    # ------------------------------------------------------------------
    # Contrast helpers (WCAG relative luminance)
    # ------------------------------------------------------------------

    def _relative_luminance(self, hex_color):
        """Return the WCAG relative luminance of a hex color string."""
        hex_color = hex_color.lstrip('#')
        if len(hex_color) not in (6, 8):
            return 0
        r, g, b = (int(hex_color[i:i+2], 16) / 255 for i in (0, 2, 4))

        def linearize(c):
            return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4

        r, g, b = linearize(r), linearize(g), linearize(b)
        return 0.2126 * r + 0.7152 * g + 0.0722 * b

    def _contrast_ratio(self, hex1, hex2):
        """Return the WCAG contrast ratio between two hex colors (1–21)."""
        l1 = self._relative_luminance(hex1)
        l2 = self._relative_luminance(hex2)
        lighter, darker = max(l1, l2), min(l1, l2)
        return (lighter + 0.05) / (darker + 0.05)

    def _best_foreground(self, colors, background_key='sigbg'):
        """
        Pick the highest-contrast color from the resolved palette against
        the given background key.

        Search order:
          1. Semantically meaningful names (foreground, sig1–3)
          2. color1–color16 in order

        Skips colors with contrast < 1.5 (indistinguishable from bg).
        Warns if nothing clears WCAG AA (4.5:1) but always returns something.
        """
        bg = colors.get(background_key, '#000000')

        priority   = ['foreground', 'sig1', 'sig2', 'sig3']
        dynamic    = [f'color{i}' for i in range(1, 17)]
        candidates = priority + dynamic

        best_color, best_ratio = '#ffffff', 0

        for key in candidates:
            c = colors.get(key, '')
            if not c:
                continue
            ratio = self._contrast_ratio(bg, c)
            if ratio < 1.5:
                continue
            if ratio > best_ratio:
                best_ratio = ratio
                best_color = c

        if best_ratio < 4.5:
            print(
                f"   ⚠  Best contrast ratio is only {best_ratio:.1f}:1 — "
                "no color in the palette clears WCAG AA (4.5:1). "
                "Consider adding a light neutral to the theme."
            )
        else:
            print(f"   ✓ Best foreground contrast: {best_ratio:.1f}:1 → {best_color}")

        return best_color

    # ------------------------------------------------------------------
    # Color file parsing
    # ------------------------------------------------------------------

    def _parse_colors_file(self, filepath):
        """Parse a rofi .rasi file and extract the color definitions we need."""
        target_colors = {
            'sigbg', 'sig1', 'sig2', 'sig3', 'foreground',
            *[f'color{i}' for i in range(1, 17)],
        }

        with open(filepath, 'r') as f:
            content = f.read()

        def strip_comments(text):
            return re.sub(r'/\*.*?\*/', '', text)

        clean_content = strip_comments(content)

        # First pass: collect all bare hex values so we can resolve @aliases
        raw = {}
        for match in re.finditer(
            r'(color\d+|background|foreground|selection-background'
            r'|selection-foreground|border-color)'
            r'\s*:\s*(#[0-9a-fA-F]{6,8})',
            clean_content, re.IGNORECASE
        ):
            raw[match.group(1).lower()] = match.group(2)

        def resolve_value(key):
            """Return the hex color for key, following @alias references."""
            pattern = rf'{re.escape(key)}\s*:\s*([^;{{\n]+)'
            m = re.search(pattern, clean_content, re.IGNORECASE)
            if not m:
                return ''
            val = m.group(1).strip().strip('"').strip("'").strip()
            if val.startswith('@'):
                ref = val[1:].strip()
                return raw.get(ref.lower(), '')
            if val.startswith('#'):
                return val[:7] if len(val) > 7 else val   # drop alpha
            return ''

        colors = {}
        for name in target_colors:
            resolved = resolve_value(name)
            if resolved:
                colors[name] = resolved

        return colors

    # ------------------------------------------------------------------
    # Template merging
    # ------------------------------------------------------------------

    def _merge_template(self, template_content, colors):
        """Replace {{PLACEHOLDER}} tokens in the template with resolved hex values."""
        for name, color in colors.items():
            placeholder = f"{{{{{name.upper()}}}}}"
            template_content = template_content.replace(placeholder, color)
        return template_content

    # ------------------------------------------------------------------
    # Theme discovery
    # ------------------------------------------------------------------

    def _find_all_themes(self, themes_dir):
        """Find every theme folder that contains a rofi.rasi file."""
        themes = []
        themes_dir = Path(themes_dir)

        if not themes_dir.exists():
            print(f"❌ Themes directory not found: {themes_dir}")
            return themes

        for root, dirs, files in os.walk(themes_dir):
            root_path = Path(root)
            if 'rofi.rasi' in files:
                theme_name = root_path.name
                rofi_path  = root_path / 'rofi.rasi'
                themes.append((theme_name, rofi_path, root_path))

        return themes

    # ------------------------------------------------------------------
    # Main entry point
    # ------------------------------------------------------------------

    def generate(self, output_file=None):
        output_file = output_file or self.default_filename()

        home          = Path.home()
        themes_dir    = home / "dotfiles" / "themes"
        template_file = (
            home / "dotfiles" / "projects" / "templates" / "i3blocks.template"
        )

        print("🎨 i3blocks Config Generator")
        print("=" * 60)

        if not template_file.exists():
            print(f"❌ Template file not found: {template_file}")
            return None

        try:
            with open(template_file, 'r') as f:
                template_content = f.read()
        except Exception as e:
            print(f"❌ Error reading template file: {e}")
            return None

        print("\n1. Discovering themes...")
        themes = self._find_all_themes(themes_dir)

        if not themes:
            print("❌ No themes found with rofi.rasi!")
            return None

        print(f"   Found {len(themes)} theme(s)")

        print("\n2. Generating i3blocks config files...")
        print("   (Existing configs will be backed up as config.backup)")
        print("=" * 60)

        named_colors = ['sigbg', 'sig1', 'sig2', 'sig3', 'foreground']
        successful   = 0

        for theme_name, rofi_path, theme_folder in themes:
            print(f"\n🎨 Processing: {theme_name}")

            colors = self._parse_colors_file(rofi_path)

            # Report named color resolution
            missing_named = [c for c in named_colors if c not in colors]
            if missing_named:
                print(f"   ⚠  Could not resolve named colors: {missing_named}")

            found_numbered = [f'color{i}' for i in range(1, 17) if f'color{i}' in colors]
            print(
                f"   ✓ Resolved {len(named_colors) - len(missing_named)}/{len(named_colors)} "
                f"named colors, {len(found_numbered)}/16 numbered colors "
                f"({found_numbered[0]}–{found_numbered[-1]} range)"
                if found_numbered else
                f"   ✓ Resolved {len(named_colors) - len(missing_named)}/{len(named_colors)} "
                "named colors, 0 numbered colors"
            )

            for k in named_colors:
                print(f"      {k:>12} = {colors.get(k, '(not found)')}")

            # Inject best accessible foreground for use as {{BEST_FG}} if needed
            colors['best_fg'] = self._best_foreground(colors)

            merged_content = self._merge_template(template_content, colors)

            # Backup existing config if present
            config_output = theme_folder / "i3blocks.config"
            if config_output.exists():
                backup_path = theme_folder / "i3blocks.config.backup"
                shutil.copy2(config_output, backup_path)
                print(f"   📦 Backed up existing config")

            with open(config_output, 'w') as f:
                f.write(merged_content)

            successful += 1
            print(f"   ✅ Generated {config_output}")

        print("\n" + "=" * 60)
        print("✨ Summary")
        print(f"   • Total themes found:       {len(themes)}")
        print(f"   • Successfully generated:   {successful}/{len(themes)}")

        if successful > 0:
            print("\n📁 Generated i3blocks config files:")
            for theme_name, _, theme_folder in themes:
                cfg    = theme_folder / "i3blocks.config"
                backup = theme_folder / "i3blocks.config.backup"
                if cfg.exists():
                    tag = " (with backup)" if backup.exists() else ""
                    print(f"   📄 {theme_name}/i3blocks.config{tag}")

        if themes:
            return str(themes[-1][2] / "i3blocks.config")
        return None
