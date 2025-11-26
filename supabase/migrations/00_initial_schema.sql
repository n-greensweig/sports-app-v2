-- ============================================================================
-- Ola Ball Database Schema Reference
-- ============================================================================
-- WARNING: This file is for REFERENCE ONLY - do not run directly.
-- The actual schema is managed by Supabase migrations.
-- Last synced: 2025-11-26
-- ============================================================================

-- ============================================================================
-- ENUMS (Custom Types)
-- ============================================================================
-- friend_status: 'requested', 'accepted', 'blocked'
-- device_platform: 'ios', 'android', 'web'
-- item_type: 'mcq', 'multi_select', 'slider', 'free_text', 'clip_label', 'binary'
-- item_status: 'draft', 'review', 'live', 'retired'
-- submission_context: 'lesson', 'live', 'review'
-- judgment_type: 'rules', 'ground_truth', 'ml', 'human', 'provider'
-- xp_source: 'lesson', 'live', 'review', 'streak', 'bonus', 'achievement'
-- leaderboard_window: 'daily', 'weekly', 'alltime'
-- game_status: 'scheduled', 'in_progress', 'halftime', 'final', 'postponed', 'cancelled'
-- season_phase: 'preseason', 'regular', 'postseason'
-- session_mode: 'lesson', 'live', 'review', 'browse'
-- mapping_compatibility: 'exact', 'close', 'fallback'
-- prompt_window_status: 'scheduled', 'sent', 'answered', 'expired', 'skipped'
-- feature_source: 'provider', 'derived', 'ml', 'manual'
-- asset_type: 'image', 'audio', 'video'


-- ============================================================================
-- CORE TABLES: Identity & Users
-- ============================================================================

-- users: Core user identity (linked to Supabase Auth)
-- Fields: id, clerk_user_id, email, role, status, created_at, updated_at, deleted_at

-- user_profiles: Extended profile info
-- Fields: user_id (PK), display_name, username, avatar_url, bio, country, timezone,
--         birth_year, favorite_team_id, notification_preferences, privacy_settings

-- friends: Friend relationships
-- Fields: id, user_id, friend_user_id, status, requested_at, accepted_at

-- devices: Push notification tokens
-- Fields: id, user_id, platform, device_identifier, push_token, app_version, os_version


-- ============================================================================
-- CORE TABLES: Learning Content
-- ============================================================================

-- sports: Top-level categories (Football, Basketball, etc.)
-- Fields: id, slug, name, icon_url, accent_color, description, order_index, is_active

-- modules: Sections within a sport (Rookie, Veteran, All-Pro, etc.)
-- Fields: id, sport_id, title, description, order_index, min_level, max_level,
--         icon_name, xp_reward, release_id, deleted_at

-- lessons: Individual lessons within modules
-- Fields: id, module_id, title, description, order_index, est_minutes, xp_award,
--         prerequisite_lesson_id, is_locked, deleted_at,
--         items_per_session (default 5), required_completions (default 3), code (e.g., "TF1")

-- items: Questions/exercises (can be lesson-specific or global for live mode)
-- Fields: id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty

-- item_variants: Versioned item content for A/B testing
-- Fields: id, item_id, version, prompt_richtext, options_json, correct_answer_json,
--         explanation_richtext, media_ref, active, ab_test_id

-- item_assets: Media assets for items
-- Fields: id, variant_id, type, uri, alt_text, duration_ms, width, height, file_size_bytes

-- concepts: Learning concepts for tagging
-- Fields: id, sport_id, slug, name, description_md, difficulty, parent_concept_id

-- concept_tags: Flexible tagging for concepts
-- Fields: concept_id, tag

-- lesson_concepts: Maps lessons to concepts
-- Fields: lesson_id, concept_id, weight


-- ============================================================================
-- CORE TABLES: User Progress & Gamification
-- ============================================================================

-- user_progress: Per-sport progression tracking
-- Fields: id, user_id, sport_id, level, overall_rating, current_module_id,
--         current_lesson_id, total_xp, lessons_completed, live_answers, concepts_mastered

-- user_lesson_completions: Tracks multi-completion progress per lesson
-- Fields: id, user_id, lesson_id, completion_count, last_completed_at, seen_item_ids[]

-- user_item_stats: Per-item performance stats
-- Fields: id, user_id, item_id, seen_count, correct_count, streak_correct, easiness_factor

-- user_xp_events: Immutable XP event log (partitioned by month)
-- Fields: id, user_id, sport_id, source, amount, meta_json, occurred_at

-- streaks: Daily learning streaks
-- Fields: id, user_id, sport_id, current_days, longest_days, last_checkin_date

-- badges: Achievement definitions
-- Fields: id, slug, name, description, criteria_json, sport_id, icon_asset, is_active

-- user_badges: Badges awarded to users
-- Fields: id, user_id, badge_id, awarded_at

-- leaderboards: Materialized rankings
-- Fields: id, sport_id, time_window, window_start, window_end, rank, user_id, xp


-- ============================================================================
-- CORE TABLES: Submissions & Grading
-- ============================================================================

-- submissions: User responses (partitioned by month)
-- Fields: id, user_id, context, item_variant_id, live_prompt_id, session_id,
--         response_json, submitted_at, latency_ms, device_platform

-- submission_judgments: Grading results
-- Fields: id, submission_id, is_correct, score, judged_by, explanation, confidence


-- ============================================================================
-- CORE TABLES: Spaced Repetition (SRS)
-- ============================================================================

-- srs_cards: SM-2 algorithm cards
-- Fields: id, user_id, item_id, variant_id, sport_id, due_at, interval_days,
--         ease_factor, repetitions, lapses, last_reviewed_at

-- srs_reviews: History of SRS review sessions
-- Fields: id, card_id, submission_id, reviewed_at, grade, new_interval_days,
--         new_ease_factor, new_due_at


-- ============================================================================
-- CORE TABLES: Live Game Mode
-- ============================================================================

-- leagues: Sports leagues (NFL, NCAA, NBA, etc.)
-- Fields: id, sport_id, slug, name, country, provider_league_key

-- teams: Teams within leagues
-- Fields: id, league_id, provider_team_key, name, abbreviation, city, logo_url

-- seasons: League seasons
-- Fields: id, league_id, year, phase, start_date, end_date

-- games: Individual games
-- Fields: id, league_id, season_id, provider_game_id, home_team_id, away_team_id,
--         start_time, venue, status, final_home_score, final_away_score

-- drives: Offensive drives (football)
-- Fields: id, game_id, sequence, team_id, start_yardline, end_yardline, result

-- plays: Individual plays
-- Fields: id, game_id, drive_id, sequence, clock, down, distance, yard_line, play_text

-- play_features: Extracted features from plays
-- Fields: id, play_id, features_json, confidence_json, source

-- live_prompts: Template prompts for live mode
-- Fields: id, sport_id, level_min, level_max, template_prompt, answer_schema_json,
--         grading_rule_json, cooldown_seconds, priority, is_active

-- live_prompt_mappings: Maps prompts to play features
-- Fields: id, live_prompt_id, feature_key, extractor_expr, compatibility, min_confidence

-- live_prompt_windows: Scheduled prompts per user per game
-- Fields: id, game_id, play_id, live_prompt_id, user_id, expires_at, status


-- ============================================================================
-- CORE TABLES: Analytics & System
-- ============================================================================

-- sessions: User sessions
-- Fields: id, user_id, mode, sport_id, game_id, started_at, ended_at

-- analytics_events: Event log (partitioned by month)
-- Fields: id, user_id, session_id, event_type, properties_json, occurred_at

-- feature_flags: Feature toggles
-- Fields: key, enabled, rules_json, description

-- ab_tests: A/B test configurations
-- Fields: id, name, description, segment_json, started_at, ended_at

-- content_releases: Version tracking for rollbacks
-- Fields: id, name, notes, rolled_out_at

-- provider_events: Raw webhooks from sports data providers (partitioned)
-- Fields: id, provider, event_type, raw_json, game_id, received_at, processed_at

-- provider_mappings: Links provider events to normalized plays
-- Fields: id, provider_event_id, play_id, mapping_notes


-- ============================================================================
-- KEY RELATIONSHIPS (Simplified)
-- ============================================================================
--
-- LEARNING HIERARCHY:
--   sports (1) → modules (N) → lessons (N) → items (N) → item_variants (N)
--
-- USER PROGRESS:
--   users (1) → user_progress (N per sport)
--              → user_lesson_completions (N per lesson)
--              → user_item_stats (N per item)
--              → submissions (N)
--              → srs_cards (N)
--
-- LIVE MODE:
--   sports → leagues → teams
--                   → seasons → games → drives → plays → play_features
--   games → live_prompt_windows → live_prompts
--
-- ============================================================================
