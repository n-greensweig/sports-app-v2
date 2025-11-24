# Ola Ball iOS App

This directory contains the iOS implementation of Ola Ball, built with SwiftUI following Clean Architecture principles.

## Architecture Overview

The app follows a Clean Architecture approach with MVVM (Model-View-ViewModel) pattern:

- **App**: Entry point and dependency injection
- **Core**: Domain entities, repositories, and services
- **Features**: Feature-specific views and view models
- **Shared**: Reusable UI components and utilities

## Project Structure

```
OlaBall/
├── App/
│   ├── OlaBallApp.swift          # App entry point
│   └── AppCoordinator.swift       # Navigation handling
├── Core/
   - Language: **Swift**
   - Storage: None (we'll use SwiftData later)
   - Include Tests: Yes
5. Save the project in this `ios/` directory
6. Delete the default `SportsIQApp.swift` and `ContentView.swift` files that Xcode created
7. In Xcode, right-click on the `SportsIQ` group and select "Add Files to SportsIQ"
8. Select the entire `SportsIQ/` folder (App, Core, Features, Shared, Resources)
9. Make sure "Create groups" is selected (not "Create folder references")
10. Click "Add"

### Option 2: Use the Script (Coming Soon)

We'll provide a script to automate the Xcode project creation.

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Running the App

1. Open the Xcode project
2. Select a simulator (iPhone 15 Pro recommended)
3. Press `Cmd+R` to build and run

## Architecture Overview

### Domain Layer (Platform-Agnostic)

The Domain layer contains pure Swift code with no platform dependencies:
- **Entities**: Core data models (`Sport`, `Lesson`, `User`, etc.)
- **Repository Protocols**: Interfaces for data operations
- **Use Cases**: Business logic operations

### Data Layer

- **Mock Repositories**: For development without a backend
- **Network**: API client structure (ready for backend integration)
- **Local**: SwiftData models for offline support

### Presentation Layer

- **MVVM Pattern**: Views + ViewModels + Coordinators
- **SwiftUI**: Declarative UI with `@Observable` macro
- **Coordinator Pattern**: Manages navigation and dependency injection

## Design System

All UI components use the centralized design system:

- **Colors**: `Shared/UI/Styles/Colors.swift`
- **Typography**: `Shared/UI/Styles/Typography.swift`
- **Spacing**: `Shared/UI/Styles/Spacing.swift`

## Current Features

### Implemented
- ✅ Authentication with Supabase (Email, Apple, Google)
- ✅ Home screen with user stats
- ✅ Sport selection
- ✅ Module and lesson navigation
- ✅ Interactive lesson flow with Q&A
- ✅ Progress tracking
- ✅ Profile view with stats, badges, and leaderboards
- ✅ Audio feedback and haptics
- ✅ Backend integration (Supabase)

### Coming Soon
- ⏳ Spaced Repetition (Review feature)
- ⏳ Live Mode (Post-MVP)

## Development

### Mock Data

All features currently use mock repositories (`MockLearningRepository`, `MockUserRepository`) that simulate network delays and return realistic test data.

### Adding New Features

1. Create feature folder under `Features/`
2. Add Views, ViewModels, and Coordinator
3. Follow existing patterns (see `Learn/` as reference)
4. Use dependency injection via `AppCoordinator`

### Testing

Unit tests should be added for:
- ViewModels
- Use Cases
- Repository implementations

UI tests for critical user flows.

## Backend Integration

When the backend is ready:

1. Replace `MockLearningRepository` with `LearningRepositoryImpl`
2. Implement `APIClient` in `Core/Data/Network/`
3. Create DTOs for API responses
4. Update `AppCoordinator` to use real repositories

## Resources

- [CLAUDE.md](../CLAUDE.md): Comprehensive development guide
- [PROJECT_SCOPE.md](../docs/PROJECT_SCOPE.md): Product requirements
- [DATABASE_SCHEMA.md](../docs/DATABASE_SCHEMA.md): Database design

## Questions?

Refer to the [CLAUDE.md](../CLAUDE.md) file for detailed coding standards, architecture decisions, and common patterns used throughout the codebase.
