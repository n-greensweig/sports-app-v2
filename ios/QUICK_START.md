# Quick Start Guide

## Creating the Xcode Project

Follow these steps to set up the Xcode project:

### 1. Create New Project in Xcode

```
File → New → Project
```

**Template Selection:**
- Platform: iOS
- Template: App
- Click "Next"

**Project Options:**
- Product Name: `SportsIQ`
- Team: Select your team (or "None" for development)
- Organization Identifier: `com.sportsiq` (or your own)
- Interface: **SwiftUI** ⚠️ Important!
- Language: **Swift**
- Storage: None (leave unchecked)
- Include Tests: ✅ Checked

**Location:**
- Save in: Navigate to this `ios/` directory
- Click "Create"

### 2. Add Source Files to Project

1. In Xcode, you'll see it created default files (`SportsIQApp.swift`, `ContentView.swift`)
2. **Delete these files** (right-click → Delete → Move to Trash)
3. In the Project Navigator (left sidebar), right-click on the blue `SportsIQ` folder
4. Select "Add Files to SportsIQ..."
5. Navigate to and select the `SportsIQ/` folder that contains:
   - App/
   - Core/
   - Features/
   - Shared/
   - Resources/
6. **Important**: Make sure these options are selected:
   - ✅ "Copy items if needed" (unchecked - files are already in place)
   - ✅ "Create groups" (selected, NOT "Create folder references")
   - ✅ Add to targets: SportsIQ
7. Click "Add"

### 3. Configure Build Settings

The project should work out of the box, but verify these settings:

**General Tab:**
- iOS Deployment Target: **17.0** or higher
- iPhone and iPad supported

**Build Settings:**
- Swift Language Version: **Swift 5.9** or higher

### 4. Build and Run

1. Select a simulator from the device menu (iPhone 15 Pro recommended)
2. Press `Cmd + R` to build and run
3. The app should launch showing the Home screen!

## What You'll See

The app includes:

- **Home Tab**: Welcome screen with user stats (XP, Rating, Streak)
- **Learn Tab**: Browse sports → modules → lessons → interactive Q&A
- **Review Tab**: Placeholder for spaced repetition (coming soon)
- **Profile Tab**: User profile with detailed stats

## Testing the App

### Try the Learn Flow:

1. Tap "Learn" tab
2. Tap "Football" card
3. Tap "Football Basics" module
4. Tap "The Field & Players" lesson
5. Answer the questions
6. See immediate feedback with explanations

All data is currently mocked, so you can interact with everything without a backend!

## Previewing Individual Views

You can preview any view in isolation:

1. Open any View file (e.g., `SportCard.swift`)
2. Click the "Resume" button in the canvas (right panel)
3. Or press `Opt + Cmd + Return`

Every major view has `#Preview` blocks at the bottom.

## Project Structure

```
SportsIQ/
├── App/
│   ├── SportsIQApp.swift          # App entry point
│   └── AppCoordinator.swift        # Navigation coordinator
├── Core/
│   ├── Domain/
│   │   ├── Entities/              # Sport, Lesson, User, etc.
│   │   └── Repositories/          # Protocol definitions
│   └── Data/
│       └── Repositories/          # Mock implementations
├── Features/
│   ├── Home/                      # Home screen
│   ├── Learn/                     # Main learning flow
│   ├── Profile/                   # User profile
│   └── Review/                    # Spaced repetition (placeholder)
└── Shared/
    └── UI/
        ├── Components/            # Reusable UI components
        └── Styles/                # Design system (colors, fonts)
```

## Next Steps

### For Development:

1. **Explore the code**: Check out the Clean Architecture pattern
2. **Customize mock data**: Edit files in `Core/Domain/Entities/`
3. **Add new features**: Follow the patterns in existing features
4. **Run tests**: `Cmd + U` (once tests are added)

### For Backend Integration:

1. Replace mock repositories with real implementations
2. Implement `APIClient` in `Core/Data/Network/`
3. Add DTOs for API responses
4. Update `AppCoordinator` to use real repositories

## Troubleshooting

### "No such module 'SwiftUI'"
- Make sure you selected **SwiftUI** (not UIKit) when creating the project

### "Cannot find type 'Sport' in scope"
- Make sure you added the source files to the target
- Check Build Phases → Compile Sources includes all .swift files

### Preview not working
- Try cleaning the build folder: `Shift + Cmd + K`
- Restart Xcode
- Make sure you're on macOS Sonoma+ with Xcode 15+

### Build errors
- Verify iOS Deployment Target is 17.0+
- Check Swift version is 5.9+
- Clean build folder and rebuild

## Resources

- **CLAUDE.md**: Comprehensive development guide with coding standards
- **README.md**: Project overview and architecture details
- **PROJECT_SCOPE.md**: Full product specification
- **DATABASE_SCHEMA.md**: Database design

## Questions?

All code follows the patterns and conventions documented in [CLAUDE.md](../CLAUDE.md). Check there for:
- Architecture decisions
- Coding standards
- Design patterns
- Common patterns and best practices

Happy coding! 🏈
