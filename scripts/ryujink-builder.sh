#!/bin/bash
set -e

# 1️⃣ Install system dependencies for M1
sudo pacman -S --needed --noconfirm \
    mono sdl2 vulkan-headers vulkan-validation-layers git base-devel

# 2️⃣ Install .NET 9 SDK from AUR if not present
if ! dotnet --list-sdks | grep -q '^9'; then
    echo "Installing .NET 9 SDK (dotnet-sdk-bin) from AUR..."
    yay -S --noconfirm dotnet-sdk-bin
fi

# 3️⃣ Go to Ryujinx source folder
RYUJINX_DIR="$HOME/Games/ryujinx"
cd "$RYUJINX_DIR"

# 4️⃣ Adjust global.json if necessary
GLOBAL_SDK=$(jq -r '.sdk.version' global.json)
if ! dotnet --list-sdks | grep -q "^${GLOBAL_SDK%.*}"; then
    echo "global.json expects $GLOBAL_SDK, updating to installed SDK..."
    INSTALLED_SDK=$(dotnet --list-sdks | head -n1 | awk '{print $1}')
    jq ".sdk.version=\"$INSTALLED_SDK\"" global.json > global.json.tmp && mv global.json.tmp global.json
fi

# 5️⃣ Restore dependencies (may take a few minutes)
dotnet restore

# 6️⃣ Build standalone ARM64 release
dotnet publish -c Release -r linux-arm64 --self-contained true -p:DebugType=None

# 7️⃣ Output location
PUBLISH_DIR="$RYUJINX_DIR/src/Ryujinx/bin/Release/net8.0/linux-arm64/publish"
echo "✅ Ryujinx built successfully!"
echo "Run it with: $PUBLISH_DIR/Ryujinx"

# 8️⃣ Create launcher in $HOME/bin
mkdir -p "$HOME/bin"
LAUNCHER="$HOME/bin/ryujinx"
echo -e "#!/bin/bash\ncd $PUBLISH_DIR && ./Ryujinx" > "$LAUNCHER"
chmod +x "$LAUNCHER"
echo "Launcher created: $LAUNCHER"
echo "Add $HOME/bin to your PATH if not already: export PATH=\$HOME/bin:\$PATH"

