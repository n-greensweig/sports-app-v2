-- ============================================================================
-- Fix Test-Out RLS Policies
-- ============================================================================
-- The original policies compared auth.uid() directly to user_id, but user_id
-- is the internal UUID, not the Supabase Auth UID. This fixes the policies
-- to match the pattern used in user_lesson_completions.
-- ============================================================================

-- Drop existing policies
DROP POLICY IF EXISTS "Users can read own test-out attempts" ON user_test_out_attempts;
DROP POLICY IF EXISTS "Users can insert own test-out attempts" ON user_test_out_attempts;

-- Recreate with correct check (matching the user_lesson_completions pattern)
-- This looks up the clerk_user_id from the users table to compare with auth.uid()
CREATE POLICY "Users can read own test-out attempts"
ON user_test_out_attempts FOR SELECT
USING (auth.uid()::text = (SELECT clerk_user_id FROM users WHERE id = user_id));

CREATE POLICY "Users can insert own test-out attempts"
ON user_test_out_attempts FOR INSERT
WITH CHECK (auth.uid()::text = (SELECT clerk_user_id FROM users WHERE id = user_id));

-- ============================================================================
-- VERIFICATION
-- ============================================================================
SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd
FROM pg_policies
WHERE tablename = 'user_test_out_attempts';
