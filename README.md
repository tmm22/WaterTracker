# WaterTracker

A modern macOS application to help you stay hydrated by tracking your daily water intake, providing personalized recommendations, and monitoring your hydration trends.

## Features

- 💧 Smart Water Tracking
  - Track daily water intake with quick-add buttons
  - Visual progress indicator
  - Customizable intake amounts
  - Daily goal tracking

- 🌡️ Weather Integration
  - Real-time temperature monitoring
  - Location-based recommendations
  - Dynamic hydration goals based on weather
  - Temperature-based smart reminders

- 👤 Personalized Profiles
  - Age and weight considerations
  - Activity level adjustments
  - Climate zone settings
  - Health condition accommodations

- 📊 Comprehensive Analytics
  - Daily, weekly, and monthly trends
  - Progress visualization
  - Achievement tracking
  - Historical data analysis

- 🔔 Smart Reminders
  - Customizable notification schedule
  - Weather-based reminders
  - Activity-adjusted timing
  - Native macOS notifications

- 📱 Modern Interface
  - Adaptive UI with dark mode support
  - Beautiful animations and transitions
  - Responsive design
  - Accessibility features

- 📄 Data Management
  - Export hydration data to PDF
  - Comprehensive reports
  - Data backup and sync
  - Privacy-focused design

## Documentation

- [Project Structure](docs/PROJECT_STRUCTURE.md) - Detailed codebase organization
- [UI Guide](docs/UI_GUIDE.md) - Screenshots and interface documentation
- [Build Instructions](docs/BUILD.md) - Compilation and development guide

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
- Progress visualization

### Profile Management
- Personalized user profiles
- Activity level customization
- Weight and height tracking
- Health considerations

### Smart Recommendations
- Weather-based hydration advice
- Activity-adjusted intake goals
- Personalized reminders
- Climate adaptations

### Data Export
- PDF export functionality
- Comprehensive hydration reports
- Profile and trends included
- Data privacy controls

## Requirements

- macOS 13.0 or later
- Xcode 15.0 or later
- Swift 6.0

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 