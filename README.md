# WaterTracker

A modern macOS application to help you stay hydrated by tracking your daily water intake, providing personalized recommendations, and monitoring your hydration trends.

## Features

- 💧 Track daily water intake
- 🌡️ Temperature-based hydration recommendations
- 📊 View hydration trends and statistics
- 👤 Customizable user profiles
- 🔔 Smart hydration reminders
- 📱 Native macOS notifications
- 📄 Export hydration data to PDF
- 🌤️ Weather integration for smart recommendations

## Requirements

- macOS 13.0 or later
- Xcode 15.0 or later
- Swift 6.0

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/WaterTracker.git
cd WaterTracker
```

2. Build the application:
```bash
./Scripts/build.sh
```

3. Run the application:
```bash
open WaterTracker.app
```

## Project Structure

```
WaterTracker/
├── Sources/
│   └── WaterTracker/
│       ├── Models/         # Data models and business logic
│       ├── Views/          # SwiftUI views
│       ├── Utils/          # Utility functions and helpers
│       └── Resources/      # Assets and resources
├── Scripts/
│   ├── build.sh           # Build script
│   ├── clean.sh           # Cleanup script
│   └── dev.sh             # Development utilities
└── Package.swift          # Swift package manifest
```

## Development

### Available Scripts

- `Scripts/build.sh`: Builds the application
- `Scripts/clean.sh`: Cleans build artifacts and caches
- `Scripts/dev.sh`: Development utilities and helpers

### Building

```bash
# Clean build
./Scripts/clean.sh
./Scripts/build.sh
```

## Features in Detail

### Water Tracking
- Manual input of water intake
- Customizable measurement units
- Daily goal tracking

### Profile Management
- Personalized user profiles
- Activity level customization
- Weight and height tracking

### Smart Recommendations
- Weather-based hydration advice
- Activity-adjusted intake goals
- Personalized reminders

### Data Export
- PDF export functionality
- Comprehensive hydration reports
- Profile and trends included

## License

This project is licensed under the MIT License - see the LICENSE file for details. 