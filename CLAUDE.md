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

Be creative. Use real team names (but NOT real player names - see below). Make it feel like a real game. The goal is learning, not trick questions.

### Content Guidelines for Early Lessons

**Core Principle: Build Knowledge From Zero**

**CRITICAL: Assume the user knows NOTHING about football.** Early lessons must teach from absolute zero. Users should be able to answer every question using only:
1. Knowledge taught in the current lesson
2. Knowledge from previous lessons they've completed
3. Basic everyday words (team, field, ball, player, points, etc.)

**The Stacking Rule:**
Every lesson builds directly on the previous ones. Before using ANY football term in a question, that term MUST have been explicitly defined in a prior lesson. This is non-negotiable.

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

**No Real Player Names:**
- Do NOT use real player names in questions (e.g., "Patrick Mahomes throws to Travis Kelce")
- Real team names ARE allowed and encouraged (e.g., "The Kansas City Chiefs")
- Use generic descriptions instead: "the quarterback," "a wide receiver," "the running back"
- This avoids dating content and keeps focus on concepts rather than personalities

**Question Sequencing Rules:**
1. **NEVER reference concepts not yet taught** - If "down" hasn't been explained, you cannot ask "what down is it?"
2. **Define before testing** - Introduce a term/concept in lesson N, THEN quiz on it in lesson N or later
3. **GB1 should stand alone** - A user completing only GB1 should understand offense/defense and the basic objective
4. **Each lesson adds exactly one layer** - Don't introduce too many concepts at once
5. **Situational questions must use ONLY taught concepts** - Create scenarios using knowledge from current + prior lessons only

**Review Checklist for New Questions:**
- [ ] Does this question use ANY football term not yet defined? (If yes, STOP and fix it)
- [ ] Could someone who has never watched football answer this with prior lessons? (Must be yes)
- [ ] Does this question use real player names? (If yes, remove them)
- [ ] Is this practical knowledge for watching a game? (Should be yes)
- [ ] Am I assuming knowledge I haven't taught? (Must be no)

### Answer Feedback UI (Duolingo-Style)

**No Explanations:** Do NOT include explanation text after correct/incorrect answers. Keep the UI clean and minimal like Duolingo.

**Correct Answer Feedback:**
- Display a random encouraging phrase from a pool of 20+ options
- Show a green "CONTINUE" button
- Examples of encouraging phrases:
  - "Great!"
  - "Fantastic!"
  - "Wow!"
  - "Nice work!"
  - "You got it!"
  - "Correct!"
  - "Awesome!"
  - "Perfect!"
  - "Well done!"
  - "Nailed it!"
  - "Excellent!"
  - "Amazing!"
  - "Brilliant!"
  - "Keep it up!"
  - "You're on fire!"
  - "Crushing it!"
  - "Superb!"
  - "Outstanding!"
  - "Way to go!"
  - "That's right!"

**Incorrect Answer Feedback:**
- Show which answer was correct (highlight it)
- Display a brief, non-judgmental phrase like "Not quite" or "Almost!"
- Show a "CONTINUE" button to move on

**Database Note:** The `explanation_richtext` field in `item_variants` should be empty (`''`). Do not populate this field.

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

**IMPORTANT: Lessons in the Rookie section are ordered to build knowledge from absolute zero. Each lesson only uses concepts that have been explicitly taught in previous lessons. Do NOT reorder these lessons or add questions that reference untaught concepts.**

### Lesson Dependency Chain (Visual):
```
GB1 (What is football?)
  ↓
TF1 (The field layout)
  ↓
TF2 (Sidelines, out of bounds)
  ↓
SC1 (Touchdown - the main way to score)
  ↓
DS1 (What is a down? 4 tries to move 10 yards)
  ↓
DS2 (Reading "1st and 10", how downs work in detail)
  ↓
PT1 (Run plays vs pass plays)
  ↓
SC2 (Field goals, extra points, goalposts)
  ↓
TF3 (Line of scrimmage, hash marks, pylons)
  ↓
PT2 (First down scenarios, applying knowledge)
  ↓
[Continue to positions, penalties, etc.]
```

### Concepts Introduced Per Lesson (Reference Table):

| Lesson | New Concepts Introduced | Can Now Use in Questions |
|--------|------------------------|--------------------------|
| GB1 | Offense, defense, end zone (basic), taking turns | offense, defense, end zone, possession |
| TF1 | 100 yards, yard lines, 50-yard line, end zones (detailed) | yard lines, 50-yard line, end zone location |
| TF2 | Sidelines, out of bounds, boundary | sidelines, out of bounds, inbounds |
| SC1 | Touchdown (6 pts), goal line, scoring | touchdown, goal line, 6 points |
| DS1 | Down, 4 downs, gaining yards, 10-yard goal | down, 4 downs, gaining yards |
| DS2 | "1st and 10" notation, down resets, turnover on downs | 1st/2nd/3rd/4th down, "and X" notation |
| PT1 | Run play, pass play, throw, handoff | run, pass, throw, handoff |
| SC2 | Field goal (3 pts), extra point (1 pt), uprights/goalposts | field goal, extra point, goalposts, kicking |
| TF3 | Line of scrimmage, hash marks, pylons | line of scrimmage, hash marks, pylons |
| PT2 | First down achieved, incomplete pass, situational scenarios | All previous + situational questions allowed |

---

### LESSON: Game Basics 1 (GB1) - ORDER: 1
**Prerequisites:** None (first lesson)
**Topics covered:** What is football? Two teams take turns. Offense tries to move ball to opponent's end zone. Defense tries to stop them. Basic concept of possession.
**New terms introduced:** Offense, defense, end zone (basic), possession

### LESSON: The Field 1 (TF1) - ORDER: 2
**Prerequisites:** GB1
**Topics covered:** The field is 100 yards long. There's an end zone at each end. Yard lines are marked every 10 yards. The 50-yard line is in the middle. Numbers count down toward each end zone.
**New terms introduced:** 100-yard field, yard lines, 50-yard line, end zone location
**Can reference:** Offense, defense, end zone (from GB1)

### LESSON: The Field 2 (TF2) - ORDER: 3
**Prerequisites:** GB1, TF1
**Topics covered:** Sidelines run along the sides of the field. If a player steps on the sideline, they are "out of bounds" and the play stops. The field has boundaries.
**New terms introduced:** Sidelines, out of bounds, inbounds, boundary lines
**Can reference:** All TF1 and GB1 concepts

### LESSON: Scoring 1 (SC1) - ORDER: 4
**Prerequisites:** GB1, TF1, TF2
**Topics covered:** A touchdown is worth 6 points. To score a touchdown, the ball must cross the goal line into the end zone. The goal line is at the front of the end zone.
**New terms introduced:** Touchdown, goal line, 6 points
**Can reference:** End zone, field concepts

### LESSON: The Downs 1 (DS1) - ORDER: 5
**Prerequisites:** GB1, TF1, TF2, SC1
**Topics covered:** What is a "down"? A down is one play/attempt. The offense gets 4 downs to move the ball 10 yards. If they succeed, they get a new set of 4 downs. The goal is to keep moving toward the end zone.
**New terms introduced:** Down, 4 downs, 10-yard requirement
**Can reference:** All previous concepts

### LESSON: The Downs 2 (DS2) - ORDER: 6
**Prerequisites:** DS1
**Topics covered:** Reading "1st and 10" - means 1st down with 10 yards to go. How the down number increases (1st → 2nd → 3rd → 4th). What happens when you gain yards (yards to go decreases). What happens if you don't get 10 yards in 4 tries (other team gets ball).
**New terms introduced:** "1st and 10" notation, down progression, turnover on downs
**Can reference:** All previous concepts

### LESSON: Play Types 1 (PT1) - ORDER: 7
**Prerequisites:** DS1, DS2
**Topics covered:** Two main ways to move the ball: running and passing. Run play = player carries the ball. Pass play = ball is thrown through the air to a teammate. A catch = successfully receiving a thrown ball.
**New terms introduced:** Run play, pass play, throw, catch, handoff
**Can reference:** Downs, yards, field concepts

### LESSON: Scoring 2 (SC2) - ORDER: 8
**Prerequisites:** SC1, DS1, DS2, PT1
**Topics covered:** Field goal (3 points) - kicking the ball through the uprights. Extra point (1 point) - kick attempted after a touchdown. The tall yellow posts at the back of each end zone are called goalposts/uprights.
**New terms introduced:** Field goal, extra point, goalposts/uprights, kicking for points
**Can reference:** Touchdown, end zone, all previous

### LESSON: The Field 3 (TF3) - ORDER: 9
**Prerequisites:** All previous
**Topics covered:** Line of scrimmage - the imaginary line where the ball is placed before each play. Hash marks - short lines that mark where the ball can be placed. Pylons - orange markers at the corners of the end zone.
**New terms introduced:** Line of scrimmage, hash marks, pylons
**Can reference:** All previous concepts

### LESSON: Play Types 2 (PT2) - ORDER: 10
**Prerequisites:** All previous
**Topics covered:** Applying knowledge - situational questions about downs, yards gained, first downs achieved. What happens when a pass is not caught (incomplete). Simple game scenarios.
**New terms introduced:** Incomplete pass, first down (achieved)
**Can reference:** ALL previous concepts - this is where situational questions are appropriate

### QUIZ: Rookie Foundations Quiz

### LESSON: Offensive Positions 1 (OP1) - ORDER: 11
**Prerequisites:** PT1, PT2
**Topics covered:** Quarterback (QB) - the player who throws passes and hands off the ball. Running Back (RB) - the player who usually carries the ball on run plays.
**New terms introduced:** Quarterback, running back, QB, RB
**Can reference:** Run plays, pass plays, handoffs, throws

### LESSON: Offensive Positions 2 (OP2) - ORDER: 12
**Prerequisites:** OP1
**Topics covered:** Wide Receiver (WR) - players who run down the field to catch passes. Tight End (TE) - a player who can both catch passes and block.
**New terms introduced:** Wide receiver, tight end, WR, TE, blocking (basic)

### LESSON: Defensive Positions 1 (DP1) - ORDER: 13
**Prerequisites:** OP1, OP2
**Topics covered:** Defensive line - big players at the front who try to stop runs and rush the quarterback. Linebacker - players behind the line who tackle runners and cover receivers.
**New terms introduced:** Defensive line, linebacker, rushing the quarterback

### LESSON: Defensive Positions 2 (DP2) - ORDER: 14
**Prerequisites:** DP1
**Topics covered:** Cornerback - defenders who cover wide receivers. Safety - defenders who play deep and help stop long passes.
**New terms introduced:** Cornerback, safety, coverage

### QUIZ: Rookie Positions Quiz

### LESSON: Turnovers 1 (TO1) - ORDER: 15
**Prerequisites:** All positions lessons
**Topics covered:** Interception - when a defender catches a pass meant for the offense. Fumble - when a player drops the ball and the other team can recover it.
**New terms introduced:** Interception, fumble, turnover

### LESSON: Turnovers 2 (TO2) - ORDER: 16
**Prerequisites:** TO1
**Topics covered:** Forced fumble, fumble recovery, pick-six (interception returned for touchdown).
**New terms introduced:** Forced fumble, recovery, pick-six

### LESSON: Common Penalties 1 (CP1) - ORDER: 17
**Prerequisites:** TF3, OP1, DP1
**Topics covered:** False start - offense moves before the play starts. Offside - defense crosses line of scrimmage before snap.
**New terms introduced:** Penalty, false start, offside, snap

### LESSON: Common Penalties 2 (CP2) - ORDER: 18
**Prerequisites:** CP1
**Topics covered:** Holding - illegally grabbing another player. Pass interference - illegally preventing a catch.
**New terms introduced:** Holding, pass interference

### QUIZ: Rookie Penalties Quiz

### LESSON: Game Structure 1 (GS1) - ORDER: 19
**Prerequisites:** Basic scoring knowledge
**Topics covered:** A game has 4 quarters. Each quarter is 15 minutes. Teams switch sides at halftime.
**New terms introduced:** Quarter, halftime, game clock

### LESSON: Game Structure 2 (GS2) - ORDER: 20
**Prerequisites:** GS1
**Topics covered:** Timeouts - teams can stop the clock. Two-minute warning. Overtime if tied.
**New terms introduced:** Timeout, two-minute warning, overtime

### LESSON: Special Teams 1 (ST1) - ORDER: 21
**Prerequisites:** SC2, GS1
**Topics covered:** Kickoff - how each half and scoring play starts. Punt - kicking the ball to the other team when you can't get a first down.
**New terms introduced:** Kickoff, punt, special teams

### LESSON: Special Teams 2 (ST2) - ORDER: 22
**Prerequisites:** ST1
**Topics covered:** Field goal attempts, touchback, fair catch.
**New terms introduced:** Touchback, fair catch

### QUIZ: Rookie Game Structure Quiz

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