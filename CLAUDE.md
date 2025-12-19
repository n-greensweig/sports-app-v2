# Ola Ball (SportsIQ) - Project Guide

## Project Overview

**Ola Ball** (technical name: SportsIQ) is a sports education app that teaches users about sports (starting with football) using a gamified spaced repetition learning system. The app emphasizes gradual, continuous learning over time rather than quick completion.

**Primary Stack**: Swift (iOS) + Supabase (PostgreSQL, Auth)
**Architecture**: Clean Architecture with MVVM pattern

## Core Learning Philosophy

### Spaced Repetition System (SRS)
- Questions appear across multiple lessons with decreasing frequency
- Users reinforce knowledge through repeated exposure to concepts
- No need to repeat previously completed lessons - future lessons inherently reinforce past material
- Learning journey should take **weeks to months** to complete (no shortcuts)

### Question Distribution Strategy
**For a 5-question lesson:**
- 1-4 questions repeated from previous lessons
- 1-4 new questions introduced
- Questions appear in different orders each time
- Questions only repeat within the same category

### Key Features
- **Structured bite-sized lessons** (≤5 minutes each)
- **Real-time prompts during live games** (future feature)
- **Spaced repetition for retention** (SM-2 algorithm)
- **Gamification** (XP, Overall ratings 0-99, medals, badges, leaderboards)
- **Ola character animation** (visible during lessons with reactions)

---

## Technical Architecture

**Stack:** Swift + SwiftUI + Supabase (PostgreSQL/Auth). MVVM + @Observable (iOS 17+).

**Multi-Platform Ready:** Clean Architecture with Presentation/Domain/Data layers. Domain/Data designed to migrate to Kotlin Multiplatform.

**Structure:** `ios/SportsIQ/{App, Core/{Domain,Data}, Features/{Auth,Home,Learn,LiveMode,Review,Profile}, Shared/{UI,Services}, Resources}`

---

## Structural Hierarchy

```
Section → Units → Lessons → Completions
```

### Lesson Completion Mechanics
- Each lesson must be passed **5 times** before progressing to the next lesson
- Visual progress indicator: Circle with icon that fills in ⅕ increments

### Question Pool & Rotation System

Each lesson contains a **question pool** (typically 8-11 questions) but only shows **5 questions per session**.

**Question Pool Guidelines:**
- **Pool size:** 8-11 questions per lesson
- **Questions per session:** 5 questions shown each time
- **Required completions:** 5 times to master and unlock the next lesson

**Algorithm (in `LessonViewModel.swift`):**
1. Split all lesson items into "unseen" and "seen" based on user's history
2. Select unseen items first (up to 5)
3. Fill remaining slots with previously seen items
4. Shuffle final selection

### Question Types & Variety

- **Single-answer multiple choice** - One correct answer from 3-4 options
- **True/False** - Simple binary questions
- **Multiple correct answers** - Select all that apply
- **Situational questions (~25%)** - Apply knowledge to realistic game scenarios

Use real team names but NOT real player names.

### Content Guidelines for Early Lessons

**CRITICAL: Assume the user knows NOTHING about football.** Early lessons must teach from absolute zero.

**The Stacking Rule:**
Every lesson builds directly on the previous ones. Before using ANY football term in a question, that term MUST have been explicitly defined in a prior lesson.

**Assumed Knowledge (OK to use without defining):**
- Basic words: team, field, ball, player, points, score, win, lose, game
- Spatial concepts: end, middle, side, left, right, forward, backward
- Numbers and counting
- Basic actions: run, throw, catch, kick, tackle, stop

**NOT Assumed (MUST be taught before using):**
- Touchdown, field goal, end zone, goal line
- Down, first down, "1st and 10" notation
- Offense, defense (in football context)
- Any position name (quarterback, running back, etc.)
- Line of scrimmage, hash marks, pylons
- Any play terminology (pass play, run play, etc.)

**No Real Player Names** - Use generic descriptions: "the quarterback," "a wide receiver"

**Review Checklist for New Questions:**
- [ ] Does this question use ANY football term not yet defined?
- [ ] Could someone who has never watched football answer this with prior lessons?
- [ ] Does this question use real player names?

### Answer Feedback UI

**No Explanations:** Do NOT include explanation text after correct/incorrect answers.

**Database Note:** The `explanation_richtext` field in `item_variants` should be empty (`''`).

---

## Content Structure

### Lesson Dependency Chain (Rookie Section):
```
GB1 (What is football?) → TF1 (The field layout) → TF2 (Sidelines, out of bounds) → SC1 (Touchdown) → DS1 (What is a down?) → DS2 (Reading "1st and 10") → PT1 (Run vs pass plays) → SC2 (Field goals, extra points) → TF3 (Line of scrimmage) → PT2 (First down scenarios)
```

### Concepts Introduced Per Lesson:

| Lesson | New Concepts Introduced |
|--------|------------------------|
| GB1 | Offense, defense, end zone (basic), taking turns |
| TF1 | 100 yards, yard lines, 50-yard line, end zones (detailed) |
| TF2 | Sidelines, out of bounds, boundary |
| SC1 | Touchdown (6 pts), goal line, scoring |
| DS1 | Down, 4 downs, gaining yards, 10-yard goal |
| DS2 | "1st and 10" notation, down progression, turnover on downs |
| PT1 | Run play, pass play, throw, catch, handoff |
| SC2 | Field goal (3 pts), extra point (1 pt), uprights/goalposts |
| TF3 | Line of scrimmage, hash marks, pylons |
| PT2 | Incomplete pass, first down (achieved) |

### Sections Overview
- **Rookie**: Basics (field, scoring, downs, positions, penalties, game structure, special teams)
- **Veteran**: Fundamentals, intermediate concepts, lingo, league structure
- **All-Pro**: Regular seasons, front office, trades, free agency, draft, roster management, fantasy
- **MVP**: Advanced offensive/defensive strategy
- **HOF**: Advanced schemes, exotic blitzes
- **Legend**: Match principles, pattern-matching
- **GOAT**: Scheme & trend analysis, advanced metrics

---

## UI/UX Requirements

### Ola Character Animation
- Animated avatar visible during lessons
- **Correct Answer Animations:** Jump/spin, smirk, fist pump
- **Incorrect Answer Animations:** Hang head, shrug, kick dirt

### Interface Philosophy
- Encourage a **fun, long learning journey**
- Discourage speed-running through content
- Present learning as a continuum

---

## Coding Standards

**Naming:** PascalCase for types, camelCase for variables/functions/constants.

**Code Organization:** Use `// MARK:` sections. Inject dependencies via initializer. Use async/await (iOS 17+).

**SwiftUI:** Use `@State` for view state, `@Observable` for ViewModels, extract complex views into subviews. Always provide previews with mock data.

---

## Data Models

**Domain Entities** (platform-agnostic): `Lesson`, `Item`, `User`, `Sport` with standard Swift types

**DTOs** (Data Transfer Objects): Match database snake_case, convert to domain entities via `.toDomain()` method.

---

## Key Features Implementation

**Learn Mode:** State machine (loading/presenting/feedback/complete), audio feedback (AVFoundation), haptics (CoreHaptics).

**Live Mode:** WebSocket (URLSessionWebSocketTask), 3-5s delay after plays, 20-30s answer window.

**SRS:** SM-2 algorithm, track dueDate/interval/easeFactor/repetitions, limit 20 items/session.

**Gamification:** XP sources (lesson item 10XP, perfect score +20, live answer 15XP, daily streak 25XP). Overall rating 0-99.

---

## Testing

**Unit Tests:** Test use cases and ViewModels with mock repositories. Use XCTest framework.

**UI Tests:** Test critical flows with XCUIApplication.

---

## Backend Integration

**Supabase handles:** Auth (email/password, Apple, Google), PostgreSQL database, real-time subscriptions, RLS policies.

**Direct queries via Supabase client:** `supabase.from("table").select().execute()`

---

## Creating Lesson Seed SQL Files

### Critical IDs (Do Not Change)

```sql
-- Football Sport ID
'0105433b-5bdd-4093-b6b1-157a0c3c515e'

-- Rookie Module ID
'11111111-1111-1111-1111-111111111111'

-- System User ID (for author_id)
'00000000-0000-0000-0000-000000000000'
```

### Lesson ID Pattern
Use: `00000001-0000-0000-0000-00000000000X` where X is the lesson number.

### Item ID Pattern
Use: `0000000X-0001-0000-0000-00000000000Y` where X = lesson number, Y = question number

### ON CONFLICT Clauses (Critical!)

| Table | ON CONFLICT Target |
|-------|-------------------|
| `sports` | `(slug)` |
| `modules` | `(id)` |
| `users` | `(clerk_user_id)` |
| `lessons` | `(id)` |
| `items` | `(id)` |
| `item_variants` | `(item_id, version)` - **NOT (id)!** |

### Question Types

| Type | `type` value | `correct_answer_json` format |
|------|-------------|------------------------------|
| Multiple Choice | `'mcq'` | `'{"index": N}'` (0-indexed) |
| True/False | `'binary'` | `'{"boolean": true/false}'` |
| Multi-Select | `'multi_select'` | `'{"indices": [0, 2]}'` |

### Lesson Configuration

```sql
items_per_session: 5,      -- Questions shown per completion
required_completions: 5,   -- Times to complete for mastery
is_locked: true,           -- false only for first lesson
est_minutes: 4,
xp_award: 50
```

See `/supabase/seed_tf1.sql` and `/supabase/seed_tf2.sql` for examples.

---

## Development Workflow

**Running App:** Always use **iPhone 17 Pro** simulator. Use Xcode (Cmd+R) or `xcodebuild -scheme SportsIQ -destination 'platform=iOS Simulator,name=iPhone 17 Pro'`

**Conventions:** UTC for dates, UUID type for IDs, domain-specific errors with LocalizedError.

---

## Design System

**Colors:** Sport-specific accents (Football #2E7D32, Basketball #F57C00, etc.)

**Typography:** heading1 (32pt bold), heading2 (24pt semibold), heading3 (20pt semibold), body (16pt), caption (14pt), small (12pt)

**Spacing:** XS(4), S(8), M(16), L(24), XL(32), XXL(48)

---

## Performance & Security

**Performance:** Use AsyncImage with placeholders, LazyVStack for lists, `[weak self]` in closures.

**Security:** Never commit API keys (use Secrets.swift, gitignored). Store auth tokens in Keychain.

---

## Deployment Checklist

### Supabase Configuration (Required Before App Store Release)

**CRITICAL: The current Supabase anon key has been exposed in git history and MUST be regenerated.**

#### 1. Regenerate API Key
1. Go to Supabase Dashboard → Project Settings → API
2. Click "Regenerate" on the `anon` public key
3. Update your local `Secrets.swift` with the new key
4. Update CI/CD environment variables with the new key

#### 2. Environment Variables for CI/CD
The app reads credentials from environment variables first, falling back to `Secrets.swift` for local development.

Set these in your CI/CD pipeline (Xcode Cloud, GitHub Actions, etc.):
```
SUPABASE_URL=https://gzghfnqpzjmcsenrnjme.supabase.co
SUPABASE_ANON_KEY=<your-new-regenerated-key>
```

#### 3. Xcode Cloud / CI Configuration
For Xcode Cloud, add environment variables in App Store Connect:
1. Go to App Store Connect → Your App → Xcode Cloud → Workflows
2. Edit your workflow → Environment Variables
3. Add `SUPABASE_URL` and `SUPABASE_ANON_KEY`

#### 4. Local Development Setup
For local development, ensure `Secrets.swift` exists at:
```
ios/SportsIQ/SportsIQ/Shared/Utils/Secrets.swift
```

With contents:
```swift
import Foundation

enum Secrets {
    static let supabaseURL = "https://gzghfnqpzjmcsenrnjme.supabase.co"
    static let supabaseAnonKey = "<your-key-here>"
}
```

**Note:** `Secrets.swift` is gitignored and should never be committed.

---

## Development Principles

**Avoid:** Business logic in views, hardcoded dependencies, ignoring errors, force unwrapping, platform code in domain, committing secrets, allowing lesson shortcuts.

**Embrace:** Dependency injection, testing critical paths, protocols for abstraction, graceful errors, async/await, SwiftUI previews, spaced repetition, engaging UX.

---

## Core Principles
1. **Spaced repetition over speed** - Learning takes weeks to months
2. **Multi-platform from day one** - Architecture supports future expansion
3. **Clean Architecture** - Keep layers separated and testable
4. **User engagement** - Fun, gamified, with Ola character presence
5. **Quality over shortcuts** - No compromises on the learning experience
