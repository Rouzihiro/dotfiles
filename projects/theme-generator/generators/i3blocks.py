#!/usr/bin/env python3

import re
import os
import shutil
from pathlib import Path
from . import BaseGenerator


class I3blocksGenerator(BaseGenerator):
    def default_filename(self):
        return "config"

    def _parse_colors_file(self, filepath):
        """Parse rofi .rasi file and extract the specific color definitions we need."""
        colors = {}

        target_colors = {
            'sigbg', 'sig1', 'sig2', 'sig3',
            'foreground', 'color1', 'color11',
        }

        with open(filepath, 'r') as f:
            content = f.read()

        # Strip inline /* ... */ comments from each line
        def strip_comments(text):
            return re.sub(r'/\*.*?\*/', '', text)

        clean_content = strip_comments(content)

        # Build a lookup of @colorN aliases → resolved hex values
        # First pass: collect all bare hex values
        raw = {}
        for match in re.finditer(
            r'(color\d+|background|foreground|selection-background|selection-foreground|border-color)'
            r'\s*:\s*(#[0-9a-fA-F]{6,8})',
            clean_content, re.IGNORECASE
        ):
            raw[match.group(1).lower()] = match.group(2)

        def resolve_value(key):
            """Return the hex colour for key, following @alias references."""
            pattern = rf'{re.escape(key)}\s*:\s*([^;{{\n]+)'
            m = re.search(pattern, clean_content, re.IGNORECASE)
            if not m:
                return '#ffffff'
            val = m.group(1).strip().strip('"').strip("'").strip()
            if val.startswith('@'):
                ref = val[1:].strip()
                return raw.get(ref.lower(), '#ffffff')
            if val.startswith('#'):
                return val[:7] if len(val) > 7 else val   # drop alpha if present
            return '#ffffff'

        for name in target_colors:
            colors[name] = resolve_value(name)

        return colors

    def _merge_template(self, template_content, colors):
        """Replace {{PLACEHOLDER}} tokens in the template with resolved hex values."""
        for name, color in colors.items():
            placeholder = f"{{{{{name.upper()}}}}}"
            template_content = template_content.replace(placeholder, color)
        return template_content

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
                rofi_path = root_path / 'rofi.rasi'
                themes.append((theme_name, rofi_path, root_path))

        return themes

    def generate(self, output_file=None):
        output_file = output_file or self.default_filename()

        home = Path.home()
        themes_dir   = home / "dotfiles" / "themes"
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

        required_colors = ['sigbg', 'sig1', 'sig2', 'sig3',
                           'foreground', 'color1', 'color11']
        successful = 0

        for theme_name, rofi_path, theme_folder in themes:
            print(f"\n🎨 Processing: {theme_name}")

            colors = self._parse_colors_file(rofi_path)

            # Show extracted colours & warn about missing ones
            missing = [c for c in required_colors if colors.get(c) == '#ffffff']
            if missing:
                print(f"   ⚠  Could not resolve: {missing} (defaulting to #ffffff)")

            found = sum(1 for c in required_colors if c in colors)
            print(f"   ✓ Resolved {found}/{len(required_colors)} colours")
            for k in required_colors:
                print(f"      {k:>12} = {colors.get(k, '#ffffff')}")

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
                cfg = theme_folder / "i3blocks.config"
                if cfg.exists():
                    backup = theme_folder / "i3blocks.config.backup"
                    tag = " (with backup)" if backup.exists() else ""
                    print(f"   📄 {theme_name}/i3blocks.config{tag}")

        if themes:
            return str(themes[-1][2] / "i3blocks.config")
        return None
