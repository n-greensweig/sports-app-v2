# Supabase Connection Testing Guide

**Last Updated**: 2025-11-15
**Task**: Database Setup Task 3
**Estimated Time**: 10 minutes

---

## Prerequisites

Before testing the connection:

- ✅ Supabase Swift SDK added to project
- ✅ Network files created and added to Xcode
- ✅ Config.swift and Secrets.swift configured with credentials
- ✅ Project builds successfully (Cmd+B)

---

## Method 1: Test via SwiftUI View (Recommended)

This method creates a simple test view to verify the connection.

### Step 1: Create Test View

Create a new file: `/ios/SportsIQ/SportsIQ/TestConnectionView.swift`

```swift
//
//  TestConnectionView.swift
//  SportsIQ
//
//  Temporary view for testing Supabase connection
//  DELETE THIS FILE after verification
//

import SwiftUI

struct TestConnectionView: View {
    @Environment(SupabaseService.self) private var supabase
    @State private var connectionStatus = "Not tested"
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Supabase Connection Test")
                .font(.title)
                .fontWeight(.bold)

            Text("Status: \(connectionStatus)")
                .font(.headline)
                .foregroundStyle(statusColor)

            if let error = errorMessage {
                Text("Error: \(error)")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }

            Button(action: testConnection) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Test Connection")
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)

            Spacer()
        }
        .padding()
    }

    private var statusColor: Color {
        switch connectionStatus {
        case "Connected ✅":
            return .green
        case "Failed ❌":
            return .red
        default:
            return .gray
        }
    }

    private func testConnection() {
        isLoading = true
        errorMessage = nil
        connectionStatus = "Testing..."

        Task {
            do {
                let result = try await supabase.testConnection()
                await MainActor.run {
                    connectionStatus = "Connected ✅"
                    print("✅ Connection successful! Result: \(result)")
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    connectionStatus = "Failed ❌"
                    errorMessage = error.localizedDescription
                    print("❌ Connection failed: \(error)")
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    TestConnectionView()
        .environment(SupabaseService.shared)
}
```

### Step 2: Temporarily Update SportsIQApp.swift

Replace the `appCoordinator.start()` line with the test view:

```swift
var body: some Scene {
    WindowGroup {
        // TEMPORARY: Replace with TestConnectionView
        TestConnectionView()
            .environment(supabaseService)
    }
}
```

### Step 3: Build and Run

1. Build the project: **Cmd+B**
2. Run the app: **Cmd+R**
3. Tap the "Test Connection" button
4. Verify you see "Connected ✅"

### Step 4: Restore Original Code

After successful test:
1. Restore `SportsIQApp.swift` to use `appCoordinator.start()`
2. Delete `TestConnectionView.swift`

---

## Method 2: Test via Playground (Alternative)

If you prefer to test without modifying the main app:

### Step 1: Create Playground

1. In Xcode: **File → New → Playground**
2. Name: `SupabaseTest`
3. Platform: **iOS**

### Step 2: Add Test Code

```swift
import UIKit
import Supabase
import PlaygroundSupport

// Your credentials
let supabaseURL = "https://gzghfnqpzjmcsenrnjme.supabase.co"
let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd6Z2hmbnFwemptY3NlbnJuam1lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMxOTg1NTUsImV4cCI6MjA3ODc3NDU1NX0.LDaomGRd1Vxga8WSulh7qTRD6DC-GcWNQW-J-g_QAxA"

// Create client
let client = SupabaseClient(
    supabaseURL: URL(string: supabaseURL)!,
    supabaseKey: supabaseKey
)

// Test connection
Task {
    do {
        let response: [Sport] = try await client
            .from("sports")
            .select()
            .execute()
            .value

        print("✅ Connected successfully!")
        print("Found \(response.count) sports")
        response.forEach { sport in
            print("  - \(sport.name)")
        }
    } catch {
        print("❌ Connection failed: \(error)")
    }
}

// Keep playground running
PlaygroundPage.current.needsIndefiniteExecution = true

// Define Sport model
struct Sport: Codable {
    let id: String
    let name: String
}
```

### Step 3: Run Playground

1. Click the **Play** button at the bottom
2. Check the console output
3. Verify you see "Connected successfully!" with 6 sports

---

## Method 3: Test via Unit Test (Best for CI/CD)

### Step 1: Create Test File

Create: `/ios/SportsIQTests/Network/SupabaseServiceTests.swift`

```swift
//
//  SupabaseServiceTests.swift
//  SportsIQTests
//

import XCTest
@testable import SportsIQ

final class SupabaseServiceTests: XCTestCase {
    var sut: SupabaseService!

    override func setUp() {
        super.setUp()
        sut = SupabaseService.shared
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testSupabaseClientInitialization() {
        XCTAssertNotNil(sut.client)
    }

    func testConnectionToSupabase() async throws {
        // This test requires network connection
        let result = try await sut.testConnection()
        XCTAssertFalse(result.isEmpty, "Should receive data from Supabase")
    }

    func testFetchSports() async throws {
        // Test fetching sports from database
        let response = try await sut.client
            .from("sports")
            .select()
            .execute()

        let sports = response.value as [[String: AnyJSON]]
        XCTAssertGreaterThanOrEqual(sports.count, 6, "Should have at least 6 sports")
    }
}
```

### Step 2: Run Tests

1. Select test file in Xcode
2. **Cmd+U** to run all tests
3. Verify all tests pass ✅

---

## Method 4: Manual Query Test

You can also test directly in any Swift file:

```swift
import SwiftUI

struct SomeView: View {
    @Environment(SupabaseService.self) private var supabase

    var body: some View {
        Button("Test") {
            Task {
                do {
                    let sports = try await supabase.client
                        .from("sports")
                        .select()
                        .execute()
                        .value

                    print("✅ Fetched sports: \(sports)")
                } catch {
                    print("❌ Error: \(error)")
                }
            }
        }
    }
}
```

---

## Expected Results

### Success Indicators

✅ **Console Output** (when app launches):
```
🔧 Configuration loaded:
   Supabase URL: https://gzghfnqpzjmcsenrnjme.supabase.co
   Anon Key: eyJhbGciOiJIUzI1NiIsI...
✅ SupabaseService initialized
   URL: https://gzghfnqpzjmcsenrnjme.supabase.co
```

✅ **Connection Test Output**:
```
✅ Supabase connection test successful
```

✅ **Sports Query Result**:
- Should return 6 sports: Football, Basketball, Baseball, Hockey, Soccer, Golf
- Each sport has: id, name, icon, color_hex, is_active, display_order

### Sample Response

```json
[
  {
    "id": "uuid-string",
    "name": "Football",
    "icon": "football",
    "color_hex": "#2E7D32",
    "is_active": true,
    "display_order": 1
  },
  ...
]
```

---

## Troubleshooting

### Error: "Invalid Supabase URL in configuration"

**Cause**: Config.supabaseURL is not set or invalid

**Solution**:
1. Check `Secrets.swift` exists and has correct URL
2. Verify URL format: `https://xxxxx.supabase.co`
3. Rebuild project: **Cmd+Shift+K**, then **Cmd+B**

### Error: "No such module 'Supabase'"

**Cause**: Supabase SDK not properly installed

**Solution**:
1. Follow steps in `SUPABASE_SDK_SETUP.md`
2. Verify package appears in Package Dependencies
3. Clean and rebuild

### Error: "Connection failed: unauthorized"

**Cause**: Incorrect Supabase anon key

**Solution**:
1. Go to Supabase Dashboard → Settings → API
2. Copy the **anon/public** key (not service_role)
3. Update in `Secrets.swift`
4. Rebuild

### Error: "Connection failed: Network error"

**Cause**: No internet connection or Supabase is down

**Solution**:
1. Check internet connection
2. Visit https://status.supabase.com to check service status
3. Try again in a few minutes

### Error: "Row Level Security policy violation"

**Cause**: RLS is blocking anonymous access

**Solution**:
1. Go to Supabase Dashboard → Authentication → Policies
2. For testing, you can temporarily disable RLS on `sports` table
3. Better: Add a policy to allow SELECT for anon role:
   ```sql
   CREATE POLICY "Allow public read access to sports"
   ON sports FOR SELECT
   TO anon
   USING (true);
   ```

---

## Verification Checklist

Before marking Task 3 complete:

- [ ] Supabase SDK successfully added to project
- [ ] Project builds without errors (Cmd+B)
- [ ] SupabaseService initializes without crashing
- [ ] Configuration prints correctly in debug console
- [ ] Test connection succeeds (one of the 4 methods)
- [ ] Can successfully query `sports` table
- [ ] Receives 6 sports in response
- [ ] No authentication or network errors

---

## Next Steps

After successful connection test:

1. ✅ Mark Task 3 complete in `DATABASE_SETUP_TASKS.md`
2. ✅ Remove any test views or playground files
3. ✅ Proceed to Task 4: DTOs and Data Transfer Objects
4. ✅ Start building real repository implementations

---

## Quick Reference Commands

```bash
# Build project
Cmd+B

# Run app
Cmd+R

# Run tests
Cmd+U

# Clean build folder
Cmd+Shift+K

# Open Supabase dashboard
open https://supabase.com/dashboard/project/gzghfnqpzjmcsenrnjme
```

---

## Resources

- [Supabase Swift SDK Docs](https://github.com/supabase/supabase-swift)
- [Supabase Dashboard](https://supabase.com/dashboard/project/gzghfnqpzjmcsenrnjme)
- [Database Schema](../docs/DATABASE_SCHEMA.md)
- [Task Tracking](../docs/DATABASE_SETUP_TASKS.md)

---

**Congratulations on setting up the Supabase client! 🎉**
