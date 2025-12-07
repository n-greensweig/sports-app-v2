# SportsIQ Project Scope & Guiding Document

**Version:** 1.0
**Last Updated:** 2025-11-15
**Status:** Planning Phase

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Product Vision](#product-vision)
3. [User Personas](#user-personas)
4. [Core Features](#core-features)
5. [Technical Architecture](#technical-architecture)
6. [Database Schema](#database-schema)
7. [UX/UI Design](#uxui-design)
8. [Content Strategy](#content-strategy)
9. [Gamification System](#gamification-system)
10. [Live Game Integration](#live-game-integration)
11. [MVP Roadmap](#mvp-roadmap)
12. [Future Considerations](#future-considerations)

---

## Executive Summary

**SportsIQ** (alternative names: Strategize, StrategEyes) is a sports education platform that combines proven spaced repetition learning mechanics with real-time sports knowledge acquisition. The app serves users across all skill levels—from complete novices to advanced fans—helping them deepen their understanding of sports while watching live games or practicing independently.

### Key Differentiators

- **Adaptive Learning**: Content tailored to four distinct skill levels
- **Live Game Companion**: Real-time prompts validated against actual play data
- **Multi-Sport Platform**: Modular architecture supporting football, basketball, baseball, hockey, soccer, and golf
- **Gamified Progress**: Medal systems, XP tracking, and leaderboards drive engagement
- **Spaced Repetition**: Proven memory techniques ensure long-term retention

### Initial Focus

**V1 MVP**: Football only, Swift/iOS first, with architecture designed for multi-platform expansion.

---

## Product Vision

### The Problem

Sports fans at all levels struggle to deepen their knowledge:
- **Novices** feel overwhelmed and don't know where to start
- **Beginners** understand basics but lack fluency in terminology and concepts
- **Intermediate fans** can't bridge the gap to strategic understanding
- **Advanced fans** want expert-level insights but lack structured learning paths

### The Solution

An app that meets users at their level with:
- **Bite-sized lessons** (≤5 minutes) for structured learning
- **Live game prompts** that turn passive watching into active learning
- **Progressive difficulty** with clear milestones
- **Instant validation** using real-time sports data
- **Engaging feedback** through sound, haptics, and visual rewards

### Success Metrics

- **Engagement**: 70%+ 7-day retention for active learners
- **Learning**: Measurable skill progression across levels
- **Live Usage**: 30%+ of users engage during live games
- **Social**: 40%+ of users participate in leaderboards
- **Growth**: Viral coefficient >0.5 through friend challenges

---

## User Personas

### 1. The Novice (Level 1)
**Profile**: Fiancée watching Packers games
**Experience**: 0 years of football
**Needs**: Basic terminology, game flow understanding
**Sample Questions**:
- "Which team has the ball?"
- "What yard-line is the ball on?"
- "Was that a run or a pass?"

**Success**: Can follow game action and understand scoring

### 2. The Beginner (Level 2)
**Profile**: Mom with 55 years of casual viewing
**Experience**: Understands runs/passes, basic penalties
**Gaps**: Formation names, positional roles, tactical concepts
**Sample Questions**:
- "What formation is the offense in? (I-formation, Shotgun, etc.)"
- "Which position made the tackle? (DL, LB, CB, S)"
- "Is this an empty backfield?"

**Success**: Can identify formations, positions, and common play types

### 3. The Intermediate Fan (Level 3)
**Profile**: Self, 25 years of watching
**Experience**: Knows when penalties should be called
**Gaps**: Defensive schemes, strategic adjustments, advanced tactics
**Sample Questions**:
- "Did the defense blitz? From where?"
- "Did the O-line double-team anyone?"
- "What coverage is the defense running? (Cover 2, Cover 3)"

**Success**: Understands the strategic chess match between offense and defense

### 4. The Advanced Student (Level 4)
**Profile**: Friend who played at University of Nebraska
**Experience**: Deep tactical knowledge from playing
**Gaps**: Front office strategy, expert-level film study, NFL veteran insights
**Sample Questions**:
- "What route concept is the offense running? (Mesh, Levels, Flood)"
- "How did the QB manipulate the safety pre-snap?"
- "What's the defensive coverage adjustment to this formation?"

**Success**: Can analyze games like a coach or professional analyst

---

## Core Features

### 1. Learn Mode (Practice)
**Gamified structured lessons**

- **Modules**: Thematic groupings (e.g., "Offensive Formations", "Defensive Coverages")
- **Lessons**: 5-minute sessions with 6-8 questions
- **Progressive Unlocking**: Complete current lesson to unlock next
- **Question Types**:
  - Multiple choice (MCQ)
  - Multi-select
  - Yard-line slider
  - Video clip labeling
  - Free text (advanced levels)
- **Immediate Feedback**: Sound, haptics, visual cues
- **Spaced Repetition**: Items resurface based on mastery

### 2. Live Mode (Game Companion)
**Real-time learning during live games**

- **Game Selection**: Choose from current/followed games
- **Contextual Prompts**: Questions tied to actual plays
- **Validation**: Answers checked against real-time data (Sportradar API or similar)
- **Cooldown System**: Prevents prompt fatigue (configurable per level)
- **Confidence Handling**: Graceful degradation when data is uncertain
- **Post-Game Summary**: Performance recap with insights

### 3. Review Mode (Spaced Repetition)
**Optimized long-term retention**

- **Daily Queue**: Items due for review
- **SM-2/FSRS Algorithm**: Scientifically-backed scheduling
- **Quick Sessions**: 3-minute focused reviews
- **Per-Sport Filtering**: Focus on specific sports
- **Mastery Tracking**: Visual progress indicators

### 4. Social & Gamification
**Motivational systems**

- **XP System**: Points for lessons, live answers, streaks
- **Overall Rating**: 0-99 score per sport (like video game player ratings)
- **Medals**: Bronze → Silver → Gold progression
- **Sport-Specific Titles**:
  - Football: Pee-wee → High School → College → Pro → Hall of Famer
  - Basketball: Bench Player → Starter → All-Star → MVP
- **Leaderboards**: Daily, weekly, all-time; friends & global
- **Streaks**: Consecutive days of learning
- **Badges**: Achievement unlocks for milestones

---

## Technical Architecture

### Platform Strategy

**Phase 1 (MVP)**: Swift/iOS
- SwiftUI for modern, declarative UI
- iOS 17+ minimum deployment target
- Optimized for iPhone, with iPad/Mac support

**Phase 2**: Multi-platform expansion
- Kotlin Multiplatform Mobile (KMM) for shared business logic
- SwiftUI for iOS, Jetpack Compose for Android
- Shared modules: networking, database, business logic
- Platform-specific: UI, haptics, notifications

### Architecture Pattern

**Clean Architecture with MVVM**

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (SwiftUI Views, ViewModels)            │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│         Domain Layer                    │
│  (Use Cases, Business Logic)            │
│  [Future: Shared KMM Module]            │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│         Data Layer                      │
│  (Repositories, Network, Database)      │
│  [Future: Shared KMM Module]            │
└─────────────────────────────────────────┘
```

### Core Technology Stack

**iOS (Phase 1)**
- **UI**: SwiftUI
- **Navigation**: NavigationStack, Coordinator pattern
- **State Management**: Combine, @Observable
- **Networking**: URLSession with async/await
- **Database**: SwiftData or Core Data (local caching)
- **Backend Communication**: REST/GraphQL
- **Authentication**: Supabase Auth
- **Analytics**: Custom + third-party integration
- **Video**: AVKit for clip playback
- **Haptics**: Core Haptics
- **Sound**: AVFoundation

**Shared/Backend**
- **Backend**: To be determined (Node.js, Python, or Go)
- **Database**: PostgreSQL (see schema below)
- **API**: REST or GraphQL
- **Real-time**: WebSockets for live game updates
- **Caching**: Redis for play data and session state
- **Sports Data**: Sportradar API (or alternative)
- **Auth**: Supabase Auth
- **Hosting**: AWS, GCP, or Vercel

**Future Multi-platform (Phase 2)**
- **Shared Logic**: Kotlin Multiplatform
  - Network layer
  - Database access
  - Business logic/Use cases
  - Models and serialization
- **Platform-Specific**:
  - iOS: SwiftUI
  - Android: Jetpack Compose
  - Web: React (if needed)

### Key Principles

1. **Platform Abstraction**: Core business logic isolated from platform code
2. **Testability**: Dependency injection, protocol-based design
3. **Offline-First**: Lessons work without internet; live mode requires connection
4. **Scalability**: Stateless backend services, horizontal scaling
5. **Cost Optimization**: Cache provider data aggressively

---

## Database Schema

### Philosophy

- **UUID primary keys** for distributed systems
- **Soft deletes** (deleted_at) for authorable content
- **Audit trails** (created_at, updated_at) on all tables
- **JSONB** for flexible, evolving data structures
- **Partitioning** for time-series data

### Schema Overview

```
Identity & Social
├── users
├── user_profiles
├── friends
└── devices

Sports & Taxonomy
├── sports
├── concepts
└── concept_tags

Learning Content
├── modules
├── lessons
├── lesson_concepts
├── items
├── item_variants
└── item_assets

Assessment
├── submissions
├── submission_judgments
└── user_item_stats

Progression & Gamification
├── user_progress
├── user_xp_events
├── streaks
├── badges
├── user_badges
└── leaderboards (daily/weekly/alltime)

Spaced Repetition
├── srs_cards
└── srs_reviews

Live Game Data
├── leagues
├── teams
├── seasons
├── games
├── drives
├── plays
├── play_features
├── provider_events
└── provider_mappings

Live Prompting
├── live_prompts
├── live_prompt_mappings
└── live_prompt_windows

Operations
├── sessions
├── analytics_events
├── content_releases
├── ab_tests
└── feature_flags
```

### Core Tables (Detailed)

See [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md) for complete DDL and detailed schema documentation.

### Indexing Strategy

**Critical Indexes**:
- `submissions(user_id, submitted_at DESC)` - User history
- `srs_cards(user_id, due_at)` - Review queue
- `plays(game_id, sequence)` - Play lookups
- `play_features.features_json` (GIN index) - Feature queries
- `user_xp_events(user_id, sport_id, occurred_at DESC)` - XP calculation
- `games(start_time)` - Active game queries

**Partitioning**:
- `analytics_events` - Monthly partitions
- `provider_events` - Monthly partitions
- `games` - Seasonal partitions

---

## UX/UI Design

### Design Pillars

1. **Clarity**: Clear affordances, obvious next actions
2. **Delight**: Playful animations, satisfying feedback
3. **Speed**: Fast transitions, optimistic updates
4. **Accessibility**: WCAG AA, scalable text, haptic alternatives to sound

### Visual Language

**Tone**: Friendly, encouraging, sports-themed
**Color Strategy**:
- Neutral base (grays, whites)
- Per-sport accents:
  - Football: Turf green (#2E7D32)
  - Basketball: Orange (#F57C00)
  - Baseball: Diamond blue (#1976D2)
  - Hockey: Ice blue (#0288D1)
  - Soccer: Pitch green (#388E3C)
  - Golf: Course green (#689F38)

**Typography**:
- Headings: SF Pro Display (iOS) / Roboto (Android)
- Body: SF Pro Text (iOS) / Roboto (Android)
- Monospace: SF Mono for stats/scores

**Iconography**:
- System icons where appropriate
- Custom sport-specific icons
- Animated state transitions

### Screen Flows

#### 1.1 Login & Registration
```
┌─────────────────────────┐
│   Welcome to SportsIQ   │
│                         │
│   [Learn Sports Like    │
│    a Pro]               │
│                         │
│   ┌─────────────────┐   │
│   │ Continue with   │   │
│   │ Google    [G]   │   │
│   └─────────────────┘   │
│   ┌─────────────────┐   │
│   │ Continue with   │   │
│   │ Apple     []   │   │
│   └─────────────────┘   │
│   ┌─────────────────┐   │
│   │ Continue with   │   │
│   │ Facebook  [f]   │   │
│   └─────────────────┘   │
│                         │
│   Already have account? │
└─────────────────────────┘
```

**Features**:
- Supabase-powered OAuth
- Persistent sessions
- Optional onboarding flow for new users

#### 1.2 Landing Page (Home)
```
┌─────────────────────────┐
│ SportsIQ          [👤]  │
├─────────────────────────┤
│ Continue Learning       │
│ ┌─────────────────────┐ │
│ │ 🏈 FOOTBALL         │ │
│ │ Overall: 67/99      │ │
│ │ ▓▓▓▓▓▓▓░░░░ 67%    │ │
│ │ Next: Coverages 101 │ │
│ └─────────────────────┘ │
│                         │
│ Start a New Sport       │
│ ┌────────┐  ┌────────┐ │
│ │🏀      │  │⚾      │ │
│ │Basketball│  │Baseball│ │
│ └────────┘  └────────┘ │
│ ┌────────┐  ┌────────┐ │
│ │🏒      │  │⚽      │ │
│ │Hockey  │  │Soccer  │ │
│ └────────┘  └────────┘ │
│                         │
│ [🏠] [📚] [🎮] [👤]     │
└─────────────────────────┘
```

**Navigation Tabs**:
- Home (sports selection)
- Learn (current sport lessons)
- Live (active games)
- Profile (account & stats)

#### 1.3 Sport Sub-Landing (Lesson Path)
```
┌─────────────────────────┐
│ ← Football        [⚙️]  │
├─────────────────────────┤
│ Your Progress           │
│ Overall: 67/99 ⭐⭐☆    │
│ Current Streak: 7 days  │
│                         │
│ Module 1: Basics        │
│ ● Lesson 1: Runs vs... ✓│
│ ● Lesson 2: Positions  ✓│
│ ● Lesson 3: Downs &... ✓│
│                         │
│ Module 2: Formations    │
│ ◉ Lesson 4: I-Form... ▶ │
│ ○ Lesson 5: Shotgun  🔒 │
│ ○ Lesson 6: Spread   🔒 │
│                         │
│ Module 3: Coverages  🔒 │
│ ○ Lesson 7: Cover 2  🔒 │
│ ○ Lesson 8: Cover 3  🔒 │
│                         │
│ [Review Queue: 12]      │
│                         │
│ [🏠] [📚] [🎮] [👤]     │
└─────────────────────────┘
```

**Legend**:
- ● = Completed (green)
- ◉ = In progress (blue)
- ○ = Locked (gray)

#### 1.4 Lesson Screen
```
┌─────────────────────────┐
│ ← Lesson 4: I-Formation │
│ ▓▓▓▓▓░░░░░░░ 5/12       │
├─────────────────────────┤
│                         │
│ [🎬 Video Clip]         │
│ Watch this play unfold  │
│                         │
│ Question:               │
│ What formation is the   │
│ offense using?          │
│                         │
│ ┌─────────────────────┐ │
│ │ A) Shotgun          │ │
│ └─────────────────────┘ │
│ ┌─────────────────────┐ │
│ │ B) I-Formation ✓    │ │
│ └─────────────────────┘ │
│ ┌─────────────────────┐ │
│ │ C) Spread           │ │
│ └─────────────────────┘ │
│                         │
│      [Check Answer]     │
│                         │
└─────────────────────────┘
```

**Feedback Flow**:
1. User selects answer
2. Button enabled
3. Tap "Check Answer"
4. Haptic feedback (success/neutral)
5. Sound effect (sport-specific cheer)
6. Visual feedback (green checkmark or gentle correction)
7. Explanation text appears
8. "Continue" button auto-appears after 1.5s

**After Correct Answer**:
```
┌─────────────────────────┐
│ ✓ Correct!              │
│                         │
│ The I-Formation features│
│ a fullback and tailback │
│ lined up behind the QB. │
│                         │
│ +10 XP                  │
│                         │
│      [Continue →]       │
└─────────────────────────┘
```

#### Lesson Complete Screen
```
┌─────────────────────────┐
│                         │
│        🎉  🏈  🎉        │
│                         │
│   Lesson Complete!      │
│                         │
│   Score: 10/12          │
│   Time: 4:32            │
│   XP Earned: +120       │
│                         │
│   Overall: 67 → 69      │
│   ▓▓▓▓▓▓▓░░░░ +2        │
│                         │
│   Next Lesson Unlocked  │
│   "Shotgun Formation"   │
│                         │
│   [Continue Learning]   │
│   [Back to Path]        │
│                         │
└─────────────────────────┘
```

#### 1.5 Live Mode (Game Companion)
```
┌─────────────────────────┐
│ ← Live Games      [⚙️]  │
├─────────────────────────┤
│ Games Today             │
│                         │
│ ┌─────────────────────┐ │
│ │ 🏈 NFL · 7:20 PM    │ │
│ │ GB vs CHI           │ │
│ │ Lambeau Field       │ │
│ │ [Join Live Mode] ▶  │ │
│ └─────────────────────┘ │
│                         │
│ ┌─────────────────────┐ │
│ │ 🏈 NFL · 4:25 PM    │ │
│ │ SF vs DAL           │ │
│ │ Levi's Stadium      │ │
│ │ [Join Live Mode] ▶  │ │
│ └─────────────────────┘ │
│                         │
│ No games today?         │
│ [Practice Film Room]    │
│                         │
└─────────────────────────┘
```

**During Live Game**:
```
┌─────────────────────────┐
│ GB 21 - CHI 14 · Q3 8:42│
│ 2nd & 7 at CHI 34       │
├─────────────────────────┤
│                         │
│   Quick Question!       │
│                         │
│   Did the defense       │
│   blitz on that play?   │
│                         │
│   ┌─────────────────┐   │
│   │ Yes, from slot  │   │
│   └─────────────────┘   │
│   ┌─────────────────┐   │
│   │ Yes, from edge  │   │
│   └─────────────────┘   │
│   ┌─────────────────┐   │
│   │ No blitz        │   │
│   └─────────────────┘   │
│   ┌─────────────────┐   │
│   │ Not sure        │   │
│   └─────────────────┘   │
│                         │
│   Answered: 14 · XP: 87 │
│                         │
│   [×] Minimize          │
└─────────────────────────┘
```

**Timing**:
- Prompt appears 3-5 seconds after play whistle
- 20-second window to answer
- Cooldown between prompts (30-60s depending on level)
- Minimizable floating card

#### 1.6 Profile & Account
```
┌─────────────────────────┐
│ Profile           [⚙️]  │
├─────────────────────────┤
│      [Avatar]           │
│   GridironGuru          │
│   Member since Nov 2025 │
│                         │
│ Your Sports             │
│ 🏈 Football  Overall: 67│
│ 🏀 Basketball Overall: 12│
│                         │
│ Achievements            │
│ 🥇 7-Day Streak         │
│ 🏆 Formation Master     │
│ ⭐ 100 Live Answers     │
│                         │
│ Leaderboard             │
│ Friends: #3             │
│ Global: #847            │
│                         │
│ [Edit Profile]          │
│ [Settings]              │
│ [Sign Out]              │
│                         │
│ [🏠] [📚] [🎮] [👤]     │
└─────────────────────────┘
```

### Feedback Systems

#### Audio Cues
**Football**:
- Correct: Crowd cheer + whistle (0.5s)
- Wrong: Neutral "hmm" tone (0.3s)
- Lesson complete: Victory horn (1.5s)

**Basketball**:
- Correct: Swish + crowd cheer
- Wrong: Buzzer (gentle)
- Complete: Buzzer-beater + roar

**Baseball**:
- Correct: Bat crack + cheer
- Wrong: Umpire "strike" call
- Complete: Home run crowd

#### Haptic Patterns (iOS)
- Correct: `UIImpactFeedbackGenerator(.light)` + `.success`
- Wrong: `UIImpactFeedbackGenerator(.rigid)` (single tap, no "error" feeling)
- Level up: `UINotificationFeedbackGenerator(.success)` + custom pattern
- Streak milestone: Triple light impact

#### Visual Feedback
- Correct: Green checkmark animation, subtle confetti
- Wrong: Orange highlight, no red X (non-punitive)
- Progress bar: Smooth fill animation with spring
- XP gain: Number counter animation

---

## Content Strategy

### Content Model

#### Item Template Library

1. **Binary Choice** (Novice)
   - Schema: `{ "type": "binary", "options": ["A", "B"] }`
   - Example: "Was that a run or pass?"

2. **Multiple Choice** (All levels)
   - Schema: `{ "type": "mcq", "options": ["A", "B", "C", "D"], "correct": 0 }`
   - Example: "Which formation? Shotgun / I-Form / Spread / Pistol"

3. **Multi-Select** (Intermediate+)
   - Schema: `{ "type": "multi_select", "options": [...], "correct": [0, 2] }`
   - Example: "Which routes were run? (Select all)"

4. **Slider/Range** (Beginner+)
   - Schema: `{ "type": "slider", "min": 0, "max": 100, "correct": 35, "tolerance": 3 }`
   - Example: "Where's the ball? (Yard line)"

5. **Video Clip Label** (All levels)
   - Schema: `{ "type": "clip_label", "clip_url": "...", "labels": [...] }`
   - Example: Watch play, identify formation

6. **Free Text** (Advanced)
   - Schema: `{ "type": "free_text", "keywords": [...], "scoring": "fuzzy" }`
   - Example: "Describe the route concept"

### Difficulty Calibration

**Novice (Level 1)**:
- Binary and 2-3 option MCQ
- Visual aids always present
- No jargon
- Concepts: game flow, basic rules, team possession

**Beginner (Level 2)**:
- 3-4 option MCQ
- Position identification
- Basic terminology introduction
- Concepts: positions, simple formations, common penalties

**Intermediate (Level 3)**:
- 4-5 option MCQ, multi-select
- Tactical analysis
- Standard jargon expected
- Concepts: coverages, blitzes, route concepts, line play

**Advanced (Level 4)**:
- Complex scenarios, free text
- Strategic reasoning
- Expert terminology
- Concepts: tendencies, adjustments, pre-snap reads, scheme philosophy

### Content Authoring Workflow

1. **Draft**: Content creator writes item with variants
2. **Review**: QA checks accuracy, difficulty calibration
3. **Tagging**: Associate with concepts, difficulty, sports
4. **Versioning**: item_variants allow A/B testing wording
5. **Release**: Publish to content_releases
6. **Analytics**: Monitor p-values, discrimination, time-to-answer
7. **Iterate**: Update underperforming items

### Content Volume (MVP - Football)

**Module 1: Basics** (Novice-Beginner)
- 10 lessons × 8 items = 80 items
- Topics: Game flow, scoring, positions, basic rules

**Module 2: Offensive Concepts** (Beginner-Intermediate)
- 12 lessons × 10 items = 120 items
- Topics: Formations, play types, route concepts, line play

**Module 3: Defensive Concepts** (Intermediate)
- 10 lessons × 10 items = 100 items
- Topics: Coverages, blitzes, gap assignments, tackling

**Module 4: Advanced Strategy** (Advanced)
- 8 lessons × 12 items = 96 items
- Topics: Adjustments, tendencies, situational football, film study

**Total MVP**: ~400 items (football only)

---

## Gamification System

### XP Economy

**Earning XP**:
- Lesson item correct: 10 XP
- Lesson perfect score bonus: +20 XP
- Live mode correct answer: 15 XP
- Daily streak: 25 XP
- Review item correct: 5 XP
- Weekly challenge: 50-200 XP
- Friend challenge win: 30 XP

**Spending XP** (Future):
- Cosmetic avatar items
- Custom sounds
- Early access to sports

### Overall Rating (0-99)

**Calculation** (per sport):
```
Base: 0
+ Lessons completed: +0.5 per lesson
+ Accuracy: (correct_answers / total_answers) × 20
+ Concepts mastered: (mastered_concepts / total_concepts) × 30
+ Live engagement: (live_answers / 100) × 10
+ Advanced items: (advanced_correct / 50) × 10

Cap: 99
```

**Thresholds**:
- 0-39: Rookie
- 40-59: Starter
- 60-74: Pro
- 75-84: All-Pro
- 85-94: Elite
- 95-99: Hall of Famer

### Medal System

**Per Module**:
- Bronze: Complete all lessons
- Silver: 85%+ average accuracy
- Gold: 95%+ average accuracy + speed bonus

**Visual**: Medals displayed on module cards

### Badges

**Achievement Types**:
- **Learning**: "First Lesson", "10 Lessons", "100 Lessons"
- **Mastery**: "Formation Expert", "Coverage Guru", "Blitz Detective"
- **Streaks**: "7-Day Streak", "30-Day Streak", "365-Day Legend"
- **Live**: "First Live Answer", "100 Live Answers", "Perfect Game"
- **Social**: "Friend Invited", "Leaderboard Top 10", "Challenge Winner"
- **Sport Completion**: "Football Scholar", "Multi-Sport Athlete"

### Leaderboards

**Categories**:
1. **Daily**: XP earned today (resets midnight local time)
2. **Weekly**: XP earned this week (resets Monday)
3. **All-Time**: Total lifetime XP

**Filters**:
- Friends only
- Global (opt-in)
- Per-sport

**Display**:
- Top 10 shown
- User's rank if outside top 10
- Visual indicators for movement (↑↓)

### Streaks

**Mechanism**:
- Earn by completing ≥1 lesson or ≥3 live answers per day
- Grace period: 2 "freeze" days per month (earned via 7-day milestone)
- Visual: Fire icon with day count

**Rewards**:
- Day 3: +25 XP bonus
- Day 7: +50 XP + freeze day
- Day 14: +100 XP + badge
- Day 30: +250 XP + badge + freeze day

---

## Live Game Integration

### Real-Time Data Strategy

#### Provider Options

**Option A: Sportradar API** (Recommended)
- **Pros**: Comprehensive, reliable, official NFL partner
- **Cons**: Expensive (~$500-2000/month per sport), rate limits
- **Coverage**: Play-by-play, player tracking, formations, advanced stats

**Option B: ESPN API** (Limited Free Tier)
- **Pros**: Free tier available, good basic data
- **Cons**: Limited advanced stats, no formation data
- **Coverage**: Scores, basic play-by-play

**Option C: Hybrid Approach**
- Basic data from ESPN
- Derive features via ML model from video/text
- Manual annotation for MVP

#### Data Flow

```
Provider Webhook/Poll
        ↓
provider_events (raw JSON)
        ↓
Normalizer Service
        ↓
games/drives/plays tables
        ↓
Feature Extractor (ML or rule-based)
        ↓
play_features (JSONB)
        ↓
Prompt Matcher
        ↓
live_prompt_windows
        ↓
Mobile App (WebSocket)
        ↓
User Submission
        ↓
Grader Service
        ↓
submission_judgments
```

### Feature Extraction

**Extracted Features** (per play):

```json
{
  "formation": "shotgun",
  "empty_backfield": false,
  "wr_count": 3,
  "te_count": 1,
  "rb_count": 1,
  "box_safeties": 1,
  "blitz": "slot",
  "blitz_count": 2,
  "coverage_shell": "C2",
  "ol_double_team": true,
  "motion_type": "jet_sweep",
  "target_area": "left_flat",
  "route_concept": "mesh"
}
```

**Confidence Scores**:
- Provider-supplied: 95-100%
- Rule-derived: 70-90%
- ML-inferred: 60-80%
- Manual-annotated: 100%

**Grading Logic**:
```python
def grade_answer(prompt, user_answer, play_features):
    rule = prompt.grading_rule_json

    if rule['type'] == 'exact':
        return user_answer == play_features[rule['key']]

    elif rule['type'] == 'categorical':
        return user_answer in rule['acceptable_values']

    elif rule['type'] == 'numeric':
        tolerance = rule['tolerance']
        actual = play_features[rule['key']]
        return abs(user_answer - actual) <= tolerance

    elif rule['type'] == 'boolean':
        return bool(user_answer) == bool(play_features[rule['key']])

    elif rule['type'] == 'confidence_threshold':
        if play_features['confidence'][rule['key']] < rule['min_confidence']:
            return None  # Skip grading, give partial credit
        return user_answer == play_features[rule['key']]
```

### Prompt Timing

**Trigger Logic**:
1. Play ends (whistle, tackle, incomplete, etc.)
2. Wait 3-5 seconds (allow user to see replay)
3. Check cooldown timer for this user
4. Select eligible prompt based on:
   - User level
   - Available features for this play
   - Concept coverage (avoid repetition)
   - Priority weight
5. Send to mobile app
6. Open 20-30 second answer window
7. Grade on submission

**Cooldown Rules**:
- Novice: 60s between prompts (low cognitive load)
- Beginner: 45s
- Intermediate: 30s
- Advanced: 20s

**Priority System**:
- High priority: Rare events (trick plays, unusual formations)
- Medium: Common but educational (blitzes, coverage shells)
- Low: Basic state (possession, down, distance)

### Cost Optimization

**Caching Strategy**:
1. **Provider Events**: Store raw JSON for 7 days hot, 30 days cold
2. **Play Features**: Compute once, cache indefinitely
3. **Game State**: Redis cache for last 10 plays per active game
4. **User Sessions**: Track which games user is watching, only poll those

**Rate Limiting**:
- Poll provider max 1x per 3-5 seconds per game
- Only fetch games with active user sessions
- Batch multiple user requests from same game

**Derived Features**:
- Pre-compute common features (formation, blitz) during ingest
- Lazy-compute advanced features (coverage shells) only if requested

**Estimated Costs** (Sportradar):
- 16 games/week × 4 weeks = 64 games/month
- ~150 plays/game × 64 = 9,600 plays
- Cost: ~$1000-1500/month (NFL only, regular season)

**Fallback for MVP**:
- Manual annotation of primetime games only (3-4/week)
- Curated "Film Room" with pre-annotated plays
- Delay grading by 2-3 minutes, allowing manual verification

---

## MVP Roadmap

### Phase 1: Foundation (Weeks 1-4)

**Goals**: Core infrastructure, authentication, basic UI

**Deliverables**:
- ✅ Project setup (Xcode, SwiftUI, package dependencies)
- ✅ Backend repo setup (language TBD)
- ✅ Database schema implementation
- ✅ Supabase authentication integration
- ✅ Basic navigation structure (tabs, routing)
- ✅ Landing page UI
- ✅ Profile page skeleton

**Tech Tasks**:
- Initialize Swift package with Clean Architecture structure
- Set up PostgreSQL database (local + staging)
- Implement core data models
- Create network layer with URLSession
- Build Coordinator navigation pattern

### Phase 2: Learn Mode (Weeks 5-8)

**Goals**: Full lesson experience, progress tracking

**Deliverables**:
- ✅ Sport sub-landing (lesson path)
- ✅ Lesson playback UI with progress bar
- ✅ Question type renderers (MCQ, multi-select, slider)
- ✅ Answer validation and feedback
- ✅ Sound and haptic feedback system
- ✅ XP and Overall rating calculation
- ✅ Lesson completion flow
- ✅ 50+ football items (Module 1 content)

**Tech Tasks**:
- ItemViewModel with state machine (idle, answering, feedback, complete)
- AudioManager with AVFoundation
- HapticManager with Core Haptics
- Animation system (Lottie or native)
- Local caching with SwiftData

### Phase 3: Gamification (Weeks 9-10)

**Goals**: Engagement systems, social features

**Deliverables**:
- ✅ Badge system
- ✅ Leaderboards (friends, global)
- ✅ Streak tracking
- ✅ XP event feed
- ✅ Achievement notifications
- ✅ Friend invites

**Tech Tasks**:
- Real-time leaderboard updates (polling or WebSocket)
- Push notification infrastructure
- Social graph implementation (friends table)

### Phase 4: Spaced Repetition (Weeks 11-12)

**Goals**: Long-term retention system

**Deliverables**:
- ✅ SRS scheduler (SM-2 algorithm)
- ✅ Daily review queue
- ✅ Review session UI
- ✅ Mastery indicators per item

**Tech Tasks**:
- SRS algorithm implementation
- Background scheduling (calculate due dates)
- Review session state management

### Phase 5: Live Mode (Weeks 13-16)

**Goals**: Real-time game companion (simplified MVP)

**Deliverables**:
- ✅ Game selection screen
- ✅ Live prompt UI (floating card)
- ✅ WebSocket connection to backend
- ✅ Real-time grading (manual annotation for MVP)
- ✅ Post-game summary
- ✅ 10+ annotated games (primetime only)

**Tech Tasks**:
- WebSocket client with Starscream
- Game state synchronization
- Provider integration (ESPN free tier or manual)
- Play feature extraction (manual annotation tool)

### Phase 6: Polish & Beta (Weeks 17-20)

**Goals**: TestFlight beta, user feedback

**Deliverables**:
- ✅ Onboarding flow
- ✅ Accessibility audit (VoiceOver, Dynamic Type)
- ✅ Performance optimization
- ✅ Error states and empty states
- ✅ Analytics integration
- ✅ TestFlight build
- ✅ 20 beta testers

**Tech Tasks**:
- Performance profiling (Instruments)
- Network resilience (retry, offline handling)
- Analytics events (PostHog, Mixpanel, or custom)
- Crash reporting (Sentry)

### Phase 7: Launch Prep (Weeks 21-24)

**Goals**: App Store submission, marketing

**Deliverables**:
- ✅ App Store assets (screenshots, preview video)
- ✅ Privacy policy, terms of service
- ✅ App Store submission
- ✅ Marketing website (optional)
- ✅ Social media presence
- ✅ Press kit

**Success Metrics for V1**:
- 100 downloads in first week
- 60% 7-day retention
- 10% daily active users engage with Live Mode
- 4.5+ App Store rating
- <2% crash rate

---

## Future Considerations

### Multi-Sport Expansion (V2)

**Priority Order**:
1. Football ✅ (MVP)
2. Basketball (high engagement, simpler rules)
3. Baseball (deep stats culture)
4. Soccer (global appeal)
5. Hockey (niche but passionate)
6. Golf (unique learning model)

**Adaptation Strategy**:
- Reuse content model (items, modules, lessons)
- Sport-specific taxonomies (concepts table)
- Custom sound/haptic themes per sport
- Sport-specific Overall calculation weights

### Android/Kotlin (V2)

**Approach**: Kotlin Multiplatform Mobile

**Shared Code** (~60-70%):
- Network layer (Ktor)
- Database access (SQLDelight)
- Business logic (UseCases)
- Models and serialization
- SRS algorithm

**Platform-Specific** (~30-40%):
- UI (SwiftUI vs Jetpack Compose)
- Navigation
- Haptics and audio
- Push notifications
- Platform APIs

**Migration Plan**:
1. Extract Swift business logic to protocols
2. Rewrite business logic in Kotlin Multiplatform
3. Keep SwiftUI, build Jetpack Compose separately
4. Share via Kotlin framework (iOS) / JVM library (Android)

### Web Version (V3)

**Use Cases**:
- Desktop experience during games (second screen)
- Promotional landing with sample lessons
- Content authoring tool (admin panel)

**Stack**:
- React or Next.js
- Shared API with mobile
- Limited feature set (no Live Mode initially)

### Advanced Features (Post-MVP)

**AI Coaching**:
- Personalized learning paths based on performance
- Adaptive difficulty in real-time
- "Why did I get this wrong?" explanations

**Video Integration**:
- Watch game clips within app
- Sync prompts with video timestamps
- User-generated clip annotations

**Community Features**:
- Discussion forums per sport
- User-created lessons (UGC)
- Expert AMAs and live sessions

**Monetization**:
- Freemium model (limit to 2 sports free, unlock all for $4.99/mo)
- Premium stats and insights
- Ad-free experience
- Early access to new sports

**Partnerships**:
- Sports leagues (NFL, NBA) for official branding
- Sports media (ESPN, The Athletic) for content
- Teams for local activations

---

## Success Criteria

### Product KPIs

**Engagement**:
- DAU/MAU ratio >30%
- Avg session length: 8-12 minutes
- Lessons completed per week per user: 5+
- Live Mode usage: 20%+ of users during games

**Learning**:
- Average level progression: 1 level per 3 months
- Concept mastery rate: 70%+ per completed module
- Review completion rate: 60%+

**Retention**:
- D1: 70%
- D7: 50%
- D30: 30%

**Social**:
- Friend invites per user: 1.5+
- Leaderboard participation: 40%+

### Technical KPIs

**Performance**:
- App launch time: <2s
- Lesson load time: <500ms
- Live prompt latency: <3s from play end
- Crash-free rate: >99%

**Scalability**:
- Support 10k concurrent live users
- Database query p95: <100ms
- API p95 latency: <200ms

**Cost**:
- Provider data cost per MAU: <$2
- Infrastructure cost per MAU: <$0.50
- Total cost per MAU: <$3 (target <$1 by V2)

---

## Open Questions

1. **Content Authoring**: Build custom CMS or use headless CMS (Strapi, Contentful)?
2. **Video Hosting**: Self-hosted (S3 + CloudFront) or Vimeo/Mux?
3. **Analytics**: PostHog, Mixpanel, Amplitude, or custom?
4. **Backend Language**: Node.js (TypeScript), Python (FastAPI), or Go?
5. **Real-time Architecture**: WebSockets, Server-Sent Events, or long polling?
6. **Monetization Timeline**: Launch free, or paid from day 1?
7. **Content Volume**: How many items per lesson is optimal? (current: 8-12)
8. **Live Mode Frequency**: How many prompts per game? (current: 15-20 for intermediate)

---

## Document Control

**Versioning**:
- v1.0 (2025-11-15): Initial scope document
- Future: Update as decisions are made and features evolve

**Review Cycle**:
- Weekly review during development
- Update after major feature completions
- Quarterly strategic review

**Related Documents**:
- [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md) - Complete SQL DDL
- [ARCHITECTURE.md](./ARCHITECTURE.md) - Detailed technical architecture
- [CONTENT_GUIDELINES.md](./CONTENT_GUIDELINES.md) - Item authoring standards
- [API_SPEC.md](./API_SPEC.md) - Backend API documentation

---

**End of Scope Document**
