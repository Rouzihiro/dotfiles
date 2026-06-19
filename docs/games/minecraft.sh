#!/bin/bash

# Define variables
SERVER_DIR="$HOME/minecraft-server"
JAR_URL="https://launcher.mojang.com/v1/objects/8d6b3b4ccdd7605df403263795f8033fa0a6acfa/server.jar"
JAR_NAME="server.jar"

echo "🧱 Setting up Minecraft server in: $SERVER_DIR"
mkdir -p "$SERVER_DIR"
cd "$SERVER_DIR" || exit 1

# Download the server jar
echo "⬇ Downloading Minecraft server jar..."
curl -L -o "$JAR_NAME" "$JAR_URL" || { echo "❌ Failed to download server jar"; exit 1; }

# Accept the EULA
echo "✅ Accepting EULA..."
echo "eula=true" > eula.txt

# Generate default server.properties by running once
echo "⚙️  Generating default configs..."
java -Xmx1G -Xms1G -jar "$JAR_NAME" nogui || true

# Set offline mode
echo "🔧 Configuring server.properties for offline use..."
sed -i 's/online-mode=true/online-mode=false/' server.properties

# Add launch instructions
echo "📝 Creating run prompt for Step 2..."
cat > run-minecraft-server.sh <<EOF
#!/bin/bash
cd "\$(dirname "\$0")"
echo "🚀 Launching Minecraft Server..."
java -Xmx2G -Xms1G -jar "$JAR_NAME" nogui
EOF

chmod +x run-minecraft-server.sh

echo "✅ Setup complete!"
echo ""
echo "👉 To start the server later, run:"
echo "   $SERVER_DIR/run-minecraft-server.sh"

