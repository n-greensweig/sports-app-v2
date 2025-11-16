# Supabase Swift SDK Setup Guide

**Last Updated**: 2025-11-15
**Task**: Database Setup Task 3
**Estimated Time**: 10 minutes

---

## Prerequisites

- ✅ Xcode installed (Xcode 15.0 or later recommended)
- ✅ SportsIQ iOS project created
- ✅ Supabase project credentials configured (Task 2 complete)

---

## Step 1: Add Supabase Swift SDK via Swift Package Manager

### 1.1 Open Xcode Project

```bash
cd /Users/noahgreensweig/Desktop/SportsIQ/ios/SportsIQ
open SportsIQ.xcodeproj
```

### 1.2 Add Package Dependency

1. In Xcode, go to **File → Add Packages...**
2. In the search bar (top right), paste the Supabase Swift repository URL:
   ```
   https://github.com/supabase/supabase-swift
   ```
3. Click **Add Package**
4. Xcode will fetch the package and show dependency options

### 1.3 Select Package Products

When prompted to choose package products, select:
- ✅ **Supabase** (main library)
- ✅ **Auth** (authentication)
- ✅ **PostgrestKit** (database queries)
- ✅ **RealtimeKit** (live subscriptions)
- ✅ **StorageKit** (file storage - optional for now)

### 1.4 Add to Target

- Ensure all selected products are added to the **SportsIQ** target
- Click **Add Package**

### 1.5 Verify Installation

After adding the package:
1. Check that **Supabase** appears under **Package Dependencies** in the Project Navigator
2. Build the project to ensure no errors: **Cmd+B**

---

## Step 2: Verify Package Version

The recommended version is:
- **Latest stable release** (2.x or higher)
- Use **Up to Next Major Version** dependency rule

To check the current version:
1. Select the project in Project Navigator
2. Click on the project name (top level)
3. Select **Package Dependencies** tab
4. Verify **supabase-swift** is listed

---

## Step 3: Add Network Files to Xcode Project

After creating the network files via scripts, you need to add them to Xcode:

### 3.1 Add Network Directory

1. In Xcode, navigate to **SportsIQ → Core → Data**
2. Right-click on **Data** folder
3. Select **Add Files to "SportsIQ"...**
4. Navigate to `/Users/noahgreensweig/Desktop/SportsIQ/ios/SportsIQ/SportsIQ/Core/Data/Network`
5. Select the **Network** folder
6. Ensure these options are checked:
   - ✅ **Copy items if needed** (unchecked - files are already in place)
   - ✅ **Create groups** (selected)
   - ✅ **Add to targets: SportsIQ** (checked)
7. Click **Add**

### 3.2 Verify Files Are Added

The following files should now appear in Xcode:
- `Core/Data/Network/SupabaseClient.swift`
- `Core/Data/Network/NetworkError.swift`
- `Core/Data/Network/ResponseParser.swift`

---

## Step 4: Import Supabase in Your Code

After adding the SDK, you can import it in Swift files:

```swift
import Supabase
import Auth
import PostgrestKit
import RealtimeKit
```

---

## Step 5: Build and Test

### 5.1 Clean Build Folder
```
Cmd+Shift+K
```

### 5.2 Build Project
```
Cmd+B
```

### 5.3 Expected Result
- ✅ Build succeeds with no errors
- ✅ Supabase imports work correctly
- ✅ No "Module not found" errors

---

## Troubleshooting

### Issue: "No such module 'Supabase'"

**Solution**:
1. Clean build folder: **Cmd+Shift+K**
2. Delete derived data:
   - Xcode → **Preferences → Locations**
   - Click arrow next to **Derived Data** path
   - Delete the **SportsIQ** folder
3. Restart Xcode
4. Rebuild: **Cmd+B**

### Issue: Package Resolution Fails

**Solution**:
1. Check internet connection
2. Go to **File → Packages → Reset Package Caches**
3. Go to **File → Packages → Update to Latest Package Versions**
4. Restart Xcode

### Issue: "Version Conflict" or "Dependency Graph Error"

**Solution**:
1. Remove the Supabase package
2. Clean derived data (see above)
3. Re-add the package
4. Select "Up to Next Major Version" with minimum version 2.0.0

### Issue: Build Takes Very Long

**Solution**:
- First build after adding Supabase takes 2-5 minutes
- Subsequent builds are faster due to caching
- Be patient on first build

---

## Next Steps

After successfully adding the Supabase SDK:

1. ✅ Verify all network files are created
2. ✅ Update `SportsIQApp.swift` with dependency injection
3. ✅ Test Supabase connection
4. ✅ Mark Task 3 complete in `DATABASE_SETUP_TASKS.md`

---

## Resources

- [Supabase Swift SDK Documentation](https://github.com/supabase/supabase-swift)
- [Supabase Client Reference](https://supabase.com/docs/reference/swift)
- [Swift Package Manager Guide](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app)

---

## Verification Checklist

Before proceeding to the next task:

- [ ] Supabase Swift SDK added to project
- [ ] Package appears in Package Dependencies
- [ ] Project builds successfully (Cmd+B)
- [ ] Network directory created
- [ ] All network files added to Xcode project
- [ ] Files appear in Project Navigator
- [ ] No build errors or warnings related to Supabase

Once all items are checked, you're ready to proceed with testing the connection!
