# WaterTracker Project Structure

## Overview
WaterTracker is organized using a clean architecture pattern with clear separation of concerns. The project follows Swift Package Manager conventions and modern SwiftUI practices.

## Directory Structure
```
WaterTracker/
├── Sources/
│   └── WaterTracker/
│       ├── Models/           # Data models and business logic
│       │   ├── Models.swift          # Core hydration tracking models
│       │   ├── UserProfile.swift     # User profile and preferences
│       │   └── ReminderManager.swift # Notification handling
│       ├── Views/            # SwiftUI views
│       │   ├── ContentView.swift        # Main tracking interface
│       │   ├── ProfileView.swift        # User profile management
│       │   └── HydrationTrendsView.swift # Statistics and trends
│       ├── Services/         # Core services
│       │   └── WeatherService.swift  # Weather API integration
│       ├── Utils/            # Utility functions
│       ├── Resources/        # App resources
│       │   └── Info.plist    # App configuration
│       └── WaterTrackerApp.swift  # Main app entry point
├── Scripts/                  # Build and maintenance scripts
│   ├── build.sh             # Main build script
│   └── clean.sh             # Cleanup script
├── docs/                     # Documentation
├── Package.swift            # Swift package manifest
└── README.md                # Project documentation

## Key Components

### Models
- `Models.swift`: Core data models for hydration tracking
  - HydrationEntry: Records individual water intake entries
  - HydrationManagerImpl: Manages water intake tracking and calculations
  
- `UserProfile.swift`: User profile management
  - ActivityLevel: User activity level classification
  - ClimateZone: User's climate zone settings
  - HealthCondition: Health-related adjustments
  
- `ReminderManager.swift`: Notification system
  - Handles hydration reminders
  - Manages notification permissions

### Views
- `ContentView.swift`: Main tracking interface
  - Water intake progress circle
  - Quick-add buttons
  - Temperature-based recommendations
  
- `ProfileView.swift`: User profile management
  - Personal information input
  - Activity level selection
  - Health conditions tracking
  
- `HydrationTrendsView.swift`: Statistics visualization
  - Historical data charts
  - Progress tracking
  - Time period selection

### Services
- `WeatherService.swift`: Weather integration
  - Location handling
  - Temperature fetching
  - Weather-based recommendations

## Build System
The project uses Swift Package Manager for dependency management and building:
- `Scripts/build.sh`: Handles the build process
- `Scripts/clean.sh`: Maintains a clean development environment

## Dependencies
- Defaults: User defaults management
- SwiftUI: UI framework
- CoreLocation: Location services
- UserNotifications: Reminder system

## Best Practices
1. File Organization:
   - Each component in its appropriate directory
   - Clear separation of concerns
   - Modular design for easy maintenance

2. Code Style:
   - Consistent SwiftUI patterns
   - Clear documentation
   - Type-safe programming

3. Architecture:
   - MVVM pattern
   - Clean architecture principles
   - Dependency injection

4. Error Handling:
   - Comprehensive error types
   - User-friendly error messages
   - Graceful degradation

## Development Workflow
1. Clean build:
   ```bash
   ./Scripts/clean.sh --all
   ./Scripts/build.sh
   ```

2. Running the app:
   ```bash
   open WaterTracker.app
   ```

3. Development best practices:
   - Run clean builds before commits
   - Test all features thoroughly
   - Update documentation as needed 