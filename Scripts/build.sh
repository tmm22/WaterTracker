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

# Set up variables
APP_NAME="WaterTracker.app"
BUILD_DIR=".build/arm64-apple-macosx/release"
CONTENTS_DIR="$APP_NAME/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

# Clean previous build
log "Starting build process..."
rm -rf "$APP_NAME" "$BUILD_DIR"

# Check requirements
log "Checking requirements..."
if ! command -v swift &> /dev/null; then
    error "Swift is not installed"
fi

# Create app bundle structure
log "Creating app bundle structure..."
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"

# Create Info.plist
log "Creating Info.plist..."
cat > "$CONTENTS_DIR/Info.plist" << EOF
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
    <key>NSLocationUsageDescription</key>
    <string>We need your location to provide accurate temperature-based hydration recommendations.</string>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>We need your location to provide accurate temperature-based hydration recommendations.</string>
</dict>
</plist>
EOF

# Build the application
log "Building application..."
if ! swift build -c release; then
    error "Swift build failed"
fi
success "Build completed successfully"

# Copy executable and resources
log "Copying executable and resources..."
if [ -f "$BUILD_DIR/WaterTracker" ]; then
    cp "$BUILD_DIR/WaterTracker" "$MACOS_DIR/" || error "Failed to copy executable"
    chmod +x "$MACOS_DIR/WaterTracker"
else
    error "Executable not found at $BUILD_DIR/WaterTracker"
fi

# Copy resources if they exist
if [ -d "Sources/WaterTracker/Resources" ]; then
    cp -r Sources/WaterTracker/Resources/* "$RESOURCES_DIR/" || error "Failed to copy resources"
fi

success "App bundle created successfully at $APP_NAME"
echo ""
echo "To run the app:"
echo "1. Double click $APP_NAME in Finder"
echo "2. Run: open $APP_NAME" 