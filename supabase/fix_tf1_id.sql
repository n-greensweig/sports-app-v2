-- ============================================================================
-- Fix TF1 Lesson ID
-- ============================================================================
-- This script updates TF1's ID from 33333333-3333-3333-3333-333333330001
-- to the correct ID 00000001-0000-0000-0000-000000000001
-- and moves it to the correct Rookie module (11111111-1111-1111-1111-111111111111)
-- ============================================================================

-- Step 1: Insert the new TF1 lesson FIRST (so foreign keys can reference it)
INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000001',
    '11111111-1111-1111-1111-111111111111',
    'The Field 1',
    'Learn about field dimensions, yard lines, goal lines, and end zones',
    1,
    4,
    50,
    false,
    'TF1',
    5,
    5
)
ON CONFLICT (id) DO UPDATE SET
    module_id = EXCLUDED.module_id,
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    code = EXCLUDED.code;

-- Step 2: Update any user_lesson_completions to point to the new lesson ID
UPDATE user_lesson_completions
SET lesson_id = '00000001-0000-0000-0000-000000000001'
WHERE lesson_id = '33333333-3333-3333-3333-333333330001';

-- Step 3: Update any items that reference the old lesson ID
UPDATE items
SET lesson_id = '00000001-0000-0000-0000-000000000001'
WHERE lesson_id = '33333333-3333-3333-3333-333333330001';

-- Step 4: Update user_progress to point to the new lesson ID
UPDATE user_progress
SET current_lesson_id = '00000001-0000-0000-0000-000000000001'
WHERE current_lesson_id = '33333333-3333-3333-3333-333333330001';

-- Step 5: Delete the old lesson
DELETE FROM lessons WHERE id = '33333333-3333-3333-3333-333333330001';

-- Step 6: Unlock TF2 since user has completed TF1 many times
UPDATE lessons
SET is_locked = false
WHERE id = '00000001-0000-0000-0000-000000000002';

-- Step 7: Verify the fix
SELECT 'Lessons in Rookie module:' as info;
SELECT id, title, order_index, is_locked, module_id
FROM lessons
WHERE module_id = '11111111-1111-1111-1111-111111111111'
ORDER BY order_index;
