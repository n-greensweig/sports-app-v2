# Database Schema - SportsIQ

**Version:** 1.0
**Last Updated:** 2025-11-15
**Database:** PostgreSQL 15+

## Overview

This document contains the complete database schema for SportsIQ, including all tables, relationships, indexes, and constraints.

## Design Principles

1. **UUID Primary Keys**: Distributed-system friendly, prevents enumeration attacks
2. **Audit Trails**: `created_at`, `updated_at` on all tables
3. **Soft Deletes**: `deleted_at` for authorable content (items, lessons, modules)
4. **JSONB Flexibility**: Use for evolving schemas (features, options, metadata)
5. **Partitioning**: Time-series data partitioned by month
6. **Referential Integrity**: Foreign keys with appropriate cascade rules

---

## Schema Diagram

```
┌──────────────────────────────────────────────────────────────┐
│                     IDENTITY & SOCIAL                        │
├──────────────┬───────────────┬────────────┬─────────────────┤
│ users        │ user_profiles │ friends    │ devices         │
└──────────────┴───────────────┴────────────┴─────────────────┘

┌──────────────────────────────────────────────────────────────┐
│                   SPORTS & TAXONOMY                          │
├──────────────┬───────────────┬────────────────────────────────┤
│ sports       │ concepts      │ concept_tags                  │
└──────────────┴───────────────┴────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│                   LEARNING CONTENT                           │
├──────────┬─────────┬────────────────┬─────────┬──────────────┤
│ modules  │ lessons │ lesson_concepts│ items   │ item_variants│
│          │         │                │         │ item_assets  │
└──────────┴─────────┴────────────────┴─────────┴──────────────┘

┌──────────────────────────────────────────────────────────────┐
│                  ASSESSMENT & TRACKING                       │
├──────────────────┬──────────────────────┬───────────────────┤
│ submissions      │ submission_judgments │ user_item_stats   │
└──────────────────┴──────────────────────┴───────────────────┘

┌──────────────────────────────────────────────────────────────┐
│              PROGRESSION & GAMIFICATION                      │
├──────────────┬──────────────┬─────────┬────────┬────────────┤
│user_progress │user_xp_events│ streaks │ badges │user_badges │
│              │              │         │        │leaderboards│
└──────────────┴──────────────┴─────────┴────────┴────────────┘

┌──────────────────────────────────────────────────────────────┐
│                  SPACED REPETITION                           │
├──────────────────────────────┬──────────────────────────────┤
│ srs_cards                    │ srs_reviews                  │
└──────────────────────────────┴──────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│                    LIVE GAME DATA                            │
├────────┬───────┬─────────┬───────┬─────────┬────────────────┤
│leagues │ teams │ seasons │ games │ drives  │ plays          │
│        │       │         │       │         │ play_features  │
│        │       │         │       │         │provider_events │
└────────┴───────┴─────────┴───────┴─────────┴────────────────┘

┌──────────────────────────────────────────────────────────────┐
│                  LIVE PROMPTING                              │
├──────────────────┬─────────────────────┬────────────────────┤
│ live_prompts     │live_prompt_mappings │live_prompt_windows │
└──────────────────┴─────────────────────┴────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│               OPERATIONS & ANALYTICS                         │
├─────────┬──────────────────┬──────────────┬────────────────┤
│sessions │analytics_events  │content_releases│ab_tests      │
│         │                  │              │feature_flags   │
└─────────┴──────────────────┴──────────────┴────────────────┘
```

---

## Complete DDL

### Identity & Social

#### users
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    clerk_user_id TEXT UNIQUE NOT NULL,
    email CITEXT UNIQUE NOT NULL,
    role TEXT NOT NULL DEFAULT 'user',
    status TEXT NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ NULL
);

CREATE INDEX idx_users_clerk_id ON users(clerk_user_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_created_at ON users(created_at DESC);

COMMENT ON TABLE users IS 'Core user identity linked to Clerk authentication';
COMMENT ON COLUMN users.role IS 'user, admin, content_creator, moderator';
COMMENT ON COLUMN users.status IS 'active, suspended, deleted';
```

#### user_profiles
```sql
CREATE TABLE user_profiles (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    display_name TEXT NOT NULL,
    username TEXT UNIQUE,
    avatar_url TEXT,
    bio TEXT,
    country TEXT,
    timezone TEXT,
    birth_year INTEGER,
    favorite_team_id UUID NULL REFERENCES teams(id),
    notification_preferences JSONB NOT NULL DEFAULT '{}',
    privacy_settings JSONB NOT NULL DEFAULT '{"leaderboard_visible": true, "profile_public": true}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_user_profiles_username ON user_profiles(username) WHERE username IS NOT NULL;
CREATE INDEX idx_user_profiles_favorite_team ON user_profiles(favorite_team_id) WHERE favorite_team_id IS NOT NULL;

COMMENT ON TABLE user_profiles IS 'Extended user profile information';
```

#### friends
```sql
CREATE TYPE friend_status AS ENUM ('requested', 'accepted', 'blocked');

CREATE TABLE friends (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    friend_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status friend_status NOT NULL DEFAULT 'requested',
    requested_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    accepted_at TIMESTAMPTZ NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT friends_unique_pair UNIQUE (user_id, friend_user_id),
    CONSTRAINT friends_no_self CHECK (user_id != friend_user_id)
);

CREATE INDEX idx_friends_user_id ON friends(user_id, status);
CREATE INDEX idx_friends_friend_user_id ON friends(friend_user_id, status);

COMMENT ON TABLE friends IS 'Friend relationships between users';
```

#### devices
```sql
CREATE TYPE device_platform AS ENUM ('ios', 'android', 'web');

CREATE TABLE devices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    platform device_platform NOT NULL,
    device_identifier TEXT NOT NULL,
    push_token TEXT,
    app_version TEXT,
    os_version TEXT,
    last_seen_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT devices_unique_identifier UNIQUE (user_id, device_identifier)
);

CREATE INDEX idx_devices_user_id ON devices(user_id, last_seen_at DESC);
CREATE INDEX idx_devices_push_token ON devices(push_token) WHERE push_token IS NOT NULL;

COMMENT ON TABLE devices IS 'User devices for push notifications and analytics';
```

---

### Sports & Taxonomy

#### sports
```sql
CREATE TABLE sports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    icon_url TEXT,
    accent_color TEXT,
    description TEXT,
    order_index INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_sports_slug ON sports(slug);
CREATE INDEX idx_sports_active_order ON sports(is_active, order_index) WHERE is_active = true;

COMMENT ON TABLE sports IS 'Top-level sports categories (football, basketball, etc.)';

-- Seed data
INSERT INTO sports (slug, name, accent_color, order_index) VALUES
    ('football', 'Football', '#2E7D32', 1),
    ('basketball', 'Basketball', '#F57C00', 2),
    ('baseball', 'Baseball', '#1976D2', 3),
    ('hockey', 'Hockey', '#0288D1', 4),
    ('soccer', 'Soccer', '#388E3C', 5),
    ('golf', 'Golf', '#689F38', 6);
```

#### concepts
```sql
CREATE TABLE concepts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sport_id UUID NOT NULL REFERENCES sports(id) ON DELETE CASCADE,
    slug TEXT NOT NULL,
    name TEXT NOT NULL,
    description_md TEXT,
    difficulty SMALLINT CHECK (difficulty BETWEEN 1 AND 5),
    parent_concept_id UUID NULL REFERENCES concepts(id) ON DELETE SET NULL,
    order_index INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT concepts_unique_slug_per_sport UNIQUE (sport_id, slug)
);

CREATE INDEX idx_concepts_sport_id ON concepts(sport_id, order_index);
CREATE INDEX idx_concepts_parent ON concepts(parent_concept_id) WHERE parent_concept_id IS NOT NULL;
CREATE INDEX idx_concepts_difficulty ON concepts(sport_id, difficulty);

COMMENT ON TABLE concepts IS 'Learning concepts within each sport (e.g., formations, coverages)';
COMMENT ON COLUMN concepts.difficulty IS '1=Novice, 2=Beginner, 3=Intermediate, 4=Advanced, 5=Expert';
```

#### concept_tags
```sql
CREATE TABLE concept_tags (
    concept_id UUID NOT NULL REFERENCES concepts(id) ON DELETE CASCADE,
    tag TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (concept_id, tag)
);

CREATE INDEX idx_concept_tags_tag ON concept_tags(tag);

COMMENT ON TABLE concept_tags IS 'Flexible tagging for concepts (offense, defense, special-teams, etc.)';
```

---

### Learning Content

#### modules
```sql
CREATE TABLE modules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sport_id UUID NOT NULL REFERENCES sports(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    order_index INTEGER NOT NULL DEFAULT 0,
    min_level SMALLINT NOT NULL DEFAULT 1 CHECK (min_level BETWEEN 1 AND 4),
    max_level SMALLINT NOT NULL DEFAULT 4 CHECK (max_level BETWEEN 1 AND 4),
    icon_name TEXT,
    xp_reward INTEGER NOT NULL DEFAULT 0,
    release_id UUID NULL REFERENCES content_releases(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ NULL,
    CONSTRAINT modules_level_range CHECK (min_level <= max_level)
);

CREATE INDEX idx_modules_sport_order ON modules(sport_id, order_index) WHERE deleted_at IS NULL;
CREATE INDEX idx_modules_release ON modules(release_id) WHERE release_id IS NOT NULL;

COMMENT ON TABLE modules IS 'Top-level learning modules (e.g., "Offensive Formations")';
```

#### lessons
```sql
CREATE TABLE lessons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    module_id UUID NOT NULL REFERENCES modules(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    order_index INTEGER NOT NULL DEFAULT 0,
    est_minutes SMALLINT NOT NULL DEFAULT 5 CHECK (est_minutes <= 10),
    xp_award INTEGER NOT NULL DEFAULT 100,
    prerequisite_lesson_id UUID NULL REFERENCES lessons(id),
    is_locked BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ NULL
);

CREATE INDEX idx_lessons_module_order ON lessons(module_id, order_index) WHERE deleted_at IS NULL;
CREATE INDEX idx_lessons_prerequisite ON lessons(prerequisite_lesson_id) WHERE prerequisite_lesson_id IS NOT NULL;

COMMENT ON TABLE lessons IS 'Individual lessons within modules';
```

#### lesson_concepts
```sql
CREATE TABLE lesson_concepts (
    lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
    concept_id UUID NOT NULL REFERENCES concepts(id) ON DELETE CASCADE,
    weight NUMERIC(3, 2) NOT NULL DEFAULT 1.0 CHECK (weight >= 0 AND weight <= 1),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (lesson_id, concept_id)
);

CREATE INDEX idx_lesson_concepts_concept ON lesson_concepts(concept_id);

COMMENT ON TABLE lesson_concepts IS 'Maps lessons to concepts they teach, with relative weight';
```

#### items
```sql
CREATE TYPE item_type AS ENUM ('mcq', 'multi_select', 'slider', 'free_text', 'clip_label', 'binary');
CREATE TYPE item_status AS ENUM ('draft', 'review', 'live', 'retired');

CREATE TABLE items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lesson_id UUID NULL REFERENCES lessons(id) ON DELETE SET NULL,
    type item_type NOT NULL,
    base_prompt TEXT NOT NULL,
    answer_schema_json JSONB NOT NULL,
    author_id UUID NOT NULL REFERENCES users(id),
    status item_status NOT NULL DEFAULT 'draft',
    difficulty SMALLINT CHECK (difficulty BETWEEN 1 AND 5),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ NULL
);

CREATE INDEX idx_items_lesson ON items(lesson_id) WHERE lesson_id IS NOT NULL AND deleted_at IS NULL;
CREATE INDEX idx_items_status ON items(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_items_author ON items(author_id);

COMMENT ON TABLE items IS 'Atomic question items, can belong to lessons or be global (live mode)';
COMMENT ON COLUMN items.lesson_id IS 'NULL for global items used in live mode';
```

#### item_variants
```sql
CREATE TABLE item_variants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    item_id UUID NOT NULL REFERENCES items(id) ON DELETE CASCADE,
    version INTEGER NOT NULL,
    prompt_richtext TEXT NOT NULL,
    options_json JSONB NULL,
    correct_answer_json JSONB NOT NULL,
    explanation_richtext TEXT,
    media_ref TEXT,
    active BOOLEAN NOT NULL DEFAULT true,
    ab_test_id UUID NULL REFERENCES ab_tests(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT item_variants_unique_version UNIQUE (item_id, version)
);

CREATE INDEX idx_item_variants_item_active ON item_variants(item_id) WHERE active = true;
CREATE INDEX idx_item_variants_ab_test ON item_variants(ab_test_id) WHERE ab_test_id IS NOT NULL;

COMMENT ON TABLE item_variants IS 'Versioned item content for A/B testing and updates';
COMMENT ON COLUMN item_variants.media_ref IS 'Reference to video clip, image, or audio asset';
```

#### item_assets
```sql
CREATE TYPE asset_type AS ENUM ('image', 'audio', 'video');

CREATE TABLE item_assets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    variant_id UUID NOT NULL REFERENCES item_variants(id) ON DELETE CASCADE,
    type asset_type NOT NULL,
    uri TEXT NOT NULL,
    alt_text TEXT,
    duration_ms INTEGER NULL,
    width INTEGER NULL,
    height INTEGER NULL,
    file_size_bytes BIGINT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_item_assets_variant ON item_assets(variant_id);

COMMENT ON TABLE item_assets IS 'Media assets (images, videos, audio) for item variants';
```

---

### Assessment & Tracking

#### submissions
```sql
CREATE TYPE submission_context AS ENUM ('lesson', 'live', 'review');

CREATE TABLE submissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    context submission_context NOT NULL,
    item_variant_id UUID NULL REFERENCES item_variants(id),
    live_prompt_id UUID NULL REFERENCES live_prompts(id),
    session_id UUID NULL REFERENCES sessions(id),
    response_json JSONB NOT NULL,
    submitted_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    latency_ms INTEGER,
    device_platform device_platform,
    CONSTRAINT submission_has_reference CHECK (
        (context = 'live' AND live_prompt_id IS NOT NULL) OR
        (context != 'live' AND item_variant_id IS NOT NULL)
    )
);

CREATE INDEX idx_submissions_user_time ON submissions(user_id, submitted_at DESC);
CREATE INDEX idx_submissions_variant ON submissions(item_variant_id) WHERE item_variant_id IS NOT NULL;
CREATE INDEX idx_submissions_live_prompt ON submissions(live_prompt_id) WHERE live_prompt_id IS NOT NULL;
CREATE INDEX idx_submissions_session ON submissions(session_id) WHERE session_id IS NOT NULL;

-- Partition by month
CREATE TABLE submissions_2025_11 PARTITION OF submissions
    FOR VALUES FROM ('2025-11-01') TO ('2025-12-01');

COMMENT ON TABLE submissions IS 'User responses to items (lesson, live, or review)';
```

#### submission_judgments
```sql
CREATE TYPE judgment_type AS ENUM ('rules', 'ground_truth', 'ml', 'human', 'provider');

CREATE TABLE submission_judgments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    submission_id UUID NOT NULL REFERENCES submissions(id) ON DELETE CASCADE,
    is_correct BOOLEAN NOT NULL,
    score NUMERIC(4, 3) CHECK (score >= 0 AND score <= 1),
    judged_by judgment_type NOT NULL,
    explanation TEXT,
    ground_truth_ref UUID NULL,
    provider_event_id UUID NULL REFERENCES provider_events(id),
    confidence NUMERIC(3, 2),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_judgments_submission ON submission_judgments(submission_id);
CREATE INDEX idx_judgments_provider_event ON submission_judgments(provider_event_id) WHERE provider_event_id IS NOT NULL;

COMMENT ON TABLE submission_judgments IS 'Grading results for submissions with provenance';
COMMENT ON COLUMN submission_judgments.ground_truth_ref IS 'UUID of item_variant or play_features used for grading';
```

#### user_item_stats
```sql
CREATE TABLE user_item_stats (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    item_id UUID NOT NULL REFERENCES items(id) ON DELETE CASCADE,
    seen_count INTEGER NOT NULL DEFAULT 0,
    correct_count INTEGER NOT NULL DEFAULT 0,
    streak_correct INTEGER NOT NULL DEFAULT 0,
    last_seen_at TIMESTAMPTZ,
    easiness_factor NUMERIC(4, 2) DEFAULT 2.5,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT user_item_stats_unique UNIQUE (user_id, item_id)
);

CREATE INDEX idx_user_item_stats_user ON user_item_stats(user_id);
CREATE INDEX idx_user_item_stats_performance ON user_item_stats(user_id, correct_count, seen_count);

COMMENT ON TABLE user_item_stats IS 'Per-item performance tracking for adaptive learning';
```

---

### Progression & Gamification

#### user_progress
```sql
CREATE TABLE user_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    sport_id UUID NOT NULL REFERENCES sports(id) ON DELETE CASCADE,
    level SMALLINT NOT NULL DEFAULT 1 CHECK (level BETWEEN 1 AND 4),
    overall_rating SMALLINT NOT NULL DEFAULT 0 CHECK (overall_rating BETWEEN 0 AND 99),
    current_module_id UUID NULL REFERENCES modules(id),
    current_lesson_id UUID NULL REFERENCES lessons(id),
    total_xp INTEGER NOT NULL DEFAULT 0,
    lessons_completed INTEGER NOT NULL DEFAULT 0,
    live_answers INTEGER NOT NULL DEFAULT 0,
    concepts_mastered INTEGER NOT NULL DEFAULT 0,
    last_active_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT user_progress_unique UNIQUE (user_id, sport_id)
);

CREATE INDEX idx_user_progress_user_sport ON user_progress(user_id, sport_id);
CREATE INDEX idx_user_progress_overall ON user_progress(sport_id, overall_rating DESC);

COMMENT ON TABLE user_progress IS 'Per-sport progression tracking for each user';
COMMENT ON COLUMN user_progress.level IS '1=Novice, 2=Beginner, 3=Intermediate, 4=Advanced';
```

#### user_xp_events
```sql
CREATE TYPE xp_source AS ENUM ('lesson', 'live', 'review', 'streak', 'bonus', 'achievement');

CREATE TABLE user_xp_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    sport_id UUID NOT NULL REFERENCES sports(id) ON DELETE CASCADE,
    source xp_source NOT NULL,
    amount INTEGER NOT NULL,
    meta_json JSONB,
    occurred_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_xp_events_user_sport_time ON user_xp_events(user_id, sport_id, occurred_at DESC);
CREATE INDEX idx_xp_events_occurred ON user_xp_events(occurred_at DESC);

-- Partition by month
CREATE TABLE user_xp_events_2025_11 PARTITION OF user_xp_events
    FOR VALUES FROM ('2025-11-01') TO ('2025-12-01');

COMMENT ON TABLE user_xp_events IS 'Immutable log of all XP-earning events';
```

#### streaks
```sql
CREATE TABLE streaks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    sport_id UUID NOT NULL REFERENCES sports(id) ON DELETE CASCADE,
    current_days INTEGER NOT NULL DEFAULT 0,
    longest_days INTEGER NOT NULL DEFAULT 0,
    last_checkin_date DATE NOT NULL,
    freeze_days_available INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT streaks_unique UNIQUE (user_id, sport_id)
);

CREATE INDEX idx_streaks_user_sport ON streaks(user_id, sport_id);
CREATE INDEX idx_streaks_current ON streaks(current_days DESC);

COMMENT ON TABLE streaks IS 'Daily learning streak tracking per sport';
```

#### badges
```sql
CREATE TABLE badges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    criteria_json JSONB NOT NULL,
    sport_id UUID NULL REFERENCES sports(id),
    icon_asset TEXT,
    order_index INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_badges_slug ON badges(slug);
CREATE INDEX idx_badges_sport ON badges(sport_id) WHERE sport_id IS NOT NULL;

COMMENT ON TABLE badges IS 'Achievement badges (sport-specific or global)';
```

#### user_badges
```sql
CREATE TABLE user_badges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    badge_id UUID NOT NULL REFERENCES badges(id) ON DELETE CASCADE,
    awarded_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT user_badges_unique UNIQUE (user_id, badge_id)
);

CREATE INDEX idx_user_badges_user ON user_badges(user_id, awarded_at DESC);
CREATE INDEX idx_user_badges_badge ON user_badges(badge_id);

COMMENT ON TABLE user_badges IS 'Badges awarded to users';
```

#### leaderboards
```sql
CREATE TYPE leaderboard_window AS ENUM ('daily', 'weekly', 'alltime');

CREATE TABLE leaderboards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sport_id UUID NOT NULL REFERENCES sports(id) ON DELETE CASCADE,
    window leaderboard_window NOT NULL,
    window_start TIMESTAMPTZ NOT NULL,
    window_end TIMESTAMPTZ NOT NULL,
    rank INTEGER NOT NULL,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    xp INTEGER NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT leaderboards_unique_rank UNIQUE (sport_id, window, window_start, rank)
);

CREATE INDEX idx_leaderboards_sport_window ON leaderboards(sport_id, window, window_start, rank);
CREATE INDEX idx_leaderboards_user ON leaderboards(user_id, window);

COMMENT ON TABLE leaderboards IS 'Materialized leaderboard rankings (regenerated periodically)';
```

---

### Spaced Repetition

#### srs_cards
```sql
CREATE TABLE srs_cards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    item_id UUID NOT NULL REFERENCES items(id) ON DELETE CASCADE,
    variant_id UUID NOT NULL REFERENCES item_variants(id),
    sport_id UUID NOT NULL REFERENCES sports(id),
    due_at TIMESTAMPTZ NOT NULL,
    interval_days NUMERIC(8, 2) NOT NULL DEFAULT 1.0,
    ease_factor NUMERIC(4, 2) NOT NULL DEFAULT 2.5,
    repetitions INTEGER NOT NULL DEFAULT 0,
    lapses INTEGER NOT NULL DEFAULT 0,
    last_reviewed_at TIMESTAMPTZ NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT srs_cards_unique UNIQUE (user_id, item_id)
);

CREATE INDEX idx_srs_cards_user_due ON srs_cards(user_id, due_at) WHERE due_at <= now();
CREATE INDEX idx_srs_cards_sport ON srs_cards(sport_id);

COMMENT ON TABLE srs_cards IS 'Spaced repetition system cards (SM-2 or FSRS)';
```

#### srs_reviews
```sql
CREATE TABLE srs_reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    card_id UUID NOT NULL REFERENCES srs_cards(id) ON DELETE CASCADE,
    submission_id UUID NOT NULL REFERENCES submissions(id),
    reviewed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    grade SMALLINT NOT NULL CHECK (grade BETWEEN 0 AND 3),
    new_interval_days NUMERIC(8, 2) NOT NULL,
    new_ease_factor NUMERIC(4, 2) NOT NULL,
    new_due_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_srs_reviews_card_time ON srs_reviews(card_id, reviewed_at DESC);
CREATE INDEX idx_srs_reviews_reviewed_at ON srs_reviews(reviewed_at DESC);

COMMENT ON TABLE srs_reviews IS 'History of SRS review sessions';
COMMENT ON COLUMN srs_reviews.grade IS '0=wrong, 1=hard, 2=good, 3=easy';
```

---

### Live Game Data

#### leagues
```sql
CREATE TABLE leagues (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sport_id UUID NOT NULL REFERENCES sports(id) ON DELETE CASCADE,
    slug TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    country TEXT,
    provider_league_key TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_leagues_sport ON leagues(sport_id);
CREATE INDEX idx_leagues_slug ON leagues(slug);

COMMENT ON TABLE leagues IS 'Sports leagues (NFL, NCAA, NBA, etc.)';

-- Seed data
INSERT INTO leagues (sport_id, slug, name, country) VALUES
    ((SELECT id FROM sports WHERE slug = 'football'), 'nfl', 'NFL', 'USA'),
    ((SELECT id FROM sports WHERE slug = 'football'), 'ncaa-football', 'NCAA Football', 'USA'),
    ((SELECT id FROM sports WHERE slug = 'basketball'), 'nba', 'NBA', 'USA');
```

#### teams
```sql
CREATE TABLE teams (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    league_id UUID NOT NULL REFERENCES leagues(id) ON DELETE CASCADE,
    provider_team_key TEXT,
    name TEXT NOT NULL,
    abbreviation TEXT NOT NULL,
    city TEXT,
    logo_url TEXT,
    primary_color TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT teams_unique_provider_key UNIQUE (league_id, provider_team_key)
);

CREATE INDEX idx_teams_league ON teams(league_id);
CREATE INDEX idx_teams_abbreviation ON teams(abbreviation);

COMMENT ON TABLE teams IS 'Teams within leagues';
```

#### seasons
```sql
CREATE TYPE season_phase AS ENUM ('preseason', 'regular', 'postseason');

CREATE TABLE seasons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    league_id UUID NOT NULL REFERENCES leagues(id) ON DELETE CASCADE,
    year INTEGER NOT NULL,
    phase season_phase NOT NULL,
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT seasons_unique UNIQUE (league_id, year, phase)
);

CREATE INDEX idx_seasons_league_year ON seasons(league_id, year DESC);

COMMENT ON TABLE seasons IS 'League seasons (year + phase)';
```

#### games
```sql
CREATE TYPE game_status AS ENUM ('scheduled', 'in_progress', 'halftime', 'final', 'postponed', 'cancelled');

CREATE TABLE games (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    league_id UUID NOT NULL REFERENCES leagues(id) ON DELETE CASCADE,
    season_id UUID NOT NULL REFERENCES seasons(id),
    provider_game_id TEXT UNIQUE NOT NULL,
    home_team_id UUID NOT NULL REFERENCES teams(id),
    away_team_id UUID NOT NULL REFERENCES teams(id),
    start_time TIMESTAMPTZ NOT NULL,
    venue TEXT,
    status game_status NOT NULL DEFAULT 'scheduled',
    final_home_score INTEGER,
    final_away_score INTEGER,
    current_period TEXT,
    current_clock TEXT,
    metadata_json JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_games_league_time ON games(league_id, start_time DESC);
CREATE INDEX idx_games_provider_id ON games(provider_game_id);
CREATE INDEX idx_games_status_time ON games(status, start_time) WHERE status IN ('scheduled', 'in_progress');
CREATE INDEX idx_games_teams ON games(home_team_id, away_team_id);

COMMENT ON TABLE games IS 'Individual games/matches';
```

#### drives
```sql
CREATE TABLE drives (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    game_id UUID NOT NULL REFERENCES games(id) ON DELETE CASCADE,
    sequence INTEGER NOT NULL,
    team_id UUID NOT NULL REFERENCES teams(id),
    start_yardline SMALLINT,
    end_yardline SMALLINT,
    result TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT drives_unique_sequence UNIQUE (game_id, sequence)
);

CREATE INDEX idx_drives_game ON drives(game_id, sequence);
CREATE INDEX idx_drives_team ON drives(team_id);

COMMENT ON TABLE drives IS 'Offensive drives within a game (football-specific)';
```

#### plays
```sql
CREATE TABLE plays (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    game_id UUID NOT NULL REFERENCES games(id) ON DELETE CASCADE,
    drive_id UUID NULL REFERENCES drives(id),
    sequence INTEGER NOT NULL,
    clock TEXT,
    down SMALLINT,
    distance SMALLINT,
    yard_line SMALLINT,
    yard_line_side TEXT,
    play_text TEXT,
    possession_team_id UUID NULL REFERENCES teams(id),
    defense_team_id UUID NULL REFERENCES teams(id),
    provider_play_id TEXT UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT plays_unique_sequence UNIQUE (game_id, sequence)
);

CREATE INDEX idx_plays_game_sequence ON plays(game_id, sequence);
CREATE INDEX idx_plays_provider_id ON plays(provider_play_id) WHERE provider_play_id IS NOT NULL;
CREATE INDEX idx_plays_drive ON plays(drive_id) WHERE drive_id IS NOT NULL;

COMMENT ON TABLE plays IS 'Individual plays within a game';
```

#### play_features
```sql
CREATE TYPE feature_source AS ENUM ('provider', 'derived', 'ml', 'manual');

CREATE TABLE play_features (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    play_id UUID NOT NULL REFERENCES plays(id) ON DELETE CASCADE,
    features_json JSONB NOT NULL,
    confidence_json JSONB,
    source feature_source NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_play_features_play ON play_features(play_id);
CREATE INDEX idx_play_features_json ON play_features USING GIN (features_json);

COMMENT ON TABLE play_features IS 'Extracted features from plays for grading (formations, blitzes, etc.)';
COMMENT ON COLUMN play_features.features_json IS 'Example: {"formation": "shotgun", "blitz": "slot", "empty_backfield": true}';
```

#### provider_events
```sql
CREATE TABLE provider_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    provider TEXT NOT NULL,
    event_type TEXT NOT NULL,
    raw_json JSONB NOT NULL,
    game_id UUID NULL REFERENCES games(id),
    received_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    processed_at TIMESTAMPTZ NULL
);

CREATE INDEX idx_provider_events_game ON provider_events(game_id, received_at DESC) WHERE game_id IS NOT NULL;
CREATE INDEX idx_provider_events_received ON provider_events(received_at DESC);
CREATE INDEX idx_provider_events_processed ON provider_events(processed_at) WHERE processed_at IS NULL;

-- Partition by month
CREATE TABLE provider_events_2025_11 PARTITION OF provider_events
    FOR VALUES FROM ('2025-11-01') TO ('2025-12-01');

COMMENT ON TABLE provider_events IS 'Raw webhooks/polls from sports data providers';
```

#### provider_mappings
```sql
CREATE TABLE provider_mappings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    provider_event_id UUID NOT NULL REFERENCES provider_events(id) ON DELETE CASCADE,
    play_id UUID NOT NULL REFERENCES plays(id),
    mapping_notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_provider_mappings_event ON provider_mappings(provider_event_id);
CREATE INDEX idx_provider_mappings_play ON provider_mappings(play_id);

COMMENT ON TABLE provider_mappings IS 'Links provider events to normalized plays';
```

---

### Live Prompting

#### live_prompts
```sql
CREATE TABLE live_prompts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sport_id UUID NOT NULL REFERENCES sports(id) ON DELETE CASCADE,
    level_min SMALLINT NOT NULL DEFAULT 1 CHECK (level_min BETWEEN 1 AND 4),
    level_max SMALLINT NOT NULL DEFAULT 4 CHECK (level_max BETWEEN 1 AND 4),
    template_prompt TEXT NOT NULL,
    answer_schema_json JSONB NOT NULL,
    grading_rule_json JSONB NOT NULL,
    cooldown_seconds INTEGER NOT NULL DEFAULT 30,
    priority INTEGER NOT NULL DEFAULT 5,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT live_prompts_level_range CHECK (level_min <= level_max)
);

CREATE INDEX idx_live_prompts_sport_level ON live_prompts(sport_id, level_min, level_max) WHERE is_active = true;

COMMENT ON TABLE live_prompts IS 'Template prompts for live game mode';
COMMENT ON COLUMN live_prompts.grading_rule_json IS 'Example: {"type": "exact", "key": "possession_team_id"}';
```

#### live_prompt_mappings
```sql
CREATE TYPE mapping_compatibility AS ENUM ('exact', 'close', 'fallback');

CREATE TABLE live_prompt_mappings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    live_prompt_id UUID NOT NULL REFERENCES live_prompts(id) ON DELETE CASCADE,
    feature_key TEXT NOT NULL,
    extractor_expr TEXT NOT NULL,
    compatibility mapping_compatibility NOT NULL DEFAULT 'exact',
    min_confidence NUMERIC(3, 2) DEFAULT 0.70,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT live_prompt_mappings_unique UNIQUE (live_prompt_id, feature_key)
);

CREATE INDEX idx_live_prompt_mappings_prompt ON live_prompt_mappings(live_prompt_id);

COMMENT ON TABLE live_prompt_mappings IS 'Maps prompts to play_features keys for grading';
COMMENT ON COLUMN live_prompt_mappings.extractor_expr IS 'JSONPath expression, e.g., "$.possession_team_id"';
```

#### live_prompt_windows
```sql
CREATE TYPE prompt_window_status AS ENUM ('scheduled', 'sent', 'answered', 'expired', 'skipped');

CREATE TABLE live_prompt_windows (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    game_id UUID NOT NULL REFERENCES games(id) ON DELETE CASCADE,
    play_id UUID NOT NULL REFERENCES plays(id),
    live_prompt_id UUID NOT NULL REFERENCES live_prompts(id),
    user_id UUID NOT NULL REFERENCES users(id),
    expires_at TIMESTAMPTZ NOT NULL,
    status prompt_window_status NOT NULL DEFAULT 'scheduled',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_prompt_windows_user_game ON live_prompt_windows(user_id, game_id, created_at DESC);
CREATE INDEX idx_prompt_windows_status ON live_prompt_windows(status, expires_at);

COMMENT ON TABLE live_prompt_windows IS 'Scheduled/sent prompts for live games per user';
```

---

### Operations & Analytics

#### sessions
```sql
CREATE TYPE session_mode AS ENUM ('lesson', 'live', 'review', 'browse');

CREATE TABLE sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    mode session_mode NOT NULL,
    sport_id UUID NULL REFERENCES sports(id),
    game_id UUID NULL REFERENCES games(id),
    started_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    ended_at TIMESTAMPTZ NULL,
    device_platform device_platform,
    app_version TEXT
);

CREATE INDEX idx_sessions_user_started ON sessions(user_id, started_at DESC);
CREATE INDEX idx_sessions_game ON sessions(game_id) WHERE game_id IS NOT NULL;
CREATE INDEX idx_sessions_sport_mode ON sessions(sport_id, mode) WHERE sport_id IS NOT NULL;

COMMENT ON TABLE sessions IS 'User sessions for analytics and context';
```

#### analytics_events
```sql
CREATE TABLE analytics_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NULL REFERENCES users(id) ON DELETE SET NULL,
    session_id UUID NULL REFERENCES sessions(id),
    event_type TEXT NOT NULL,
    properties_json JSONB,
    occurred_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_analytics_events_user_time ON analytics_events(user_id, occurred_at DESC) WHERE user_id IS NOT NULL;
CREATE INDEX idx_analytics_events_type ON analytics_events(event_type, occurred_at DESC);

-- Partition by month
CREATE TABLE analytics_events_2025_11 PARTITION OF analytics_events
    FOR VALUES FROM ('2025-11-01') TO ('2025-12-01');

COMMENT ON TABLE analytics_events IS 'Append-only analytics event log';
```

#### content_releases
```sql
CREATE TABLE content_releases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    notes TEXT,
    rolled_out_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_content_releases_rolled_out ON content_releases(rolled_out_at DESC);

COMMENT ON TABLE content_releases IS 'Content release versions for rollback capability';
```

#### ab_tests
```sql
CREATE TABLE ab_tests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    segment_json JSONB NOT NULL,
    started_at TIMESTAMPTZ NOT NULL,
    ended_at TIMESTAMPTZ NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_ab_tests_active ON ab_tests(started_at, ended_at) WHERE ended_at IS NULL;

COMMENT ON TABLE ab_tests IS 'A/B test configurations';
```

#### feature_flags
```sql
CREATE TABLE feature_flags (
    key TEXT PRIMARY KEY,
    enabled BOOLEAN NOT NULL DEFAULT false,
    rules_json JSONB,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE feature_flags IS 'Feature flags for gradual rollouts';
```

---

## Views

### Materialized: User Leaderboard Ranks
```sql
CREATE MATERIALIZED VIEW mv_user_leaderboard_ranks AS
SELECT
    user_id,
    sport_id,
    SUM(CASE WHEN occurred_at >= date_trunc('day', now()) THEN amount ELSE 0 END) AS daily_xp,
    SUM(CASE WHEN occurred_at >= date_trunc('week', now()) THEN amount ELSE 0 END) AS weekly_xp,
    SUM(amount) AS alltime_xp,
    RANK() OVER (PARTITION BY sport_id ORDER BY SUM(CASE WHEN occurred_at >= date_trunc('day', now()) THEN amount ELSE 0 END) DESC) AS daily_rank,
    RANK() OVER (PARTITION BY sport_id ORDER BY SUM(CASE WHEN occurred_at >= date_trunc('week', now()) THEN amount ELSE 0 END) DESC) AS weekly_rank,
    RANK() OVER (PARTITION BY sport_id ORDER BY SUM(amount) DESC) AS alltime_rank
FROM user_xp_events
GROUP BY user_id, sport_id;

CREATE UNIQUE INDEX idx_mv_leaderboard_user_sport ON mv_user_leaderboard_ranks(user_id, sport_id);
CREATE INDEX idx_mv_leaderboard_daily_rank ON mv_user_leaderboard_ranks(sport_id, daily_rank);

COMMENT ON MATERIALIZED VIEW mv_user_leaderboard_ranks IS 'Precomputed leaderboard rankings (refresh hourly)';
```

### View: User Due Reviews
```sql
CREATE VIEW vw_user_due_reviews AS
SELECT
    c.user_id,
    c.sport_id,
    c.id AS card_id,
    c.item_id,
    c.variant_id,
    c.due_at,
    i.type AS item_type,
    i.difficulty
FROM srs_cards c
JOIN items i ON c.item_id = i.id
WHERE c.due_at <= now()
ORDER BY c.user_id, c.due_at;

COMMENT ON VIEW vw_user_due_reviews IS 'Items due for review per user';
```

---

## Functions

### Update Overall Rating
```sql
CREATE OR REPLACE FUNCTION update_user_overall_rating(p_user_id UUID, p_sport_id UUID)
RETURNS VOID AS $$
DECLARE
    v_lessons_completed INTEGER;
    v_total_lessons INTEGER;
    v_correct_answers INTEGER;
    v_total_answers INTEGER;
    v_concepts_mastered INTEGER;
    v_total_concepts INTEGER;
    v_live_answers INTEGER;
    v_advanced_correct INTEGER;
    v_overall NUMERIC;
BEGIN
    -- Get counts
    SELECT
        COALESCE(up.lessons_completed, 0),
        COALESCE((SELECT COUNT(*) FROM lessons l JOIN modules m ON l.module_id = m.id WHERE m.sport_id = p_sport_id AND l.deleted_at IS NULL), 1),
        COALESCE(SUM(CASE WHEN sj.is_correct THEN 1 ELSE 0 END), 0),
        COALESCE(COUNT(*), 1),
        COALESCE(up.concepts_mastered, 0),
        COALESCE((SELECT COUNT(*) FROM concepts WHERE sport_id = p_sport_id), 1),
        COALESCE(up.live_answers, 0),
        COALESCE(SUM(CASE WHEN sj.is_correct AND i.difficulty >= 4 THEN 1 ELSE 0 END), 0)
    INTO
        v_lessons_completed, v_total_lessons, v_correct_answers, v_total_answers,
        v_concepts_mastered, v_total_concepts, v_live_answers, v_advanced_correct
    FROM user_progress up
    LEFT JOIN submissions s ON s.user_id = up.user_id
    LEFT JOIN submission_judgments sj ON sj.submission_id = s.id
    LEFT JOIN item_variants iv ON s.item_variant_id = iv.id
    LEFT JOIN items i ON iv.item_id = i.id
    WHERE up.user_id = p_user_id AND up.sport_id = p_sport_id
    GROUP BY up.lessons_completed, up.concepts_mastered, up.live_answers;

    -- Calculate overall (0-99)
    v_overall :=
        LEAST(99,
            (v_lessons_completed::NUMERIC / v_total_lessons * 25) +
            (v_correct_answers::NUMERIC / v_total_answers * 20) +
            (v_concepts_mastered::NUMERIC / v_total_concepts * 30) +
            (LEAST(v_live_answers, 100)::NUMERIC / 100 * 10) +
            (LEAST(v_advanced_correct, 50)::NUMERIC / 50 * 14)
        );

    -- Update
    UPDATE user_progress
    SET overall_rating = ROUND(v_overall),
        updated_at = now()
    WHERE user_id = p_user_id AND sport_id = p_sport_id;
END;
$$ LANGUAGE plpgsql;
```

### Award Badge
```sql
CREATE OR REPLACE FUNCTION award_badge_if_earned(p_user_id UUID, p_badge_slug TEXT)
RETURNS BOOLEAN AS $$
DECLARE
    v_badge_id UUID;
    v_already_awarded BOOLEAN;
BEGIN
    SELECT id INTO v_badge_id FROM badges WHERE slug = p_badge_slug;
    IF v_badge_id IS NULL THEN
        RETURN FALSE;
    END IF;

    SELECT EXISTS(SELECT 1 FROM user_badges WHERE user_id = p_user_id AND badge_id = v_badge_id)
    INTO v_already_awarded;

    IF NOT v_already_awarded THEN
        INSERT INTO user_badges (user_id, badge_id) VALUES (p_user_id, v_badge_id);
        RETURN TRUE;
    END IF;

    RETURN FALSE;
END;
$$ LANGUAGE plpgsql;
```

---

## Triggers

### Update timestamps
```sql
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to all tables with updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_profiles_updated_at BEFORE UPDATE ON user_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- (Repeat for all tables with updated_at column)
```

---

## Initial Seed Data

See individual table definitions for inline seed data (sports, leagues).

---

## Backup & Maintenance

**Backup Strategy**:
- Daily full backups (pg_dump)
- WAL archiving for point-in-time recovery
- Automated snapshots via cloud provider

**Partition Management**:
- Monthly partitions for analytics_events, provider_events, user_xp_events
- Automated partition creation via cron job
- Drop partitions older than 12 months (archive to cold storage)

**Materialized View Refresh**:
- `mv_user_leaderboard_ranks`: Refresh hourly via cron
- Use `REFRESH MATERIALIZED VIEW CONCURRENTLY` to avoid locks

---

**End of Database Schema**
