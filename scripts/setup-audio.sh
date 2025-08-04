#!/bin/sh

# Enable speaker safety daemon
echo "Enabling speakersafetyd.service..."
sudo systemctl enable speakersafetyd.service

# Enable PipeWire
echo "Enabling PipeWire services..."
systemctl --user enable pipewire
systemctl --user enable pipewire-pulse.service
systemctl --user enable wireplumber.service

# Start services immediately
echo "Starting services..."
systemctl --user start pipewire
systemctl --user start pipewire-pulse.service
systemctl --user start wireplumber.service

echo "✅ All services enabled and started!"

