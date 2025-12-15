-- ============================================================================
-- Test-Out Complete Function
-- ============================================================================
-- Single atomic function to mark all lessons in a module as complete
-- This bypasses RLS issues and ensures all lessons are updated together
-- ============================================================================

CREATE OR REPLACE FUNCTION complete_module_test_out(
    p_user_id UUID,
    p_module_id UUID
)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER  -- Run with definer's privileges (bypasses RLS)
AS $$
DECLARE
    v_count INTEGER := 0;
BEGIN
    -- Insert or update completion records for ALL lessons in the module
    INSERT INTO user_lesson_completions (user_id, lesson_id, completion_count, last_completed_at, updated_at)
    SELECT
        p_user_id,
        l.id,
        l.required_completions,  -- Set to required to mark as mastered
        now(),
        now()
    FROM lessons l
    WHERE l.module_id = p_module_id
    ON CONFLICT (user_id, lesson_id)
    DO UPDATE SET
        completion_count = EXCLUDED.completion_count,
        last_completed_at = EXCLUDED.last_completed_at,
        updated_at = EXCLUDED.updated_at;

    GET DIAGNOSTICS v_count = ROW_COUNT;

    -- CRITICAL FIX: Explicitly unlock all lessons in the module
    -- The app relies on is_locked = false to allow access
    UPDATE lessons
    SET is_locked = false
    WHERE module_id = p_module_id;

    RETURN v_count;
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION complete_module_test_out(UUID, UUID) TO authenticated;

COMMENT ON FUNCTION complete_module_test_out IS 'Marks all lessons in a module as complete for test-out. Uses SECURITY DEFINER to bypass RLS.';
