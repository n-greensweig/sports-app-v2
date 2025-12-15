-- ============================================================================
-- Rookie Module Test-Out Items - Seed Data
-- ============================================================================
-- Links 25 questions from Rookie lessons to enable test-out functionality
-- Users need 20/25 correct to pass and unlock Veteran module
--
-- This seed dynamically selects items from existing Rookie lessons
-- ============================================================================

-- Ensure Rookie test-out config exists
INSERT INTO module_test_outs (id, module_id, passing_score, total_questions, is_active)
VALUES (
    '10000001-0000-0000-0000-000000000001',
    '11111111-1111-1111-1111-111111111111',
    20,
    25,
    true
)
ON CONFLICT (module_id) DO UPDATE SET
    passing_score = EXCLUDED.passing_score,
    total_questions = EXCLUDED.total_questions,
    is_active = EXCLUDED.is_active;

-- Clear any existing test-out items for Rookie module
DELETE FROM test_out_items WHERE module_id = '11111111-1111-1111-1111-111111111111';

-- Dynamically insert 25 items from Rookie lessons
-- This selects items from lessons that belong to the Rookie module
INSERT INTO test_out_items (module_id, item_id, order_index)
SELECT
    '11111111-1111-1111-1111-111111111111' as module_id,
    i.id as item_id,
    ROW_NUMBER() OVER (ORDER BY RANDOM()) as order_index
FROM items i
JOIN lessons l ON i.lesson_id = l.id
WHERE l.module_id = '11111111-1111-1111-1111-111111111111'
  AND i.status = 'live'
ORDER BY RANDOM()
LIMIT 25;

-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT 'Rookie Test-Out Config' as entity, COUNT(*) as count
FROM module_test_outs
WHERE module_id = '11111111-1111-1111-1111-111111111111';

SELECT 'Rookie Test-Out Items' as entity, COUNT(*) as count
FROM test_out_items
WHERE module_id = '11111111-1111-1111-1111-111111111111';

-- Show which lessons the test-out items come from
SELECT l.code, l.title, COUNT(toi.item_id) as items_selected
FROM test_out_items toi
JOIN items i ON toi.item_id = i.id
JOIN lessons l ON i.lesson_id = l.id
WHERE toi.module_id = '11111111-1111-1111-1111-111111111111'
GROUP BY l.code, l.title
ORDER BY l.code;
