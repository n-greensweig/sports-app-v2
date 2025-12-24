-- ============================================================================
-- LESSON AUDIT SCRIPT
-- ============================================================================
-- This script checks for common issues with lesson data:
-- 1. Lessons with no items (will show blank screen)
-- 2. Duplicate lessons (same title/code)
-- 3. Items without active variants (won't display properly)
-- 4. Orphaned items (items pointing to non-existent lessons)
-- 5. Lessons with fewer items than items_per_session
-- ============================================================================

-- ============================================================================
-- 1. LESSONS WITH NO ITEMS (CRITICAL - causes blank screen)
-- ============================================================================
SELECT
    '❌ NO ITEMS' as issue,
    l.id as lesson_id,
    l.title,
    l.code,
    l.order_index,
    m.title as module_name,
    0 as item_count,
    l.items_per_session as required_items
FROM lessons l
JOIN modules m ON m.id = l.module_id
LEFT JOIN items i ON i.lesson_id = l.id
WHERE i.id IS NULL
ORDER BY m.order_index, l.order_index;

-- ============================================================================
-- 2. LESSONS WITH ITEMS BUT COUNT < items_per_session (WARNING)
-- ============================================================================
SELECT
    '⚠️ LOW ITEM COUNT' as issue,
    l.id as lesson_id,
    l.title,
    l.code,
    l.order_index,
    m.title as module_name,
    COUNT(i.id) as item_count,
    l.items_per_session as required_items
FROM lessons l
JOIN modules m ON m.id = l.module_id
LEFT JOIN items i ON i.lesson_id = l.id
GROUP BY l.id, l.title, l.code, l.order_index, m.title, m.order_index, l.items_per_session
HAVING COUNT(i.id) > 0 AND COUNT(i.id) < l.items_per_session
ORDER BY m.order_index, l.order_index;

-- ============================================================================
-- 3. DUPLICATE LESSONS (same title or code within same module)
-- ============================================================================
SELECT
    '🔄 DUPLICATE' as issue,
    l.id as lesson_id,
    l.title,
    l.code,
    l.order_index,
    m.title as module_name,
    COUNT(i.id) as item_count
FROM lessons l
JOIN modules m ON m.id = l.module_id
LEFT JOIN items i ON i.lesson_id = l.id
WHERE l.title IN (
    SELECT title FROM lessons GROUP BY title, module_id HAVING COUNT(*) > 1
)
OR (l.code IS NOT NULL AND l.code IN (
    SELECT code FROM lessons WHERE code IS NOT NULL GROUP BY code, module_id HAVING COUNT(*) > 1
))
GROUP BY l.id, l.title, l.code, l.order_index, m.title, m.order_index
ORDER BY l.title, l.order_index;

-- ============================================================================
-- 4. ITEMS WITHOUT ACTIVE VARIANTS (won't display properly)
-- ============================================================================
SELECT
    '📝 NO ACTIVE VARIANT' as issue,
    i.id as item_id,
    i.base_prompt,
    l.title as lesson_title,
    l.code as lesson_code
FROM items i
JOIN lessons l ON l.id = i.lesson_id
LEFT JOIN item_variants iv ON iv.item_id = i.id AND iv.active = true
WHERE iv.id IS NULL
ORDER BY l.code, i.id;

-- ============================================================================
-- 5. ORPHANED ITEMS (pointing to non-existent lessons)
-- ============================================================================
SELECT
    '👻 ORPHANED ITEM' as issue,
    i.id as item_id,
    i.lesson_id,
    i.base_prompt
FROM items i
LEFT JOIN lessons l ON l.id = i.lesson_id
WHERE l.id IS NULL;

-- ============================================================================
-- 6. SUMMARY: ALL LESSONS WITH ITEM COUNTS
-- ============================================================================
SELECT
    CASE
        WHEN COUNT(i.id) = 0 THEN '❌'
        WHEN COUNT(i.id) < l.items_per_session THEN '⚠️'
        ELSE '✅'
    END as status,
    l.code,
    l.title,
    l.order_index,
    m.title as module_name,
    COUNT(i.id) as item_count,
    l.items_per_session as items_per_session,
    l.required_completions,
    l.is_locked
FROM lessons l
JOIN modules m ON m.id = l.module_id
LEFT JOIN items i ON i.lesson_id = l.id
GROUP BY l.id, l.code, l.title, l.order_index, m.title, m.order_index, l.items_per_session, l.required_completions, l.is_locked
ORDER BY m.order_index, l.order_index;

-- ============================================================================
-- 7. VARIANT CHECK: Items with variants but none active
-- ============================================================================
SELECT
    '🔕 INACTIVE VARIANTS ONLY' as issue,
    i.id as item_id,
    i.base_prompt,
    l.title as lesson_title,
    l.code as lesson_code,
    COUNT(iv.id) as total_variants,
    SUM(CASE WHEN iv.active THEN 1 ELSE 0 END) as active_variants
FROM items i
JOIN lessons l ON l.id = i.lesson_id
JOIN item_variants iv ON iv.item_id = i.id
GROUP BY i.id, i.base_prompt, l.title, l.code

HAVING SUM(CASE WHEN iv.active THEN 1 ELSE 0 END) = 0
ORDER BY l.code;
