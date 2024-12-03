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

## Requirements

- macOS 13.0 or later
- Xcode 15.0 or later (for development)
- OpenWeatherMap API key (for weather features)

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

## Development

### Project Structure
See [PROJECT_STRUCTURE.md](docs/PROJECT_STRUCTURE.md) for detailed information about the codebase organization.

### Building
```bash
# Clean build
./Scripts/clean.sh --all
./Scripts/build.sh
```

### Scripts
- `Scripts/build.sh`: Builds the application
- `Scripts/clean.sh`: Cleans build artifacts
  - `--all`: Cleans everything
  - `--build`: Cleans only build artifacts
  - `--temp`: Cleans temporary files

## Configuration

### Weather Integration
1. Get an API key from [OpenWeatherMap](https://openweathermap.org/api)
2. The app will prompt for location permissions on first launch
3. Temperature-based recommendations will update automatically

### Notifications
1. Grant notification permissions when prompted
2. Customize reminder schedule in the app settings
3. Notifications will adapt to your usage patterns

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Weather data provided by OpenWeatherMap
- Built with SwiftUI and modern Apple frameworks
- Uses [Defaults](https://github.com/sindresorhus/Defaults) for preferences management 