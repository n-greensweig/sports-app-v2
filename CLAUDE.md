# Ola Ball (SportsIQ) - Complete Project Guide

## Project Overview

**Ola Ball** (technical name: SportsIQ) is a sports education app that teaches users about sports (starting with football) using a Duolingo-inspired spaced repetition learning system. The app emphasizes gradual, continuous learning over time rather than quick completion.

**Current Status**: Active Development (Phase 1 - App Store Preparation)
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
- Questions only repeat within the same category (e.g., offensive terms questions only appear in offensive term lessons)

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
- Visual progress indicator: Circle with icon
  - Empty/grayed out initially
  - Ring fills in segments (⅕ increments) as user completes
  - Small gaps between ring segments
  - Icon becomes fully colored when lesson is complete
  - Incomplete segments remain grayed out

### Question Pool & Rotation System

Each lesson contains a **question pool** (typically 8-11 questions) but only shows **5 questions per session**. This creates variety across the 5 required completions and reinforces learning through spaced repetition.

**Question Pool Guidelines:**
- **Pool size:** 8-11 questions per lesson (minimum 8-9 for smaller lessons)
- **Questions per session:** 5 questions shown each time the user attempts the lesson
- **Required completions:** 5 times to master and unlock the next lesson

**How Question Selection Works:**

The app tracks which questions each user has seen (`seenItemIds`) and prioritizes showing unseen questions first:

| Completion | What the User Sees |
|------------|-------------------|
| **1st** | 5 new questions (all unseen) |
| **2nd** | ~4 new + ~1 review (prioritizes remaining unseen) |
| **3rd** | ~3 new + ~2 review (pool getting familiar) |
| **4th** | Mostly review, few new if any remain |
| **5th** | Strategic mix ensuring comprehensive coverage |

**Algorithm (in `LessonViewModel.swift`):**
1. Split all lesson items into "unseen" and "seen" based on user's history
2. Select unseen items first (up to 5)
3. Fill remaining slots with previously seen items
4. Shuffle final selection so new items aren't always first

**Why This Matters:**
- Users encounter **all questions** in the pool across their 5 completions
- Repetition reinforces learning without being boring
- Each session feels fresh with a mix of new and familiar content
- No single completion shows all questions, encouraging multiple attempts

**When Creating New Lessons:**
1. Write 8-11 questions covering the lesson's topics
2. Use a variety of question types (see below)
3. Set `items_per_session: 5` and `required_completions: 5` in the lesson config
4. The rotation algorithm handles the rest automatically

### Question Types & Variety

Use a mix of question formats to keep lessons engaging:

- **Single-answer multiple choice** - One correct answer from 3-4 options
- **True/False** - Simple binary questions
- **Multiple correct answers** - Select all that apply
- **Situational questions (~25%)** - Apply knowledge to realistic game scenarios

Situational questions are key to making learning stick. Example: "The line of scrimmage is at the Green Bay 25-yard line. The running back rushes for a 4-yard gain. On what yard line is the new line of scrimmage?"

Be creative. Use real team names. Make it feel like a real game. The goal is learning, not trick questions.

### Visual Icons (Football Theme)
Suggested icons for lessons:
- Star
- Weight
- Football
- Football helmet
- Football player

## Content Structure

### Complete Lesson Breakdown

---

## SECTION: Rookie

### LESSON: The Field 1 (TF1)
**Topics covered:** Dimensions, markings (yard lines), goal lines, end zones.

### LESSON: The Field 2 (TF2)
**Topics covered:** Uprights, hash marks, the line of scrimmage, pylon, sideline, boundary lines, field goal posts, press box.

### QUIZ: Rookie Field Quiz

### LESSON: Offensive Terms 1 (OT1)
**Topics covered:** Run, pass, catch, first down.

### LESSON: Offensive Terms 2 (OT2)
**Topics covered:** Field goal, touchdown, extra point, safety.

### LESSON: Offensive Terms 3 (OT3)
**Topics covered:** Conversion, line to gain, down by contact, inbounds/out of bounds, goal-line stand.

### QUIZ: Rookie Offensive Terms Quiz

### LESSON: Defensive Terms 1 (DT1)
**Topics covered:** Defensive line, linebacker, interception, fumble, sack.

### LESSON: Defensive Terms 2 (DT2)
**Topics covered:** Forced fumble, pass defensed, pick-six, strip-sack.

### LESSON: Defensive Terms 3 (DT3)
**Topics covered:** Turnover on downs, containment, secondary.

### QUIZ: Rookie Defensive Terms Quiz

### LESSON: Games & Overtime 1 (G&O 1)
**Topics covered:** Coin toss at beginning of game and overtime, timeouts, quarter and overtime period length.

### LESSON: Games & Overtime 2 (G&O 2)
**Topics covered:** Elect to defer or receive, why teams might choose to defer or receive, basic clock management, two-minute warning.

### LESSON: Games & Overtime 3 (G&O 3)
**Topics covered:** Sudden death, possession arrow (CFB), half-time, game clock vs. play clock.

### LESSON: Scoreboard & Records 1 (SR1)
**Topics covered:** Reading the score, understanding home/away designation, interpreting team records (Win-Loss-Tie), basic stat line components (passing yards, rushing yards, turnovers).

### LESSON: Scoreboard & Records 2 (SR2)
**Topics covered:** Basic stat line components (passing yards, rushing yards, turnovers, completions-incompletions).

### QUIZ: Rookie Test & Overtime Quiz

### LESSON: Common Penalties 1 (CP1)
**Topics covered:** Holding, false start, offside.

### LESSON: Common Penalties 2 (CP2)
**Topics covered:** DPI (Defensive Pass Interference), unnecessary roughness, roughing the passer, face mask.

### LESSON: Common Penalties 3 (CP3)
**Topics covered:** Neutral zone infraction, illegal block in the back, intentional grounding, encroachment, dead ball foul.

### QUIZ: Rookie Penalties Quiz

### LESSON: Coaches & Personnel 1 (C&P 1)
**Topics covered:** Head Coach, Offensive Coordinator, Defensive Coordinator, Special Teams Coordinator, basic roles.

### LESSON: Coaches & Personnel 2 (C&P 2)
**Topics covered:** Scouting, personnel groupings (basic introduction), general manager.

### QUIZ: Rookie Coaches & Personnel Quiz

### LESSON: Special Teams Fundamentals 1 (STF1)
**Topics covered:** Kickoff, punt, field goal attempt, extra point attempt (PAT).

### LESSON: Offensive Positions 1 (OP1)
**Topics covered:** Quarterback (QB), Running Back (RB), and descriptions of each of their roles.

### LESSON: Offensive Positions 2 (OP2)
**Topics covered:** Wide Receiver (WR), Tight End (TE), and descriptions of each of their roles.

### LESSON: Defensive Positions 1 (DP1)
**Topics covered:** Defensive Lineman (DL), Linebackers (LBs), and descriptions of each of their roles.

### LESSON: Defensive Positions 2 (DP2)
**Topics covered:** Cornerbacks (CBs), Safeties (Ss - Free/Strong), and descriptions of each of their roles.

### LESSON: Penalties Intermediate 1 (PI1)
**Topics covered:** Holding (offensive/defensive distinction), chop block, intentional grounding.

### QUIZ: Rookie Fundamentals Quiz

### QUIZ: Rookie Final Test

---

## SECTION: Veteran

### LESSON: Offense Fundamentals 1 (OF1)
**Topics covered:** Snap, huddle, basic offensive formation (e.g., I-formation, Shotgun).

### LESSON: Offense Fundamentals 2 (OF2)
**Topics covered:** Handoffs, passing routes (basic), check with me.

### LESSON: Offense Fundamentals 3 (OF3)
**Topics covered:** Hard count, motion, shift, blocking assignments (basic).

### LESSON: Defense Fundamentals 1 (DF1)
**Topics covered:** Basic defensive formations (e.g., 4-3, 3-4), man-to-man coverage, zone coverage (basic).

### LESSON: Defense Fundamentals 2 (DF2)
**Topics covered:** Tackling, gap control, run support, open-field tackling, assignment football.

### LESSON: Special Teams Fundamentals 2 (STF2)
**Topics covered:** Basic roles (kicker, punter, long snapper), kick return, punt return.

### LESSON: Special Teams Fundamentals 3 (STF3)
**Topics covered:** Touchback, fair catch signal, coverage team.

### LESSON: Offensive Positions 3 (OP3)
**Topics covered:** Offensive Line (OL), and description of its role, slot receiver.

### LESSON: Offensive Positions 4 (OP4)
**Topics covered:** Blindside protector, pulling guard, check-down receiver.

### LESSON: Offensive Positions 5 (OP5)
**Topics covered:** Dual-threat QB.

### QUIZ: Veteran Offensive Positions Quiz

### LESSON: Defensive Positions 3 (DP3)
**Topics covered:** Edge rusher, interior lineman, A-gap/B-gap/C-gap, middle linebacker (Mike).

### LESSON: Defensive Positions 4 (DP4)
**Topics covered:** Nickelback, dime back, deep half/third safety, press coverage, off-man coverage.

### QUIZ: Veteran Defensive Positions Quiz

### LESSON: Penalties Intermediate 2 (PI2)
**Topics covered:** Illegal formation, illegal shift, leverage, horse collar tackle.

### LESSON: Penalties Intermediate 3 (PI3)
**Topics covered:** Face guarding, unsportsmanlike conduct.

### QUIZ: Veteran Penalties Quiz

### LESSON: Challenges and Booth Reviews 1 (CBR1)
**Topics covered:** When a coach can challenge, what is reviewable, how the booth review works.

### LESSON: Challenges and Booth Reviews 2 (CBR2)
**Topics covered:** Loss of timeout, targeting (CFB), clear and obvious evidence, replay assistant.

### QUIZ: Veteran Challenges & Reviews Quiz

### LESSON: Offense Intermediate 1 (OI1)
**Topics covered:** Play calling basics (run/pass distribution), reading basic defenses, play-action pass.

### LESSON: Offense Intermediate 2 (OI2)
**Topics covered:** Screen pass, RPOs (Run-Pass Options - basic concept), jet sweep.

### LESSON: Offense Intermediate 3 (OI3)
**Topics covered:** Hurry-up offense, four-minute offense, heavy package.

### QUIZ: Veteran Offensive Concepts Quiz

### LESSON: Defense Intermediate 1 (DI1)
**Topics covered:** Blitzes (basic concepts), stunts/games on the defensive line, zone blitz.

### LESSON: Defense Intermediate 2 (DI2)
**Topics covered:** Identifying the "Mike" linebacker, defensive keys, read-and-react, delayed blitz.

### LESSON: Defense Intermediate 3 (DI3)
**Topics covered:** Mug look, anchor point.

### QUIZ: Veteran Defensive Concepts Quiz

### LESSON: Terms Intermediate 1 (TI1)
**Topics covered:** Blitz, Mike (linebacker), hurry, draw play.

### LESSON: Terms Intermediate 2 (TI2)
**Topics covered:** Bootleg, check-down, red zone, goal-to-go.

### LESSON: Terms Intermediate 3 (TI3)
**Topics covered:** Jumbo package, option route, seam route, wheel route, post-corner, sideline catch.

### QUIZ: Veteran Intermediate Terms Quiz

### LESSON: Special Teams Intermediate 1 (STI1)
**Topics covered:** Onside kick, squib kick, blocking a punt/field goal.

### LESSON: Special Teams Intermediate 2 (STI2)
**Topics covered:** Fair catch rules, return strategies, muff, downed punt.

### LESSON: Special Teams Intermediate 3 (STI3)
**Topics covered:** Coffin corner, holding for a kicker, shield punt.

### QUIZ: Veteran Special Teams Quiz

### LESSON: Common Lingo 1 (CL1)
**Topics covered:** Drop, Swat, Wrapped up, Breaks a tackle, Stiff arm.

### LESSON: Common Lingo 2 (CL2)
**Topics covered:** Left/Right hash, Hooked it (a field goal), Touchback, Fair Catch, Holding.

### LESSON: Common Lingo 3 (CL3)
**Topics covered:** Audibles, hot routes, gap integrity.

### LESSON: Common Lingo 4 (CL4)
**Topics covered:** Turnover margin, 3-and-out, dime/nickel package.

### LESSON: Common Lingo 5 (CL5)
**Topics covered:** In the box, over the top, cover zero, high-low concept, possession receiver.

### LESSON: Common Lingo 6 (CL6)
**Topics covered:** Play clock, game clock, two-minute drill.

### QUIZ: Veteran Lingo Quiz

### LESSON: NFL Conferences and Divisions (NCD)
**Topics covered:** AFC and NFC structure, East/North/South/West divisions, breakdown of divisions within each conference.

### LESSON: NFL Teams
**Topics covered:** Introduction to all current NFL teams.

### LESSON: NFL Playoffs 1 (NP1)
**Topics covered:** Wild card, divisional, conference championships, Super Bowl.

### LESSON: NFL Playoffs 2 (NP2)
**Topics covered:** Seeding process, home-field advantage.

### LESSON: CFB Conferences 1 (CFC1)
**Topics covered:** Power 5 vs. Group of 5, conference championships, realignment basics.

### LESSON: CFB Conferences 2 (CFC2)
**Topics covered:** Automatic qualifiers.
- FBS
  - Big Ten
  - Big 12
  - ACC
  - SEC
  - Pac 12
- FCS

### LESSON: CFB Playoffs 1 (CFP1)
**Topics covered:** Automatic bids, selection committee, ranking process.

### LESSON: CFB Playoffs 2 (CFP2)
**Topics covered:** New Year's Six bowls, strength of schedule (SOS).

### LESSON: CFB Teams
**Topics covered:** Introduction to major college football teams.

### LESSON: Bowl Games 1 (BG1)
**Topics covered:** Major bowl games, selection process, tie-ins.

### LESSON: Bowl Games 2 (BG2)
**Topics covered:** Bowl eligibility.

### QUIZ: Veteran League Structure Test

### QUIZ: Veteran Final Test

---

## SECTION: All-Pro

### LESSON: Regular Seasons 1 (RS1)
**Topics covered:** Number of games, bye weeks, NFL schedule format, strength of schedule, tie-breaking procedures for playoffs.

### LESSON: Regular Seasons 2 (RS2)
**Topics covered:** Division winner tiebreakers, wild card tiebreakers, home/away splits.

### QUIZ: All-Pro Regular Season Quiz

### LESSON: Front Office & Salary Cap 1 (FOSC1)
**Topics covered:** General Manager (GM) role, salary cap basics, scouting department.

### LESSON: Front Office & Salary Cap 2 (FOSC2)
**Topics covered:** Ownership role, cap space, dead cap, prorated bonus, cap hit.

### LESSON: Trades and Trade Deadline 1 (TTD1)
**Topics covered:** How trades work, trade compensation (draft picks).

### LESSON: Trades and Trade Deadline 2 (TTD2)
**Topics covered:** Implications of the trade deadline, conditional picks, trade block, cap consequences of a trade.

### LESSON: Free Agency 1 (FA1)
**Topics covered:** Unrestricted Free Agents (UFA), Restricted Free Agents (RFA), franchise tag.

### LESSON: Free Agency 2 (FA2)
**Topics covered:** Transition tag, basic contract structures (guaranteed money), void years, tender offer, market value.

### LESSON: Draft 1 (D1)
**Topics covered:** Draft order, compensatory picks, rounds.

### LESSON: Draft 2 (D2)
**Topics covered:** Positional value in the draft, scouting combine, pro day, sleeper pick, bust, trade value chart.

### QUIZ: All-Pro Off-Season Quiz

### LESSON: Injured Reserve & Roster Management 1 (IRM1)
**Topics covered:** IR rules, designation to return, short-term vs. long-term injury management.

### LESSON: Injured Reserve & Roster Management 2 (IRM2)
**Topics covered:** Practice squad rules, vested veteran, street free agent, waiver wire.

### LESSON: Transfers and Red Shirts (CFB Focus) 1 (TRS1)
**Topics covered:** NCAA transfer portal, redshirt rules (traditional and four-game rule), eligibility.

### LESSON: Transfers and Red Shirts (CFB Focus) 2 (TRS2)
**Topics covered:** Immediate Eligibility Rule, graduate transfer.

### QUIZ: All-Pro Roster Management Quiz

### LESSON: Fantasy Football 1 (FF1)
**Topics covered:** Basic scoring formats (PPR/Standard), drafting strategies.

### LESSON: Fantasy Football 2 (FF2)
**Topics covered:** Waivers, trade evaluations, value over replacement (VOR), streaming defenses/kickers, handcuff.

### QUIZ: All-Pro Fantasy Football Quiz

### QUIZ: All-Pro Final Test

---

## SECTION: MVP

### LESSON: Offensive Strategy Advanced 1 (OSA1)
**Topics covered:** Situational football (3rd down, 4th down decisions), clock management (kneel down, spiking the ball).

### LESSON: Offensive Strategy Advanced 2 (OSA2)
**Topics covered:** Personnel groupings (11, 12, 21 personnel), down-and-distance, chains, kill clock, complementary football.

### LESSON: Offensive Strategy Advanced 3 (OSA3)
**Topics covered:** Advanced route concepts (smash, shallow cross), reading defensive rotations (single high vs. two high safety looks).

### LESSON: Offensive Strategy Advanced 4 (OSA4)
**Topics covered:** Pre-snap reads (safeties, corners), progression reads, half-field read, route tree, alert call.

### QUIZ: MVP Advanced Offensive Strategy Quiz

### LESSON: Defensive Strategy Advanced 1 (DSA1)
**Topics covered:** Advanced zone coverages (Cover 3 Sky/Cloud, Quarters/Cover 4).

### LESSON: Defensive Strategy Advanced 2 (DSA2)
**Topics covered:** Hybrid defenses (sub-packages), defending different personnel groupings, base defense, boundary/field safety, overhang player.

### QUIZ: MVP Advanced Defensive Strategy Quiz

### QUIZ: MVP Final Test

---

## SECTION: HOF

### LESSON: Offensive Strategy Advanced 5 (OSA5)
**Topics covered:** Two-minute offense philosophy, no-huddle strategy (tempo).

### LESSON: Offensive Strategy Advanced 6 (OSA6)
**Topics covered:** Run scheme variations (Inside Zone, Outside Zone, Power, Counter), misdirection, option routes (advanced), play calling nomenclature.

### QUIZ: HOF Offensive Strategy Quiz

### LESSON: Defensive Strategy Advanced 3 (DSA3)
**Topics covered:** Pressure packages and exotic blitzes, disguising coverage.

### LESSON: Defensive Strategy Advanced 4 (DSA4)
**Topics covered:** Run defense gap assignments, defending RPOs, fire zone, simulated pressure, scraped over linebacker.

### QUIZ: HOF Defensive Strategy Quiz

### QUIZ: HOF Final Test

---

## SECTION: Legend

### LESSON: Defensive Strategy Advanced 5 (DSA5)
**Topics covered:** Match principles in zone coverage, defending screen passes, defending play-action.

### LESSON: Defensive Strategy Advanced 6 (DSA6)
**Topics covered:** Leveraging personnel matchups (shadowing WRs), pattern-matching, bracket coverage, force player.

### QUIZ: Legend Advanced Defensive Strategy Quiz

### QUIZ: Legend Final Test

---

## SECTION: GOAT

### LESSON: Scheme & Trend Analysis 1 (STA1)
**Topics covered:** Historical evolution of schemes (West Coast, Air Raid, 46 Defense), current league trends.

### LESSON: Scheme & Trend Analysis 2 (STA2)
**Topics covered:** Advanced metrics (DVOA, EPA), Pass blocking schemes (slide protection), run-pass ratio analysis, win rate.

### QUIZ: GOAT Scheme & Trend Analysis Quiz

### QUIZ: GOAT Final Test

---

## UI/UX Requirements

### Ola Character Animation

**Character Presence:**
- Animated avatar visible during lessons
- Character progresses along a physical path relevant to the sport
- For football: completing passes, scoring touchdowns, or other creative alternatives

**Correct Answer Animations (3 variations):**
1. Jumps in air and spins (synced with correct answer reveal)
2. Crosses arms, turns to side, smirks ("I'm so smart" expression)
3. Fist pump

**Incorrect Answer Animations:**
- Hangs head
- Shrugs shoulders
- Kicks invisible rocks/dirt

### Interface Philosophy
- Encourage a **fun, long learning journey**
- Discourage speed-running through content
- Present learning as a continuum rather than segmented categories
- Minimize over-structuring that might encourage skipping ahead

## Current To-Do List

| Task | Priority |
|------|----------|
| Rename app to 'Ola Ball' | High |
| Transfer GitHub ownership to NSG LLC | High |
| Switch icon to Ola Ball branding | High |
| Minimize profile view | Medium |
| Focus on building out learning material | High |
| Build questions for football lingo and phraseology | High |

## Future Considerations

### Live Mode (Not Current Priority)
- Real-time API integration with providers like Sportradar
- Live game data integration
- Current focus: Complete core learning system first

## Design Principles

### What We're Moving Away From:
- ❌ Broad category lessons ("Offensive Strategies", "Football Basics")
- ❌ One-and-done lesson structure
- ❌ Having to repeat completed lessons
- ❌ Over-segmented learning paths
- ❌ Speed-completion incentives

### What We're Building Toward:
- ✅ Granular topic lessons ("Offensive Terms 1", "Offensive Terms 2")
- ✅ Spaced repetition across multiple lessons
- ✅ Continuous reinforcement through forward progress
- ✅ Duolingo-inspired learning continuum
- ✅ Long-term engagement (weeks to months)
- ✅ Fun, gamified experience with Ola character

## Technical Notes

### Lesson Naming Convention
Use abbreviated codes for easy reference:
- TF1 = The Field 1
- OT1 = Offensive Terms 1
- DT1 = Defensive Terms 1
- G&O1 = Games & Overtime 1
- etc.

### Content Coverage Examples

**The Field 1 (TF1):**
- Dimensions, markings (yard lines), goal lines, end zones

**Offensive Terms 1 (OT1):**
- Run, pass, catch, first down

**Defensive Terms 1 (DT1):**
- Defensive line, linebacker, interception, fumble, sack

**Games & Overtime 1 (G&O1):**
- Coin toss (game/overtime), timeouts, quarter/overtime length

*(See full document for complete topic breakdowns per lesson)*

## Success Metrics
- Time to complete full progression: Weeks to months (target)
- User retention over time
- Lesson completion rates
- Question mastery (correct answers on repeated questions)

---

## Coding Standards

**Naming:** PascalCase for types, camelCase for variables/functions/constants. Use descriptive protocol names.

**Code Organization:** Use `// MARK:` sections. Inject dependencies via initializer. Use async/await (iOS 17+).

**SwiftUI:** Use `@State` for view state, `@Observable` for ViewModels, extract complex views into subviews. Always provide previews with mock data.

---

## Data Models

**Domain Entities** (platform-agnostic): `Lesson`, `Item`, `User`, `Sport` with standard Swift types (UUID, String, Int, etc.)

**DTOs** (Data Transfer Objects): Match database snake_case, convert to domain entities via `.toDomain()` method.

---

## Key Features Implementation

**Learn Mode:** State machine (loading/presenting/feedback/complete), audio feedback (AVFoundation), haptics (CoreHaptics).

**Live Mode:** WebSocket (URLSessionWebSocketTask), 3-5s delay after plays, 20-30s answer window.

**SRS:** SM-2 algorithm, track dueDate/interval/easeFactor/repetitions, limit 20 items/session.

**Gamification:** XP sources (lesson item 10XP, perfect score +20, live answer 15XP, daily streak 25XP). Overall rating 0-99 calculated from lessons/accuracy/concepts/live/advanced.

---

## Testing

**Unit Tests:** Test use cases and ViewModels with mock repositories. Use XCTest framework.

**UI Tests:** Test critical flows (lesson completion, unlocking, navigation) with XCUIApplication.

---

## Backend Integration

**Supabase handles:** Auth (email/password, Apple, Google), PostgreSQL database, real-time subscriptions, RLS policies.

**Key endpoints:** `/sports`, `/modules/:moduleId/lessons`, `/lessons/:lessonId`, `/submissions`, `/users/:userId/progress/:sportId`

**Direct queries via Supabase client:** `supabase.from("table").select().execute()`

---

## Supabase Setup

**Config:** Create `Secrets.swift` (gitignored) with URL and anon key. Use `AuthService` for email/password, Apple, Google auth. User profiles auto-created on signup.

**Database:** Direct queries via Supabase client. RLS policies protect user data. Public tables: sports, modules, lessons, items.

**Deep Linking:** Configure URL schemes (`com.sportsiq.app://auth/*`) in Info.plist and Supabase Dashboard.

**Setup:** Create project at supabase.com → Run SQL migration → Configure auth providers → Set up RLS policies → Customize email templates.

---

## Creating Lesson Seed SQL Files

When creating new lessons, follow this guide to generate proper SQL seed files.

### Critical IDs (Do Not Change)

```sql
-- Football Sport ID (MUST use this exact ID)
'0105433b-5bdd-4093-b6b1-157a0c3c515e'

-- Rookie Module ID
'11111111-1111-1111-1111-111111111111'

-- System User ID (for author_id)
'00000000-0000-0000-0000-000000000000'
```

### Lesson ID Pattern

Use this pattern for lesson IDs: `00000001-0000-0000-0000-00000000000X` where X is the lesson number.

| Lesson | ID |
|--------|-----|
| TF1 | `00000001-0000-0000-0000-000000000001` |
| TF2 | `00000001-0000-0000-0000-000000000002` |
| OT1 | `00000001-0000-0000-0000-000000000003` |
| ... | (increment last digit/use hex for >9) |

### Item ID Pattern

Use this pattern: `0000000X-0001-0000-0000-00000000000Y` where:
- X = lesson number (2 for TF2, 3 for OT1, etc.)
- Y = question number within lesson (1-11)

### Item Variant ID Pattern

Use: `0000000X-0001-0001-0000-00000000000Y` (note the middle `0001` for version 1)

### Required SQL Structure

Every lesson seed file MUST include these sections in order:

```sql
-- 1. Ensure Football sport exists (with ON CONFLICT)
INSERT INTO sports (id, slug, name, accent_color, description, order_index, is_active)
VALUES (
    '0105433b-5bdd-4093-b6b1-157a0c3c515e',
    'football',
    'Football',
    '#2E7D32',
    'Football - NFL and College',
    1,
    true
)
ON CONFLICT (slug) DO UPDATE SET
    name = EXCLUDED.name,
    accent_color = EXCLUDED.accent_color,
    description = EXCLUDED.description;

-- 2. Create Module (with ON CONFLICT)
INSERT INTO modules (id, sport_id, title, description, order_index, min_level, max_level, xp_reward)
VALUES (
    '11111111-1111-1111-1111-111111111111',
    '0105433b-5bdd-4093-b6b1-157a0c3c515e',
    'Rookie',
    'Start your football journey! Learn the basics of the field, scoring, and key terms.',
    1, 1, 2, 500
)
ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description;

-- 3. Create System User (with ON CONFLICT)
INSERT INTO users (id, clerk_user_id, email, role)
VALUES (
    '00000000-0000-0000-0000-000000000000',
    'system',
    'system@olaball.app',
    'admin'
)
ON CONFLICT (clerk_user_id) DO NOTHING;

-- 4. Create Lesson
INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (...);

-- 5. Create Items and Item Variants (8-11 questions per lesson)
```

### ON CONFLICT Clauses (Critical!)

Use the correct unique constraint for each table:

| Table | ON CONFLICT Target |
|-------|-------------------|
| `sports` | `(slug)` |
| `modules` | `(id)` |
| `users` | `(clerk_user_id)` |
| `lessons` | `(id)` |
| `items` | `(id)` |
| `item_variants` | `(item_id, version)` - **NOT (id)!** |

**Common Error:** Using `ON CONFLICT (id)` for `item_variants` will fail with:
```
ERROR: duplicate key value violates unique constraint "item_variants_unique_version"
```

**Correct item_variants insert:**
```sql
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (...)
ON CONFLICT (item_id, version) DO UPDATE SET
    prompt_richtext = EXCLUDED.prompt_richtext,
    options_json = EXCLUDED.options_json,
    correct_answer_json = EXCLUDED.correct_answer_json,
    explanation_richtext = EXCLUDED.explanation_richtext;
```

### Question Types

| Type | `type` value | `correct_answer_json` format |
|------|-------------|------------------------------|
| Multiple Choice | `'mcq'` | `'{"index": N}'` (0-indexed) |
| True/False | `'binary'` | `'{"boolean": true/false}'` |
| Multi-Select | `'multi_select'` | `'{"indices": [0, 2]}'` |

### Lesson Configuration

```sql
-- Standard lesson config
items_per_session: 5,      -- Questions shown per completion
required_completions: 5,   -- Times to complete for mastery
is_locked: true,           -- false only for first lesson (TF1)
est_minutes: 4,            -- Estimated completion time
xp_award: 50               -- XP earned per completion
```

### Example Seed File Location

See `/supabase/seed_tf1.sql` and `/supabase/seed_tf2.sql` for complete examples.

### Running Seed Files

Run in Supabase SQL Editor or via psql:
```bash
psql -h YOUR_HOST -d YOUR_DB -U postgres -f supabase/seed_tfX.sql
```

---

## Development Workflow

**Creating Features:** Create folder structure in `Features/`, add Views/ViewModels/Coordinator, write tests.

**Running App:** Always use **iPhone 17 Pro** simulator for development and testing. Use Xcode (Cmd+R) or `xcodebuild -scheme SportsIQ -destination 'platform=iOS Simulator,name=iPhone 17 Pro'`

**Conventions:** UTC for dates, UUID type for IDs, domain-specific errors with LocalizedError, handle with async throws.

---

## Design System

**Colors:** Sport-specific accents (Football #2E7D32, Basketball #F57C00, etc.). Use `sport.accentColor`.

**Typography:** heading1 (32pt bold), heading2 (24pt semibold), heading3 (20pt semibold), body (16pt), caption (14pt), small (12pt).

**Spacing:** XS(4), S(8), M(16), L(24), XL(32), XXL(48).

---

## Performance & Security

**Performance:** Use AsyncImage with placeholders, LazyVStack for lists, `[weak self]` in closures.

**Security:** Never commit API keys (use Secrets.swift, gitignored). Store auth tokens in Keychain. Never log sensitive data.

**Troubleshooting:** Ensure mock dependencies for previews, check WebSocket URL/permissions, verify audio files in bundle, add database indexes.

---

## Deployment

**TestFlight:** Archive in Xcode → Upload to App Store Connect → Add testers → Send invite.

**App Store Requirements:** Privacy Policy, Terms of Service, screenshots, description/keywords, support URL. Ensure >99% crash-free, 60fps UI, accessibility tested, privacy manifest included.

---

## Development Principles

**Key Questions:** Multi-platform ready? Testable? Clean Architecture? Accessible? Performant? Aligns with SRS philosophy?

**Avoid:** Business logic in views, hardcoded dependencies, ignoring errors, force unwrapping, platform code in domain, committing secrets, skipping accessibility, allowing lesson shortcuts.

**Embrace:** Dependency injection, testing critical paths, protocols for abstraction, graceful errors, async/await, SwiftUI previews, isolated platform code, spaced repetition, engaging UX.

---

## Resources

**Apple:** [SwiftUI](https://developer.apple.com/documentation/swiftui), [Swift Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html), [HIG](https://developer.apple.com/design/human-interface-guidelines/)

**Libraries:** Supabase Swift, GoogleSignIn, Starscream (WebSockets), Sentry (crash reporting)

**Learning:** [SM-2 Algorithm](https://en.wikipedia.org/wiki/SuperMemo#SM-2_algorithm), Duolingo design principles

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
- ✅ Complete lesson structure defined (Rookie through GOAT)
- ✅ Ola Ball branding and character requirements documented

**In Progress** (App Store Preparation):

1. **Documentation Updates**
   - ✅ Update all Clerk references to Supabase
   - ✅ Rename clerkId to externalId in User entity
   - ✅ Add Supabase configuration guide
   - ✅ Document current architecture
   - ✅ Integrate Ola Ball requirements with technical guide

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
   - ⏳ Generate remaining modules (Veteran through GOAT sections)
   - ⏳ Implement Ola character animations

4. **Feature Completion**
   - ✅ SRS (Spaced Repetition System) implementation in lessons
     - Progress bar only advances on correct answers
     - Wrong answers tracked and re-presented at end
     - Lesson completion requires all questions correct
     - Lesson locking/unlocking based on completion
   - ⏳ Multi-completion lesson system (3-5 completions per lesson)
   - ⏳ Question rotation across lessons
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

## Current To-Do List (from Product Requirements)

| Task | Priority | Status |
|------|----------|--------|
| Rename app to 'Ola Ball' | High | ✅ Documented |
| Transfer GitHub ownership to NSG LLC | High | Pending |
| Switch icon to Ola Ball branding | High | ✅ Completed |
| Minimize profile view | Medium | Pending |
| Focus on building out learning material | High | In Progress |
| Build questions for football lingo and phraseology | High | In Progress |
| Implement Ola character animations | High | Pending |
| Implement lesson completion rings/circles UI | Medium | Pending |
| Generate all section content (Veteran-GOAT) | High | Pending |

---

**Remember**: We're building for the long term with these principles:
1. **Spaced repetition over speed** - Learning takes weeks to months
2. **Multi-platform from day one** - Architecture supports future expansion
3. **Clean Architecture** - Keep layers separated and testable
4. **User engagement** - Fun, gamified, with Ola character presence
5. **Quality over shortcuts** - No compromises on the learning experience

**Good luck, and build something great!** 🏈🏀⚾🏒⚽⛳