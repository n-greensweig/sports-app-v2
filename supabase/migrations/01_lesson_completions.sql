-- ============================================================================
-- Ola Ball Database Schema - Lesson Completions Migration
-- ============================================================================
-- Version: 1.1
-- Description: Adds multi-completion lesson tracking for spaced repetition
--
-- Design:
-- - Each lesson has a pool of 8-9 questions
-- - Each completion shows 5 random questions from the pool
-- - User sees familiar + new questions each session for variety
-- - After 3 completions, lesson is mastered and next unlocks
-- ============================================================================

-- Add items_per_session to lessons (how many questions shown per completion)
ALTER TABLE lessons
ADD COLUMN IF NOT EXISTS items_per_session SMALLINT NOT NULL DEFAULT 5 CHECK (items_per_session BETWEEN 3 AND 10);

-- Add required_completions to lessons (how many times to complete before mastery)
ALTER TABLE lessons
ADD COLUMN IF NOT EXISTS required_completions SMALLINT NOT NULL DEFAULT 3 CHECK (required_completions BETWEEN 1 AND 10);

-- Add lesson code (TF1, OT1, etc.) for easy reference
ALTER TABLE lessons
ADD COLUMN IF NOT EXISTS code TEXT;

COMMENT ON COLUMN lessons.items_per_session IS 'Number of questions shown per lesson completion (default 5)';
COMMENT ON COLUMN lessons.required_completions IS 'Number of completions needed to master the lesson (default 3)';
COMMENT ON COLUMN lessons.code IS 'Short code for the lesson (e.g., TF1, OT1, DT1)';

-- Create unique index on lesson code within a module
CREATE UNIQUE INDEX IF NOT EXISTS idx_lessons_code ON lessons(module_id, code) WHERE code IS NOT NULL;


-- ============================================================================
-- User Lesson Completions Table
-- ============================================================================
-- Tracks how many times a user has completed each lesson

CREATE TABLE IF NOT EXISTS user_lesson_completions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
    completion_count INTEGER NOT NULL DEFAULT 0,
    last_completed_at TIMESTAMPTZ,
    -- Track which items user has seen (for variety in future sessions)
    seen_item_ids UUID[] NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT user_lesson_completions_unique UNIQUE (user_id, lesson_id)
);

CREATE INDEX idx_user_lesson_completions_user ON user_lesson_completions(user_id);
CREATE INDEX idx_user_lesson_completions_lesson ON user_lesson_completions(lesson_id);

COMMENT ON TABLE user_lesson_completions IS 'Tracks lesson completion count per user for multi-completion mastery';
COMMENT ON COLUMN user_lesson_completions.completion_count IS 'Number of times user has completed this lesson';
COMMENT ON COLUMN user_lesson_completions.seen_item_ids IS 'Array of item IDs user has seen (for variety tracking)';


-- ============================================================================
-- Function to get next lesson items with variety
-- ============================================================================
-- Returns a mix of seen and unseen items for variety

CREATE OR REPLACE FUNCTION get_lesson_items_with_variety(
    p_user_id UUID,
    p_lesson_id UUID,
    p_items_per_session INTEGER DEFAULT 5
)
RETURNS TABLE (item_id UUID, is_new BOOLEAN)
LANGUAGE plpgsql
AS $$
DECLARE
    v_seen_ids UUID[];
    v_total_items INTEGER;
BEGIN
    -- Get items user has already seen
    SELECT COALESCE(seen_item_ids, '{}') INTO v_seen_ids
    FROM user_lesson_completions
    WHERE user_id = p_user_id AND lesson_id = p_lesson_id;

    -- If no record exists, all items are new
    IF v_seen_ids IS NULL THEN
        v_seen_ids := '{}';
    END IF;

    -- Count total items in lesson
    SELECT COUNT(*) INTO v_total_items
    FROM items i
    JOIN item_variants iv ON iv.item_id = i.id
    WHERE i.lesson_id = p_lesson_id
    AND i.deleted_at IS NULL
    AND iv.status = 'live';

    -- Return mix: prioritize unseen items, fill rest with seen items
    RETURN QUERY
    WITH unseen AS (
        SELECT i.id, true as is_new
        FROM items i
        JOIN item_variants iv ON iv.item_id = i.id
        WHERE i.lesson_id = p_lesson_id
        AND i.deleted_at IS NULL
        AND iv.status = 'live'
        AND NOT (i.id = ANY(v_seen_ids))
        ORDER BY RANDOM()
        LIMIT p_items_per_session
    ),
    seen AS (
        SELECT i.id, false as is_new
        FROM items i
        JOIN item_variants iv ON iv.item_id = i.id
        WHERE i.lesson_id = p_lesson_id
        AND i.deleted_at IS NULL
        AND iv.status = 'live'
        AND i.id = ANY(v_seen_ids)
        ORDER BY RANDOM()
        LIMIT GREATEST(0, p_items_per_session - (SELECT COUNT(*) FROM unseen))
    )
    SELECT * FROM unseen
    UNION ALL
    SELECT * FROM seen
    LIMIT p_items_per_session;
END;
$$;

COMMENT ON FUNCTION get_lesson_items_with_variety IS 'Returns lesson items with mix of new and seen items for variety';


-- ============================================================================
-- Function to record lesson completion
-- ============================================================================

CREATE OR REPLACE FUNCTION record_lesson_completion(
    p_user_id UUID,
    p_lesson_id UUID,
    p_item_ids UUID[]
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_new_count INTEGER;
    v_existing_seen UUID[];
BEGIN
    -- Get existing seen items
    SELECT COALESCE(seen_item_ids, '{}') INTO v_existing_seen
    FROM user_lesson_completions
    WHERE user_id = p_user_id AND lesson_id = p_lesson_id;

    -- Upsert completion record
    INSERT INTO user_lesson_completions (user_id, lesson_id, completion_count, seen_item_ids, last_completed_at, updated_at)
    VALUES (
        p_user_id,
        p_lesson_id,
        1,
        p_item_ids,
        now(),
        now()
    )
    ON CONFLICT (user_id, lesson_id) DO UPDATE SET
        completion_count = user_lesson_completions.completion_count + 1,
        seen_item_ids = ARRAY(
            SELECT DISTINCT unnest(user_lesson_completions.seen_item_ids || p_item_ids)
        ),
        last_completed_at = now(),
        updated_at = now()
    RETURNING completion_count INTO v_new_count;

    RETURN v_new_count;
END;
$$;

COMMENT ON FUNCTION record_lesson_completion IS 'Records a lesson completion and updates seen items';


-- ============================================================================
-- RLS Policies for user_lesson_completions
-- ============================================================================

ALTER TABLE user_lesson_completions ENABLE ROW LEVEL SECURITY;

-- Users can only see their own completions
CREATE POLICY user_lesson_completions_select ON user_lesson_completions
    FOR SELECT USING (auth.uid()::text = (SELECT clerk_user_id FROM users WHERE id = user_id));

-- Users can only insert their own completions
CREATE POLICY user_lesson_completions_insert ON user_lesson_completions
    FOR INSERT WITH CHECK (auth.uid()::text = (SELECT clerk_user_id FROM users WHERE id = user_id));

-- Users can only update their own completions
CREATE POLICY user_lesson_completions_update ON user_lesson_completions
    FOR UPDATE USING (auth.uid()::text = (SELECT clerk_user_id FROM users WHERE id = user_id));
