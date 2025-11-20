# SportsIQ

**Learn sports like a pro — Duolingo for sports fans**

<p align="center">
  <em>From novice to expert, SportsIQ helps you understand the game you love.</em>
</p>

---

## Overview

SportsIQ is a mobile-first sports education platform that makes learning about sports engaging, accessible, and rewarding. Whether you're watching your first football game or you've been a fan for decades, SportsIQ meets you at your level and helps you progress through structured lessons and real-time game companion features.

### Key Features

- **📚 Structured Learning**: Bite-sized lessons (≤5 minutes) organized into progressive modules
- **🎮 Live Game Mode**: Real-time prompts during games, validated against actual play data
- **🔄 Spaced Repetition**: Scientifically-backed review system for long-term retention
- **🏆 Gamification**: XP, Overall ratings (0-99), medals, badges, and leaderboards
- **👥 Social Learning**: Compete with friends, share achievements, climb leaderboards
- **🌐 Multi-Sport**: Football, basketball, baseball, hockey, soccer, golf (football MVP first)

### Target Audience

**Four Learning Levels**:
1. **Novice** (Level 1): Complete beginners learning game basics
2. **Beginner** (Level 2): Casual fans understanding terminology and positions
3. **Intermediate** (Level 3): Engaged fans learning strategy and tactics
4. **Advanced** (Level 4): Serious students analyzing schemes and advanced concepts

---

## Project Status

**Current Phase**: Active Development - App Store Preparation
**Version**: MVP (Learn Mode + Gamification implemented)
**Next Milestone**: Full MVP with Review/Live Mode (12-16 weeks to App Store)

See [PROJECT_SCOPE.md](./docs/PROJECT_SCOPE.md) for complete roadmap.

---

## Documentation

- **[📋 Project Scope](./docs/PROJECT_SCOPE.md)**: Complete product vision, features, and roadmap
- **[🗄️ Database Schema](./docs/DATABASE_SCHEMA.md)**: Full PostgreSQL schema with all tables and relationships

### Quick Links

- [User Personas](./docs/PROJECT_SCOPE.md#user-personas)
- [Core Features](./docs/PROJECT_SCOPE.md#core-features)
- [Technical Architecture](./docs/PROJECT_SCOPE.md#technical-architecture)
- [UX/UI Design](./docs/PROJECT_SCOPE.md#uxui-design)
- [MVP Roadmap](./docs/PROJECT_SCOPE.md#mvp-roadmap)

---

## Tech Stack

### Phase 1 (MVP) - iOS First

**Frontend**:
- Swift + SwiftUI
- iOS 17+ minimum
- Clean Architecture + MVVM

**Backend**:
- Platform: Supabase (PostgreSQL + Auth + Realtime)
- Database: PostgreSQL 15+ (hosted on Supabase)
- Auth: Supabase Auth (email/password, Apple Sign In, Google Sign In)
- Realtime: Supabase Realtime (for Live Mode features)

**Live Data**:
- Sportradar API (or ESPN free tier for MVP)
- WebSockets for real-time updates

### Phase 2 - Multi-Platform

**Shared Logic**:
- Kotlin Multiplatform Mobile (KMM)
- Shared: Network, database, business logic
- Platform-specific: UI, haptics, notifications

**Platforms**:
- iOS: SwiftUI
- Android: Jetpack Compose
- Web: React (future consideration)

---

## Getting Started

### Prerequisites

- Xcode 15+
- Swift 5.9+
- Supabase account (backend + authentication)
- Apple Developer account (for Sign in with Apple)
- Google Cloud Console project (for Google Sign In)

### Installation

```bash
# Clone the repository
git clone https://github.com/n-greensweig/sports-app-v2.git
cd sports-app-v2

# Set up environment variables
cp .env.example .env
# Edit .env with your actual Supabase credentials

# For iOS configuration setup, see:
# ios/CONFIG_SETUP.md
```

### Development

```bash
# Run iOS app (once project is initialized)
# Coming soon...

# Run backend (once implemented)
# Coming soon...

# Run database migrations (once implemented)
# Coming soon...
```

---

## Project Structure

```
sports-app-v2/
├── docs/                       # Documentation
│   ├── PROJECT_SCOPE.md        # Complete project scope
│   ├── DATABASE_SCHEMA.md      # Database schema
│   └── ARCHITECTURE.md         # Technical architecture (coming soon)
├── ios/                        # iOS app
│   └── SportsIQ/
│       ├── App/                # App entry point & coordinator
│       ├── Core/
│       │   ├── Domain/         # Entities, Use Cases, Repository protocols
│       │   └── Data/           # DTOs, Repositories, Network layer
│       ├── Features/           # Feature modules
│       │   ├── Auth/           # Login, Sign Up, Forgot Password
│       │   ├── Home/           # Home dashboard
│       │   ├── Learn/          # Lessons & learning flow
│       │   ├── Profile/        # User profile & badges
│       │   ├── Review/         # Spaced repetition (in progress)
│       │   └── LiveMode/       # Live game mode (in progress)
│       ├── Shared/             # Shared UI components & services
│       └── Resources/          # Assets, sounds, etc.
├── supabase/                   # Supabase configuration
│   └── migrations/             # Database migrations
├── CLAUDE.md                   # Claude AI context & development guide
└── README.md
```

### Current Implementation

**Completed Features**:
- ✅ Supabase authentication (email/password, Apple Sign In)
- ✅ Learn Mode with multiple question types
- ✅ Gamification UI (XP, ratings, badges, leaderboards)
- ✅ User profiles and progress tracking
- ✅ Repository pattern with mock data support
- ✅ Clean Architecture with MVVM

**In Progress** (for App Store):
- 🚧 Google Sign In integration
- 🚧 Content creation (need 30+ more Football questions)
- 🚧 Audio & haptic feedback integration
- 🚧 Review/SRS system
- 🚧 Live Mode implementation
- 🚧 App Store configuration (Info.plist, Privacy manifest)
- 🚧 Legal pages (Privacy Policy, Terms of Service)

---

## Development Roadmap

### Phase 1: Foundation (Weeks 1-4)
- [x] Project setup (Xcode, Supabase)
- [x] Database schema implementation
- [x] Supabase authentication integration (email/password, Apple Sign In)
- [x] Basic navigation structure
- [x] Landing page UI

### Phase 2: Learn Mode (Weeks 5-8)
- [x] Lesson playback UI
- [x] Question type renderers (MCQ, multi-select, slider, true/false, free text)
- [x] Answer validation & feedback
- [ ] Sound & haptic feedback (managers exist, not connected)
- [ ] 50+ football items (currently ~20 items in mock data)

### Phase 3: Gamification (Weeks 9-10)
- [x] Badge system (UI complete, logic partial)
- [x] Leaderboards (UI complete, data fetching partial)
- [x] Streak tracking (UI complete)
- [x] XP event feed (structure in place)

### Phase 4: Spaced Repetition (Weeks 11-12)
- [ ] SRS scheduler (SM-2)
- [ ] Review queue
- [ ] Review session UI

### Phase 5: Live Mode (Weeks 13-16)
- [ ] Game selection screen
- [ ] Live prompt UI
- [ ] WebSocket connection
- [ ] Real-time grading

### Phase 6: Polish & Beta (Weeks 17-20)
- [ ] Onboarding flow
- [ ] Accessibility audit
- [ ] Performance optimization
- [ ] TestFlight beta

### Phase 7: Launch (Weeks 21-24)
- [ ] App Store submission
- [ ] Marketing website
- [ ] Press kit
- [ ] Launch! 🚀

See [complete roadmap](./docs/PROJECT_SCOPE.md#mvp-roadmap) for details.

---

## Design Philosophy

1. **Clarity over complexity**: Simple, obvious interactions
2. **Delight in details**: Thoughtful animations and feedback
3. **Respect user time**: ≤5 minute lessons, non-intrusive live prompts
4. **Accessibility first**: WCAG AA compliance, VoiceOver support
5. **Data-driven learning**: Spaced repetition, adaptive difficulty

---

## Contributing

**Current Status**: Private development phase. Contributions not yet accepted.

Future contribution guidelines will be added when the project reaches public beta.

---

## Success Metrics (V1 Goals)

- **Engagement**: 70%+ 7-day retention
- **Learning**: Measurable skill progression
- **Live Usage**: 30%+ engage during live games
- **Quality**: 4.5+ App Store rating, <2% crash rate

---

## License

TBD

---

## Contact

For questions or feedback:
- GitHub Issues: [Report a bug or request a feature](https://github.com/n-greensweig/sports-app-v2/issues)
- Email: TBD

---

## Acknowledgments

Inspired by:
- Duolingo's proven learning mechanics
- The passion of sports fans at all levels
- The desire to make sports knowledge accessible to everyone

---

**Built with ❤️ for sports fans everywhere**
