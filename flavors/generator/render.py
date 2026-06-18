from __future__ import annotations

from pathlib import Path

try:
    from jinja2 import Environment, FileSystemLoader, StrictUndefined, TemplateError
except ModuleNotFoundError as exc:  # pragma: no cover - import-time dependency guard
    raise RuntimeError("Jinja2 not found. Install it with: sudo apt install python3-jinja2") from exc

from .config import BASE_DIR, OUTPUTS, PALETTES_DIR, ROOT_DIR
from .palette import build_mapping, load_palette


class ThemeError(Exception):
    pass


def generate_theme(theme_name: str) -> None:
    theme_file = PALETTES_DIR / f"{theme_name}.toml"

    if not theme_file.exists():
        raise ThemeError(f"theme file not found: {theme_file}")

    mapping = build_mapping(load_palette(theme_file))
    env = _jinja_env(BASE_DIR)

    print(f"Generating theme: {theme_name}")

    for template_name, rel_out_path in OUTPUTS.items():
        render_template(env, template_name, rel_out_path, mapping)


def render_template(
    env: Environment,
    template_name: str,
    rel_out_path: str,
    mapping: dict[str, str],
) -> None:
    template_path = BASE_DIR / template_name

    if not template_path.exists():
        print(f"Warning: template not found: {template_path}")
        return

    try:
        rendered = env.get_template(template_name).render(**mapping)
    except TemplateError as exc:
        raise ThemeError(f"failed rendering {template_name}: {exc}") from exc

    out_path = ROOT_DIR / rel_out_path
    write_output(out_path, rendered)
    print(f"  -> Created {rel_out_path}")


def write_output(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)

    if path.is_symlink():
        path.unlink()

    path.write_text(content, encoding="utf-8")


def _jinja_env(base_dir: Path) -> Environment:
    return Environment(
        loader=FileSystemLoader(base_dir),
        undefined=StrictUndefined,
        autoescape=False,
        keep_trailing_newline=True,
        trim_blocks=False,
        lstrip_blocks=False,
    )
