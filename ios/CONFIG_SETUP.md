# iOS Configuration Setup Guide

This guide explains how to configure the SportsIQ iOS app to use the Supabase credentials.

## Files Created

1. **Root `.env`** - Contains actual credentials (gitignored)
2. **Root `.env.example`** - Template for other developers
3. **`ios/SportsIQ/Config.xcconfig`** - Xcode configuration file (gitignored)
4. **`ios/SportsIQ/SportsIQ/Shared/Utils/Config.swift`** - Swift helper to access config

## Setup Steps

### 1. Verify Files Exist

Check that these files exist:
- `/SportsIQ/.env` ✓
- `/SportsIQ/.env.example` ✓
- `/SportsIQ/ios/SportsIQ/Config.xcconfig` ✓
- `/SportsIQ/ios/SportsIQ/SportsIQ/Shared/Utils/Config.swift` ✓

### 2. Configure Xcode Project

**IMPORTANT**: The following steps must be done in Xcode:

#### Option A: Add xcconfig to Project Configuration

1. Open `SportsIQ.xcodeproj` in Xcode
2. Select the project in the navigator (top-level "SportsIQ")
3. Select the "SportsIQ" target
4. Go to the "Build Settings" tab
5. Search for "Info.plist"
6. Add custom keys to Info.plist (or create one if needed):
   - Key: `SUPABASE_URL`, Value: `$(SUPABASE_URL)`
   - Key: `SUPABASE_ANON_KEY`, Value: `$(SUPABASE_ANON_KEY)`

#### Option B: Use Configuration File Setting

1. Open `SportsIQ.xcodeproj` in Xcode
2. Select the project in the navigator
3. Go to the "Info" tab
4. Under "Configurations", expand "Debug" and "Release"
5. For each configuration, select "Config" from the dropdown next to "SportsIQ" target
6. If "Config" doesn't appear, you need to add it:
   - Click "+" to add a configuration file
   - Navigate to `ios/SportsIQ/Config.xcconfig`
   - Select it for both Debug and Release

### 3. Add Config.swift to Xcode Project

If `Config.swift` doesn't appear in your Xcode project navigator:

1. Right-click on `Shared/Utils` folder in Xcode
2. Select "Add Files to SportsIQ..."
3. Navigate to `ios/SportsIQ/SportsIQ/Shared/Utils/Config.swift`
4. Check "Copy items if needed"
5. Make sure "SportsIQ" target is selected
6. Click "Add"

### 4. Verify Configuration Works

In `SportsIQApp.swift` or any view, add this to test:

```swift
init() {
    // Test configuration
    Config.printConfiguration()

    // ... rest of init
}
```

Build and run the app. You should see in the console:
```
🔧 Configuration loaded:
   Supabase URL: https://gzghfnqpzjmcsenrnjme.supabase.co
   Anon Key: eyJhbGciOiJIUzI1NiIsInR...
```

### 5. Using Config in Code

To access Supabase credentials anywhere in your app:

```swift
import Foundation

// Get Supabase URL
let url = Config.supabaseURL

// Get Supabase anon key
let key = Config.supabaseAnonKey

// Example: Initialize Supabase client
let client = SupabaseClient(
    supabaseURL: URL(string: Config.supabaseURL)!,
    supabaseKey: Config.supabaseAnonKey
)
```

## Alternative Setup (If xcconfig doesn't work)

If you encounter issues with xcconfig, you can use a Swift file approach:

1. Create `ios/SportsIQ/SportsIQ/Shared/Utils/Secrets.swift`
2. Add to `.gitignore`: `**/Secrets.swift`
3. Add this content:

```swift
enum Secrets {
    static let supabaseURL = "https://gzghfnqpzjmcsenrnjme.supabase.co"
    static let supabaseAnonKey = "eyJhbGci..."
}
```

4. Update `Config.swift` to read from `Secrets` instead of Bundle

## Troubleshooting

### Config values are "$(SUPABASE_URL)"

This means the xcconfig file isn't being loaded:
- Verify Config.xcconfig is set in Project → Info → Configurations
- Clean build folder (Cmd+Shift+K)
- Rebuild project (Cmd+B)

### "SUPABASE_URL not found in Info.plist"

Two solutions:
1. Create an Info.plist file and add the keys
2. OR modify Config.swift to read from a different source (like Secrets.swift above)

### xcconfig file not found in Xcode

- Make sure to add Config.xcconfig to the project
- Check that the file path is correct
- Try restarting Xcode

## Security Notes

- **NEVER** commit `Config.xcconfig` or `.env` to git
- `.gitignore` is already configured to exclude these files
- Share credentials securely with team members (use password manager, not email)
- For production, use a separate Supabase project with different credentials

## Next Steps

After configuration is complete:
- Proceed to **Task 3**: iOS Supabase Client Setup
- The Config helper will be used when initializing the Supabase client

---

**Last Updated**: 2025-11-15
