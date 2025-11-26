-- ============================================================================
-- Cleanup Old Modules
-- ============================================================================
-- This script removes old modules that we're replacing with the new
-- CLAUDE.md lesson structure (TF1, OT1, etc.)
--
-- Keeps: Rookie module
-- Deletes: Offensive Concepts, Defensive Concepts, Football Lingo & Terminology
-- ============================================================================

-- First, let's see what modules exist
SELECT id, title, order_index FROM modules WHERE deleted_at IS NULL ORDER BY order_index;

-- Delete modules by title (keeping Rookie)
-- The CASCADE on foreign keys will automatically delete related lessons and items

DELETE FROM modules
WHERE title IN (
    'Offensive Concepts',
    'Defensive Concepts',
    'Football Lingo & Terminology',
    'Football Basics'  -- Also delete if this old one exists
)
AND title != 'Rookie';

-- Verify what remains
SELECT id, title, order_index FROM modules WHERE deleted_at IS NULL ORDER BY order_index;

-- Also clean up any orphaned lessons (lessons without a valid module)
-- This shouldn't happen due to CASCADE, but just in case
DELETE FROM lessons
WHERE module_id NOT IN (SELECT id FROM modules WHERE deleted_at IS NULL);

-- Show final state
SELECT
    m.title as module_title,
    COUNT(l.id) as lesson_count
FROM modules m
LEFT JOIN lessons l ON l.module_id = m.id AND l.deleted_at IS NULL
WHERE m.deleted_at IS NULL
GROUP BY m.id, m.title
ORDER BY m.order_index;
