-- ============================================================================
-- Migration: Remove unused sports (keep only Football and Baseball)
-- ============================================================================
-- This migration removes all sports except Football and Baseball from the database.
-- It cascades deletes through the related tables.
-- ============================================================================

-- First, let's see what sports exist and their IDs
-- SELECT id, slug, name FROM sports;

-- Delete in order to respect foreign key constraints:
-- 1. Delete user progress for non-Football/Baseball sports
DELETE FROM user_progress
WHERE sport_id NOT IN (
    SELECT id FROM sports WHERE slug IN ('football', 'baseball')
);

-- 2. Delete streaks for non-Football/Baseball sports
DELETE FROM streaks
WHERE sport_id NOT IN (
    SELECT id FROM sports WHERE slug IN ('football', 'baseball')
);

-- 3. Delete XP events for non-Football/Baseball sports
DELETE FROM user_xp_events
WHERE sport_id NOT IN (
    SELECT id FROM sports WHERE slug IN ('football', 'baseball')
);

-- 4. Delete SRS cards for non-Football/Baseball sports
DELETE FROM srs_cards
WHERE sport_id NOT IN (
    SELECT id FROM sports WHERE slug IN ('football', 'baseball')
);

-- 5. Delete leaderboards for non-Football/Baseball sports
DELETE FROM leaderboards
WHERE sport_id NOT IN (
    SELECT id FROM sports WHERE slug IN ('football', 'baseball')
);

-- 6. Delete badges for non-Football/Baseball sports
DELETE FROM badges
WHERE sport_id NOT IN (
    SELECT id FROM sports WHERE slug IN ('football', 'baseball')
);

-- 7. Delete concepts for non-Football/Baseball sports
DELETE FROM concepts
WHERE sport_id NOT IN (
    SELECT id FROM sports WHERE slug IN ('football', 'baseball')
);

-- 8. Delete live prompts for non-Football/Baseball sports
DELETE FROM live_prompts
WHERE sport_id NOT IN (
    SELECT id FROM sports WHERE slug IN ('football', 'baseball')
);

-- 9. Delete leagues for non-Football/Baseball sports
DELETE FROM leagues
WHERE sport_id NOT IN (
    SELECT id FROM sports WHERE slug IN ('football', 'baseball')
);

-- 10. Delete sessions for non-Football/Baseball sports
DELETE FROM sessions
WHERE sport_id NOT IN (
    SELECT id FROM sports WHERE slug IN ('football', 'baseball')
);

-- 11. For modules, we need to handle the cascade through lessons → items
-- First delete item-related data, then lessons, then modules

-- Delete user lesson completions for lessons in non-Football/Baseball modules
DELETE FROM user_lesson_completions
WHERE lesson_id IN (
    SELECT l.id FROM lessons l
    JOIN modules m ON l.module_id = m.id
    WHERE m.sport_id NOT IN (
        SELECT id FROM sports WHERE slug IN ('football', 'baseball')
    )
);

-- Delete item variants for items in non-Football/Baseball modules
DELETE FROM item_variants
WHERE item_id IN (
    SELECT i.id FROM items i
    JOIN lessons l ON i.lesson_id = l.id
    JOIN modules m ON l.module_id = m.id
    WHERE m.sport_id NOT IN (
        SELECT id FROM sports WHERE slug IN ('football', 'baseball')
    )
);

-- Delete user item stats for items in non-Football/Baseball modules
DELETE FROM user_item_stats
WHERE item_id IN (
    SELECT i.id FROM items i
    JOIN lessons l ON i.lesson_id = l.id
    JOIN modules m ON l.module_id = m.id
    WHERE m.sport_id NOT IN (
        SELECT id FROM sports WHERE slug IN ('football', 'baseball')
    )
);

-- Delete items for lessons in non-Football/Baseball modules
DELETE FROM items
WHERE lesson_id IN (
    SELECT l.id FROM lessons l
    JOIN modules m ON l.module_id = m.id
    WHERE m.sport_id NOT IN (
        SELECT id FROM sports WHERE slug IN ('football', 'baseball')
    )
);

-- Delete lessons for non-Football/Baseball modules
DELETE FROM lessons
WHERE module_id IN (
    SELECT id FROM modules
    WHERE sport_id NOT IN (
        SELECT id FROM sports WHERE slug IN ('football', 'baseball')
    )
);

-- Delete modules for non-Football/Baseball sports
DELETE FROM modules
WHERE sport_id NOT IN (
    SELECT id FROM sports WHERE slug IN ('football', 'baseball')
);

-- 12. Finally, delete the sports themselves
DELETE FROM sports
WHERE slug NOT IN ('football', 'baseball');

-- Verify remaining sports
-- SELECT id, slug, name FROM sports;
