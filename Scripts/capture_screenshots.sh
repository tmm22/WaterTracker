#!/bin/bash

# Create screenshots directory if it doesn't exist
mkdir -p docs/screenshots

# Function to capture screenshot with delay
capture_screenshot() {
    local name=$1
    local delay=$2
    
    echo "📸 Capturing $name in $delay seconds..."
    sleep $delay
    screencapture -w docs/screenshots/$name.png
}

# Build and run the app
echo "🔨 Building app..."
./Scripts/build.sh

# Launch the app
echo "🚀 Launching app..."
open WaterTracker.app

# Wait for app to launch
sleep 3

# Capture main tracking view
echo "📸 Please switch to the main tracking view..."
read -p "Press enter to capture main view screenshot..."
capture_screenshot "main_view" 2

# Capture profile view
echo "📸 Please switch to the profile view..."
read -p "Press enter to capture profile view screenshot..."
capture_screenshot "profile_view" 2

# Capture trends view
echo "📸 Please switch to the trends view..."
read -p "Press enter to capture trends view screenshot..."
capture_screenshot "trends_view" 2

# Capture dark mode versions
echo "🌙 Please switch to Dark Mode in System Settings..."
read -p "Press enter when ready to capture dark mode screenshots..."

# Capture dark mode screenshots
echo "📸 Please switch to the main tracking view..."
read -p "Press enter to capture dark mode main view screenshot..."
capture_screenshot "main_view_dark" 2

echo "📸 Please switch to the profile view..."
read -p "Press enter to capture dark mode profile view screenshot..."
capture_screenshot "profile_view_dark" 2

echo "📸 Please switch to the trends view..."
read -p "Press enter to capture dark mode trends view screenshot..."
capture_screenshot "trends_view_dark" 2

echo "✅ Screenshots captured successfully in docs/screenshots/" 