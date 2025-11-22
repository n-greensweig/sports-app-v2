# Claude Context - SportsIQ Project

**Last Updated**: 2025-11-19
**Project Phase**: Active Development (Phase 1 - App Store Preparation)
**Primary Language**: Swift (iOS first)
**Future Languages**: Kotlin (Android), potentially TypeScript (Web)

---

## Quick Project Summary

**SportsIQ** is a Duolingo-style sports education app that helps fans of all levels learn about sports through:
- Structured bite-sized lessons (≤5 minutes)
- Real-time prompts during live games
- Spaced repetition for retention
- Gamification (XP, Overall ratings 0-99, medals, badges, leaderboards)

**V1 Focus**: Football only, iOS/Swift, with architecture designed for easy multi-platform expansion.

---

## Essential Reading

Before starting any development task, read these documents:

1. **[README.md](./README.md)**: Project overview and quick reference
2. **[docs/PROJECT_SCOPE.md](./docs/PROJECT_SCOPE.md)**: Complete product vision, features, UX/UI design, roadmap
3. **[docs/DATABASE_SCHEMA.md](./docs/DATABASE_SCHEMA.md)**: Full database schema with all tables and relationships

**Key Sections to Know**:
- User Personas (4 levels): docs/PROJECT_SCOPE.md#user-personas
- Technical Architecture: docs/PROJECT_SCOPE.md#technical-architecture
- MVP Roadmap: docs/PROJECT_SCOPE.md#mvp-roadmap
- Database Schema Overview: docs/DATABASE_SCHEMA.md

---

## Architecture Principles

### 1. Multi-Platform from Day 1 (Even Though We Start iOS-Only)

**Critical**: Although we're building in Swift first, the architecture MUST support easy addition of Kotlin (Android) and other platforms later.

**How to Achieve This**:
- Use **Clean Architecture** with clear layer separation
- Keep business logic in the **Domain Layer** (platform-agnostic concepts)
- Use **protocols/interfaces** for all cross-layer dependencies
- Keep platform code (SwiftUI, UIKit, Core Haptics) isolated in **Presentation Layer**
- Design data models that can be serialized/deserialized identically across platforms

**Future Migration Path** (Phase 2):
```
Current: Swift-only
         ├── Presentation (SwiftUI) ← Platform-specific
         ├── Domain (Swift) ← Will become KMM shared module
         └── Data (Swift) ← Will become KMM shared module

Future: Kotlin Multiplatform
         ├── iOS: Presentation (SwiftUI)
         ├── Android: Presentation (Jetpack Compose)
         ├── Shared: Domain (Kotlin Multiplatform)
         └── Shared: Data (Kotlin Multiplatform)
```

### 2. Clean Architecture Layers

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  • SwiftUI Views                        │
│  • ViewModels (@Observable)             │
│  • Coordinators (Navigation)            │
│  • Platform-specific code               │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│         Domain Layer                    │
│  • Use Cases (business logic)           │
│  • Entities (core models)               │
│  • Repository Protocols                 │
│  • NO platform dependencies             │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│         Data Layer                      │
│  • Repository Implementations           │
│  • Network Service (URLSession)         │
│  • Database Service (SwiftData)         │
│  • DTOs (Data Transfer Objects)         │
└─────────────────────────────────────────┘
```

### 3. Key Design Patterns

**MVVM + Coordinators**:
- Views are dumb, ViewModels contain presentation logic
- Coordinators handle navigation (keeps navigation out of ViewModels)
- Use dependency injection for testability

**Repository Pattern**:
- Abstract data sources behind protocols
- Repositories can combine network + local cache
- Easy to mock for testing

**Use Case Pattern**:
- One use case = one business operation
- Examples: `CompleteLesson`, `SubmitAnswer`, `FetchDueReviews`
- Keep use cases small and focused

---

## File Structure Convention

When creating the iOS project, use this structure:

```
ios/
└── SportsIQ/
    ├── App/
    │   ├── SportsIQApp.swift
    │   └── AppCoordinator.swift
    ├── Core/
    │   ├── Domain/
    │   │   ├── Entities/
    │   │   │   ├── User.swift
    │   │   │   ├── Sport.swift
    │   │   │   ├── Lesson.swift
    │   │   │   ├── Item.swift
    │   │   │   └── Submission.swift
    │   │   ├── UseCases/
    │   │   │   ├── Auth/
    │   │   │   ├── Learning/
    │   │   │   ├── Gamification/
    │   │   │   └── LiveMode/
    │   │   └── Repositories/ (protocols only)
    │   │       ├── UserRepository.swift
    │   │       ├── LearningRepository.swift
    │   │       └── GameRepository.swift
    │   └── Data/
    │       ├── Network/
    │       │   ├── APIClient.swift
    │       │   ├── Endpoints/
    │       │   └── DTOs/
    │       ├── Local/
    │       │   ├── SwiftDataModels/
    │       │   └── CacheManager.swift
    │       └── Repositories/ (implementations)
    │           ├── UserRepositoryImpl.swift
    │           ├── LearningRepositoryImpl.swift
    │           └── GameRepositoryImpl.swift
    ├── Features/
    │   ├── Auth/
    │   │   ├── Views/
    │   │   ├── ViewModels/
    │   │   └── AuthCoordinator.swift
    │   ├── Home/
    │   ├── Learn/
    │   │   ├── Views/
    │   │   │   ├── SportSubLandingView.swift
    │   │   │   ├── LessonView.swift
    │   │   │   └── LessonCompleteView.swift
    │   │   ├── ViewModels/
    │   │   │   └── LessonViewModel.swift
    │   │   └── LearnCoordinator.swift
    │   ├── LiveMode/
    │   ├── Review/
    │   └── Profile/
    ├── Shared/
    │   ├── UI/
    │   │   ├── Components/
    │   │   │   ├── Buttons/
    │   │   │   ├── Cards/
    │   │   │   └── ProgressBar.swift
    │   │   ├── Styles/
    │   │   │   ├── Colors.swift
    │   │   │   ├── Typography.swift
    │   │   │   └── SportTheme.swift
    │   │   └── Modifiers/
    │   ├── Utils/
    │   │   ├── Extensions/
    │   │   └── Helpers/
    │   └── Services/
    │       ├── AudioManager.swift
    │       ├── HapticManager.swift
    │       └── NotificationManager.swift
    └── Resources/
        ├── Assets.xcassets/
        ├── Sounds/
        └── Localizable.strings
```

---

## Coding Standards

### Swift Conventions

**Naming**:
- Types: `PascalCase` (e.g., `LessonViewModel`, `UserRepository`)
- Variables/Functions: `camelCase` (e.g., `fetchLesson()`, `isCompleted`)
- Constants: `camelCase` (e.g., `maxLessonDuration`, not `MAX_LESSON_DURATION`)
- Protocols: Descriptive nouns (e.g., `UserRepository`) or adjectives ending in `-able` (e.g., `Cacheable`)

**Code Organization**:
```swift
// MARK: - Types first
struct LessonView: View {
    // MARK: - Properties
    @State private var currentIndex: Int = 0
    let lesson: Lesson

    // MARK: - Body
    var body: some View {
        // ...
    }

    // MARK: - Private Methods
    private func submitAnswer() {
        // ...
    }
}
```

**Dependency Injection**:
```swift
// ✅ Good: Inject dependencies via initializer
class LessonViewModel: ObservableObject {
    private let repository: LearningRepository

    init(repository: LearningRepository) {
        self.repository = repository
    }
}

// ❌ Bad: Hardcoded dependencies
class LessonViewModel: ObservableObject {
    private let repository = LearningRepositoryImpl()
}
```

**Async/Await** (iOS 17+):
```swift
// ✅ Use async/await for network calls
func fetchLesson(id: UUID) async throws -> Lesson {
    let data = try await apiClient.get(endpoint: .lesson(id))
    return try JSONDecoder().decode(Lesson.self, from: data)
}

// ❌ Don't use completion handlers
func fetchLesson(id: UUID, completion: @escaping (Result<Lesson, Error>) -> Void) {
    // Old style
}
```

### SwiftUI Best Practices

**State Management**:
- Use `@State` for view-local state
- Use `@Observable` (iOS 17+) for ViewModels instead of `@ObservableObject`
- Use `@Environment` for dependency injection
- Keep views simple, move logic to ViewModels

**Performance**:
```swift
// ✅ Extract subviews for complex UI
struct LessonView: View {
    var body: some View {
        VStack {
            LessonHeaderView()
            LessonProgressView()
            LessonQuestionView()
        }
    }
}

// ❌ Don't put everything in one view
struct LessonView: View {
    var body: some View {
        VStack {
            // 200 lines of code...
        }
    }
}
```

**Previews**:
```swift
// Always provide previews with mock data
#Preview("Lesson - MCQ") {
    LessonView(
        viewModel: LessonViewModel(
            lesson: .mockMultipleChoice,
            repository: MockLearningRepository()
        )
    )
}

#Preview("Lesson - Completed") {
    LessonView(
        viewModel: LessonViewModel(
            lesson: .mockCompleted,
            repository: MockLearningRepository()
        )
    )
}
```

---

## Data Models

### Entity Examples

**Domain Entities** (platform-agnostic):
```swift
// Core/Domain/Entities/Lesson.swift
struct Lesson: Identifiable {
    let id: UUID
    let moduleId: UUID
    let title: String
    let description: String
    let orderIndex: Int
    let estimatedMinutes: Int
    let xpAward: Int
    let isLocked: Bool
    let items: [Item]
}

// Core/Domain/Entities/Item.swift
enum ItemType: String, Codable {
    case mcq
    case multiSelect
    case slider
    case freeText
    case clipLabel
    case binary
}

struct Item: Identifiable {
    let id: UUID
    let type: ItemType
    let prompt: String
    let options: [String]?
    let correctAnswer: ItemAnswer
    let explanation: String?
    let mediaURL: URL?
}
```

**DTOs** (Data Transfer Objects for API):
```swift
// Core/Data/Network/DTOs/LessonDTO.swift
struct LessonDTO: Codable {
    let id: String  // UUID as string from API
    let module_id: String
    let title: String
    let description: String
    let order_index: Int
    let est_minutes: Int
    let xp_award: Int
    let is_locked: Bool
    let items: [ItemDTO]

    // Convert to domain entity
    func toDomain() -> Lesson {
        Lesson(
            id: UUID(uuidString: id)!,
            moduleId: UUID(uuidString: module_id)!,
            title: title,
            description: description,
            orderIndex: order_index,
            estimatedMinutes: est_minutes,
            xpAward: xp_award,
            isLocked: is_locked,
            items: items.map { $0.toDomain() }
        )
    }
}
```

---

## Key Features Implementation Notes

### 1. Learn Mode (Lessons)

**State Machine for Lesson Flow**:
```swift
enum LessonState {
    case loading
    case ready
    case presenting(itemIndex: Int)
    case feedback(isCorrect: Bool)
    case transitioning
    case complete(score: Int)
    case error(Error)
}
```

**Audio Feedback**:
- Use `AVFoundation` to play sounds
- Preload sounds at app launch
- Football: `crowd_cheer.mp3`, `whistle.mp3`, `victory_horn.mp3`
- Keep sounds under 1 second for responsiveness

**Haptics**:
```swift
// Use Core Haptics framework
import CoreHaptics

class HapticManager {
    private var engine: CHHapticEngine?

    func playCorrectFeedback() {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        // Play event...
    }
}
```

### 2. Live Mode

**WebSocket Connection**:
```swift
// Use URLSessionWebSocketTask (iOS 13+)
class LiveGameService {
    private var webSocketTask: URLSessionWebSocketTask?

    func connect(to gameId: UUID) {
        let url = URL(string: "wss://api.sportsiq.com/live/\(gameId)")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
    }

    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                // Handle live prompt
                self?.receiveMessage() // Continue listening
            case .failure(let error):
                // Handle error
            }
        }
    }
}
```

**Live Prompt Timing**:
- Wait 3-5 seconds after play completion
- Check user's cooldown timer (stored locally)
- Display prompt in floating card (can be minimized)
- 20-30 second answer window

### 3. Spaced Repetition System (SRS)

**SM-2 Algorithm Implementation**:
```swift
struct SRSCard {
    let itemId: UUID
    var dueDate: Date
    var interval: TimeInterval // in seconds
    var easeFactor: Double // 1.3 to 2.5
    var repetitions: Int

    mutating func recordReview(grade: Int) {
        // grade: 0 (wrong) to 3 (easy)
        // Update easeFactor, interval, dueDate
        // See: https://en.wikipedia.org/wiki/SuperMemo#SM-2_algorithm
    }
}
```

**Due Review Queue**:
- Fetch all cards where `dueDate <= Date()`
- Sort by due date (oldest first)
- Limit to 20 items per session (prevent overwhelming)

### 4. Gamification

**XP Calculation**:
```swift
enum XPSource {
    case lessonItem(correct: Bool)      // 10 XP if correct
    case lessonPerfectScore             // +20 bonus
    case liveAnswer(correct: Bool)      // 15 XP if correct
    case dailyStreak                    // 25 XP
    case reviewItem(correct: Bool)      // 5 XP if correct
}

func awardXP(source: XPSource, userId: UUID, sportId: UUID) {
    let amount = source.xpAmount
    // Save to user_xp_events table
    // Update user_progress.total_xp
    // Recalculate overall rating
    // Check for level-up
    // Check for badge unlocks
}
```

**Overall Rating (0-99)**:
```swift
func calculateOverallRating(
    lessonsCompleted: Int,
    totalLessons: Int,
    accuracy: Double,
    conceptsMastered: Int,
    totalConcepts: Int,
    liveAnswers: Int,
    advancedCorrect: Int
) -> Int {
    let lessonComponent = Double(lessonsCompleted) / Double(totalLessons) * 25.0
    let accuracyComponent = accuracy * 20.0
    let conceptsComponent = Double(conceptsMastered) / Double(totalConcepts) * 30.0
    let liveComponent = min(Double(liveAnswers), 100.0) / 100.0 * 10.0
    let advancedComponent = min(Double(advancedCorrect), 50.0) / 50.0 * 14.0

    let overall = lessonComponent + accuracyComponent + conceptsComponent + liveComponent + advancedComponent
    return min(Int(overall.rounded()), 99)
}
```

---

## Testing Strategy

### Unit Tests

**Test Use Cases**:
```swift
// Tests/SportsIQTests/UseCases/CompleteLesson
class CompleteLessonUseCaseTests: XCTestCase {
    var sut: CompleteLessonUseCase!
    var mockRepository: MockLearningRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockLearningRepository()
        sut = CompleteLessonUseCase(repository: mockRepository)
    }

    func testCompleteLessonAwardsXP() async throws {
        // Given
        let lesson = Lesson.mock
        mockRepository.lessonToReturn = lesson

        // When
        let result = try await sut.execute(lessonId: lesson.id, score: 10)

        // Then
        XCTAssertEqual(result.xpAwarded, 120)
    }
}
```

**Test ViewModels**:
```swift
class LessonViewModelTests: XCTestCase {
    func testSubmitCorrectAnswerShowsFeedback() {
        // Given
        let viewModel = LessonViewModel(
            lesson: .mock,
            repository: MockLearningRepository()
        )

        // When
        viewModel.submitAnswer(.option(0))

        // Then
        XCTAssertEqual(viewModel.state, .feedback(isCorrect: true))
    }
}
```

### UI Tests

**Test Critical Flows**:
```swift
class LessonFlowUITests: XCTestCase {
    func testCompletingLessonUnlocksNext() {
        let app = XCUIApplication()
        app.launch()

        // Navigate to lesson
        app.buttons["Football"].tap()
        app.buttons["Lesson 1"].tap()

        // Answer all questions correctly
        for _ in 0..<8 {
            app.buttons["Option A"].tap()
            app.buttons["Check Answer"].tap()
            app.buttons["Continue"].tap()
        }

        // Verify completion screen
        XCTAssertTrue(app.staticTexts["Lesson Complete!"].exists)

        // Go back and verify next lesson unlocked
        app.buttons["Back to Path"].tap()
        XCTAssertFalse(app.buttons["Lesson 2"].isEnabled == false)
    }
}
```

---

## Backend Integration

### API Endpoints (Expected)

When backend is implemented, expect these endpoints:

**Authentication** (via Supabase Auth):
- Supabase handles authentication directly (email/password, Apple Sign In, Google Sign In)
- Auth state managed via SupabaseClient session
- GET `/auth/me` - Get current user (via Supabase Auth)

**Learning**:
- GET `/sports` - List all sports
- GET `/sports/:sportId/modules` - Get modules for sport
- GET `/modules/:moduleId/lessons` - Get lessons for module
- GET `/lessons/:lessonId` - Get lesson with items
- POST `/submissions` - Submit answer
- GET `/users/:userId/progress/:sportId` - Get user progress

**Gamification**:
- GET `/users/:userId/xp/:sportId` - Get XP history
- GET `/leaderboards/:sportId?window=daily|weekly|alltime` - Get leaderboard
- GET `/users/:userId/badges` - Get user badges
- GET `/users/:userId/streaks/:sportId` - Get streak info

**Live Mode**:
- GET `/games?date=YYYY-MM-DD` - Get games for date
- WS `/live/:gameId` - WebSocket for live game updates
- POST `/live/submissions` - Submit live answer

**Spaced Repetition**:
- GET `/users/:userId/reviews/:sportId/due` - Get due reviews
- POST `/reviews` - Record review

### API Client Structure

```swift
// Core/Data/Network/APIClient.swift
protocol APIClient {
    func get<T: Decodable>(endpoint: Endpoint) async throws -> T
    func post<T: Decodable, U: Encodable>(endpoint: Endpoint, body: U) async throws -> T
    func delete(endpoint: Endpoint) async throws
}

// Core/Data/Network/Endpoints.swift
enum Endpoint {
    case sports
    case sportModules(sportId: UUID)
    case lesson(lessonId: UUID)
    case submitAnswer
    case userProgress(userId: UUID, sportId: UUID)
    // ...

    var path: String {
        switch self {
        case .sports: return "/sports"
        case .sportModules(let id): return "/sports/\(id)/modules"
        // ...
        }
    }
}
```

---

## Supabase Configuration & Setup

### Current Implementation

The app uses **Supabase** for backend services, including:
- Authentication (email/password, Apple Sign In, Google Sign In)
- PostgreSQL database
- Real-time subscriptions (for live features)
- Row Level Security (RLS) for data protection

### Architecture

```
SupabaseService (Singleton)
├── Supabase Client (supabase-swift SDK)
├── Auth Service (AuthService.swift)
│   ├── Email/Password auth
│   ├── Apple Sign In
│   └── Google Sign In
└── Repositories
    ├── SupabaseLearningRepository
    ├── SupabaseUserRepository
    └── SupabaseGameRepository
```

### Configuration Files

**Secrets.swift** (gitignored):
```swift
struct SupabaseConfig {
    static let url = "https://your-project.supabase.co"
    static let anonKey = "your-anon-public-key"
}
```

**Config.swift** (wrapper for safe access):
```swift
enum Config {
    static var supabaseURL: String {
        SupabaseConfig.url
    }

    static var supabaseAnonKey: String {
        SupabaseConfig.anonKey
    }
}
```

### Authentication Flow

**AuthService.swift** handles all authentication:

```swift
class AuthService: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?

    // Email/Password
    func signUp(email: String, password: String) async throws
    func signIn(email: String, password: String) async throws

    // Apple Sign In
    func signInWithApple(credential: ASAuthorizationAppleIDCredential) async throws

    // Google Sign In
    func signInWithGoogle() async throws

    // Session management
    func signOut() async throws
    func resetPassword(email: String) async throws
}
```

**User Profile Creation**:
After successful authentication, `AuthService` automatically:
1. Creates a user profile in `users` table
2. Creates `user_progress` records for all sports
3. Initializes starting stats (0 XP, rating, etc.)

### Database Access

**Direct Supabase Queries** (current approach):
```swift
// SupabaseLearningRepository.swift
func fetchSports() async throws -> [Sport] {
    let response: [SportDTO] = try await supabase
        .from("sports")
        .select()
        .execute()
        .value

    return response.map { $0.toDomain() }
}

func submitAnswer(submission: SubmissionCreate) async throws {
    try await supabase
        .from("submissions")
        .insert(submission)
        .execute()
}
```

**Row Level Security (RLS)**:
Supabase RLS policies ensure users can only access their own data:
- Users can only read/write their own `user_progress`
- Users can only read/write their own `submissions`
- Public tables: `sports`, `modules`, `lessons`, `items`

### Deep Linking Setup

**URL Schemes** (configured in Info.plist):
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.sportsiq.app</string>
        </array>
    </dict>
</array>
```

**Supabase Auth Callbacks**:
- Email verification: `com.sportsiq.app://auth/verify`
- Password reset: `com.sportsiq.app://auth/reset`

Configure these in Supabase Dashboard → Authentication → URL Configuration

### Environment Setup

1. **Create Supabase Project**:
   - Go to [supabase.com](https://supabase.com)
   - Create new project
   - Note Project URL and anon/public key

2. **Run Database Migration**:
   ```bash
   # In Supabase SQL Editor, run:
   # supabase/migrations/20240101000000_initial_schema.sql
   ```

3. **Configure Auth Providers**:
   - **Email/Password**: Enabled by default
   - **Apple Sign In**:
     - Add Apple OAuth provider in Supabase Dashboard
     - Configure Service ID, Team ID, Key ID
     - Upload .p8 key file
   - **Google Sign In**:
     - Add Google OAuth provider
     - Configure Client ID and Client Secret from Google Cloud Console

4. **Set Up RLS Policies**:
   - RLS policies are included in migration file
   - Verify in Supabase Dashboard → Authentication → Policies

5. **Configure Email Templates**:
   - Customize email templates in Supabase Dashboard
   - Update redirect URLs to use app URL scheme

### Testing Supabase Locally

```swift
// Use mock repositories for testing
let mockRepo = MockLearningRepository()
let viewModel = LessonViewModel(repository: mockRepo)

// Or test against Supabase staging project
// Update Secrets.swift to point to staging URL
```

### Common Supabase Tasks

**Check Auth Status**:
```swift
let session = try await supabase.auth.session
print("User ID: \(session.user.id)")
```

**Manual Database Query** (debugging):
```swift
let result = try await supabase
    .from("users")
    .select("*")
    .eq("id", userId)
    .single()
    .execute()
```

**Listen to Auth Changes**:
```swift
Task {
    for await state in await supabase.auth.authStateChanges {
        switch state {
        case .signedIn(let session):
            print("User signed in: \(session.user.id)")
        case .signedOut:
            print("User signed out")
        }
    }
}
```

---

## Common Tasks & Commands

### Creating a New Feature

```bash
# 1. Create feature folder structure
mkdir -p ios/SportsIQ/Features/NewFeature/{Views,ViewModels}

# 2. Create necessary files
touch ios/SportsIQ/Features/NewFeature/NewFeatureCoordinator.swift
touch ios/SportsIQ/Features/NewFeature/Views/NewFeatureView.swift
touch ios/SportsIQ/Features/NewFeature/ViewModels/NewFeatureViewModel.swift

# 3. Add tests
mkdir -p ios/SportsIQTests/Features/NewFeature
touch ios/SportsIQTests/Features/NewFeature/NewFeatureViewModelTests.swift
```

### Database Migrations

When backend is set up:
```bash
# Create new migration
npm run migrate:create add_new_table

# Run migrations
npm run migrate:up

# Rollback
npm run migrate:down
```

### Running the App

```bash
# iOS Simulator
xcodebuild -scheme SportsIQ -destination 'platform=iOS Simulator,name=iPhone 15 Pro' build

# Or use Xcode UI: Cmd+R
```

---

## Important Conventions

### Date/Time Handling

**Always use UTC** for storage, convert to user timezone for display:
```swift
// ✅ Good: Store as UTC
let createdAt = Date() // This is UTC

// ✅ Good: Display in user timezone
let formatter = DateFormatter()
formatter.timeZone = TimeZone.current
formatter.dateStyle = .medium
let displayString = formatter.string(from: createdAt)

// ❌ Bad: Store in local timezone
let createdAt = Date().addingTimeInterval(TimeZone.current.secondsFromGMT())
```

### UUID Handling

```swift
// ✅ Good: Use UUID type
struct Lesson {
    let id: UUID
}

// ✅ Good: Parse from string safely
if let id = UUID(uuidString: stringFromAPI) {
    // Use id
}

// ❌ Bad: Use strings for IDs
struct Lesson {
    let id: String
}
```

### Error Handling

```swift
// Define domain-specific errors
enum LearningError: LocalizedError {
    case lessonNotFound
    case lessonLocked
    case invalidAnswer
    case networkError(underlying: Error)

    var errorDescription: String? {
        switch self {
        case .lessonNotFound: return "Lesson not found"
        case .lessonLocked: return "Complete the previous lesson first"
        case .invalidAnswer: return "Invalid answer format"
        case .networkError(let error): return "Network error: \(error.localizedDescription)"
        }
    }
}

// Use async throws
func fetchLesson(id: UUID) async throws -> Lesson {
    guard let lesson = await repository.getLesson(id: id) else {
        throw LearningError.lessonNotFound
    }
    return lesson
}
```

---

## Design System Quick Reference

### Colors (Per Sport)

```swift
// Shared/UI/Styles/Colors.swift
extension Color {
    static let footballAccent = Color(hex: "#2E7D32")
    static let basketballAccent = Color(hex: "#F57C00")
    static let baseballAccent = Color(hex: "#1976D2")
    static let hockeyAccent = Color(hex: "#0288D1")
    static let soccerAccent = Color(hex: "#388E3C")
    static let golfAccent = Color(hex: "#689F38")
}

// Usage
struct LessonView: View {
    let sport: Sport

    var body: some View {
        VStack {
            // ...
        }
        .foregroundStyle(sport.accentColor)
    }
}
```

### Typography

```swift
extension Font {
    static let heading1 = Font.system(size: 32, weight: .bold, design: .default)
    static let heading2 = Font.system(size: 24, weight: .semibold, design: .default)
    static let heading3 = Font.system(size: 20, weight: .semibold, design: .default)
    static let body = Font.system(size: 16, weight: .regular, design: .default)
    static let caption = Font.system(size: 14, weight: .regular, design: .default)
    static let small = Font.system(size: 12, weight: .regular, design: .default)
}
```

### Spacing

```swift
extension CGFloat {
    static let spacingXS: CGFloat = 4
    static let spacingS: CGFloat = 8
    static let spacingM: CGFloat = 16
    static let spacingL: CGFloat = 24
    static let spacingXL: CGFloat = 32
    static let spacingXXL: CGFloat = 48
}
```

---

## Performance Considerations

### Image Loading

```swift
// Use AsyncImage with placeholder
AsyncImage(url: imageURL) { image in
    image
        .resizable()
        .aspectRatio(contentMode: .fill)
} placeholder: {
    ProgressView()
}
.frame(width: 100, height: 100)
.clipped()

// Cache images (use SDWebImageSwiftUI or similar)
```

### Large Lists

```swift
// Use LazyVStack/LazyHStack for long lists
LazyVStack {
    ForEach(lessons) { lesson in
        LessonCard(lesson: lesson)
    }
}

// Or use List for automatic optimization
List(lessons) { lesson in
    LessonCard(lesson: lesson)
}
```

### Memory Management

```swift
// Use [weak self] in closures
class LessonViewModel {
    func fetchLesson() {
        Task {
            do {
                let lesson = try await repository.fetchLesson(id: lessonId)
                // Update UI on main thread
                await MainActor.run { [weak self] in
                    self?.lesson = lesson
                }
            } catch {
                // Handle error
            }
        }
    }
}
```

---

## Security Considerations

### API Keys

```swift
// NEVER commit API keys to git
// Use separate Secrets.swift file (add to .gitignore)

// Secrets.swift (gitignored)
struct SupabaseConfig {
    static let url = "https://your-project.supabase.co"
    static let anonKey = "your-anon-key-here"
}

struct ExternalAPIConfig {
    static let sportRadarAPIKey = "your_api_key_here"
}

// For other APIs, use Info.plist method:
guard let apiKey = Bundle.main.infoDictionary?["SPORTRADAR_API_KEY"] as? String else {
    fatalError("API key not found")
}
```

### User Data

- Never log sensitive user data (email, tokens, etc.)
- Use Keychain for storing auth tokens
- Sanitize user input before sending to backend

```swift
import Security

class KeychainManager {
    static func save(key: String, data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary) // Delete old
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
}
```

---

## Troubleshooting

### Common Issues

**1. SwiftUI Preview Not Working**
```swift
// Make sure all dependencies are mockable
#Preview {
    LessonView(
        viewModel: LessonViewModel(
            lesson: .mock,
            repository: MockLearningRepository() // ← Mock dependency
        )
    )
}
```

**2. WebSocket Not Connecting**
- Check backend is running
- Verify URL is correct (ws:// or wss://)
- Check network permissions in Info.plist

**3. Audio Not Playing**
- Verify audio file is in bundle
- Check AVAudioSession is configured
- Ensure device is not in silent mode (use `.playback` category)

**4. Database Queries Slow**
- Check indexes are created (see DATABASE_SCHEMA.md)
- Use EXPLAIN ANALYZE in PostgreSQL
- Consider materialized views for complex queries

---

## Deployment

### TestFlight (Beta)

```bash
# 1. Archive app in Xcode
# Product → Archive

# 2. Upload to App Store Connect
# Organizer → Distribute App → App Store Connect

# 3. Add testers in App Store Connect
# TestFlight → Testers → Add Tester

# 4. Send test invite
```

### App Store Submission

**Requirements**:
- Privacy Policy URL
- Terms of Service URL
- App screenshots (all required sizes)
- App preview video (optional but recommended)
- App description and keywords
- Support URL

**Checklist**:
- [ ] All features working
- [ ] Crash-free rate >99%
- [ ] Performance tested (60fps UI)
- [ ] Accessibility tested (VoiceOver, Dynamic Type)
- [ ] Privacy manifest included
- [ ] App Store assets prepared
- [ ] Reviewed App Store guidelines

---

## When Working on This Project

### Ask These Questions

1. **Does this change support multi-platform expansion?**
   - Is business logic platform-agnostic?
   - Are dependencies injected via protocols?

2. **Is this testable?**
   - Can I write a unit test for this?
   - Are dependencies mockable?

3. **Does this follow Clean Architecture?**
   - Am I mixing presentation and business logic?
   - Is this in the right layer?

4. **Is this accessible?**
   - Does it work with VoiceOver?
   - Does it support Dynamic Type?
   - Is there sufficient color contrast?

5. **Is this performant?**
   - Will this cause UI lag?
   - Am I loading unnecessary data?
   - Should this be cached?

### Red Flags to Avoid

❌ **Don't** put business logic in Views or ViewModels
❌ **Don't** hardcode dependencies (use DI)
❌ **Don't** ignore errors (handle gracefully)
❌ **Don't** use force unwrapping (`!`) without strong justification
❌ **Don't** put platform-specific code in Domain layer
❌ **Don't** commit sensitive data (API keys, tokens)
❌ **Don't** skip accessibility considerations
❌ **Don't** write views over 200 lines (extract subviews)

### Green Flags to Embrace

✅ **Do** use dependency injection
✅ **Do** write tests for critical paths
✅ **Do** use protocols for abstraction
✅ **Do** handle errors gracefully
✅ **Do** consider performance implications
✅ **Do** follow Swift naming conventions
✅ **Do** use async/await for asynchronous code
✅ **Do** provide SwiftUI previews
✅ **Do** keep platform code isolated
✅ **Do** document complex logic

---

## Resources

**Apple Documentation**:
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Swift Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

**Third-Party Libraries** (Currently Used):
- **Supabase Swift** (Auth & Backend): [github.com/supabase/supabase-swift](https://github.com/supabase/supabase-swift)
- **GoogleSignIn** (OAuth): [github.com/google/GoogleSignIn-iOS](https://github.com/google/GoogleSignIn-iOS)
- **Starscream** (WebSockets - for Live Mode): [github.com/daltoniam/Starscream](https://github.com/daltoniam/Starscream)
- **Sentry** (Crash Reporting - recommended): [docs.sentry.io/platforms/apple/](https://docs.sentry.io/platforms/apple/)

**Design Tools**:
- Figma (for UI mockups)
- SF Symbols (built-in iconography)

---

## Current Status & Next Steps

**Completed**:
- ✅ Project scope document
- ✅ Database schema design
- ✅ iOS Xcode project with SwiftUI
- ✅ Supabase authentication (email/password, Google Sign In, Apple Sign In)
- ✅ Core domain models and repositories
- ✅ Learn Mode basic implementation
- ✅ Profile and Home views
- ✅ Gamification UI (badges, leaderboards, XP)
- ✅ Mock data for testing
- ✅ Google Sign In Integration (with nonce support)
- ✅ Learn Mode polish (audio, haptics, celebration)

**In Progress** (App Store Preparation):

1. **Documentation Updates**
   - ✅ Update all Clerk references to Supabase
   - ✅ Rename clerkId to externalId in User entity
   - ✅ Add Supabase configuration guide
   - ✅ Document current architecture

2. **App Configuration**
   - Create Info.plist with required keys
   - ✅ Create PrivacyInfo.xcprivacy
   - ✅ Configure URL schemes for deep linking
   - ✅ App icon designed (AI-generated concept + documentation)
   - ✅ Set up app icon in Xcode Assets.xcassets

3. **Content Creation & Seeding**
   - ✅ Generate Football questions (Module 1: 80 questions across 10 lessons)
   - ✅ Create database seed script
   - ✅ Seed Supabase with test data (1 module, 1 lesson, 3 questions)
   - ✅ Generate additional modules (Modules 2-3) with content (22 lessons, 220 items)
   - ✅ Test content delivery (SQL seed verified)

4. **Feature Completion**
   - ✅ SRS (Spaced Repetition System) implementation in lessons
     - Progress bar only advances on correct answers
     - Wrong answers tracked and re-presented at end
     - Lesson completion requires all questions correct
     - Lesson locking/unlocking based on completion
   - Error handling and offline support

5. **Testing & QA**
   - ✅ Created unit test structure (SportsIQTests directory)
   - ✅ Unit tests for User entity
   - ✅ Unit tests for UserDTO conversion
   - ✅ Unit tests for Lesson entity
   - ✅ Unit tests for LessonDTO conversion
   - ✅ Created UI test structure (SportsIQUITests directory)
   - ✅ Basic UI test for app launch
   - Unit tests for ViewModels (in progress)
   - Unit tests for Repositories (in progress)
   - UI tests for main flows (in progress)
   - Accessibility audit
   - TestFlight beta

6. **App Store Submission**
   - ✅ Legal pages created (Privacy Policy, Terms of Service, Support)
   - ✅ App Store marketing copy written (description, keywords, what's new)
   - ✅ Screenshot plan created (8 detailed concepts)
   - ✅ Hosting setup guide created (GitHub Pages)
   - ✅ Deploy legal pages to GitHub Pages
   - ✅ Replace placeholder text in legal documents
   - Create actual screenshots from app
   - Final testing and submission


---

**Remember**: We're building for the long term. Make decisions that will make multi-platform expansion smooth, even though we're starting iOS-only. Write code that your future self (and future AI assistants) will thank you for.

**Good luck, and build something great!** 🏈🏀⚾🏒⚽⛳
