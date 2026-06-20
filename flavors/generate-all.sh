for f in ~/flavors/palettes/*.toml; do
  name=$(basename "$f" .toml)
  echo "Generating $name..."
  python3 ~/flavors/generate.py "$name"
done
