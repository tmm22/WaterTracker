#!/bin/bash

# Exit on error
set -e

# Color output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print status messages
log() {
    echo -e "${BLUE}🔧 $1${NC}"
}

# Function to print success messages
success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Function to print error messages and exit
error() {
    echo -e "${RED}❌ Error: $1${NC}"
    exit 1
}

# Clean up
log "Cleaning previous build artifacts..."
rm -rf .build WaterTracker/.build WaterTracker.app || true

# Create fresh build directory
log "Setting up build environment..."
mkdir -p WaterTracker.app/Contents/{MacOS,Resources}

# Build the application
log "Building application..."
if ! swift build -c release; then
    error "Swift build failed"
fi

# Copy executable
log "Installing application..."
cp -f .build/release/WaterTracker WaterTracker.app/Contents/MacOS/ || error "Failed to copy executable"
chmod +x WaterTracker.app/Contents/MacOS/WaterTracker

# Create Info.plist
log "Creating Info.plist..."
cat > WaterTracker.app/Contents/Info.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleExecutable</key>
    <string>WaterTracker</string>
    <key>CFBundleIdentifier</key>
    <string>com.example.watertracker</string>
    <key>CFBundleName</key>
    <string>WaterTracker</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSSupportsAutomaticGraphicsSwitching</key>
    <true/>
</dict>
</plist>
EOF

success "Build complete! You can now run WaterTracker.app"
echo ""
echo "To run the app, you can:"
echo "1. Double click WaterTracker.app in Finder"
echo "2. Run: open WaterTracker.app" 