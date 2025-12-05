-- ============================================================================
-- Migration: Reorder Rookie Lessons with Quizzes Interspersed
-- ============================================================================
-- This migration updates the order_index values for lessons, quizzes, and tests
-- to properly space quizzes throughout the Rookie learning path.
--
-- NEW ORDER:
-- 1-10:  GB1, TF1, TF2, SC1, DS1, DS2, PT1, SC2, TF3, PT2 (unchanged)
-- 11:    QZ1 (Foundations Quiz) - tests GB1-PT2
-- 12-15: OP1, OP2, DP1, DP2
-- 16:    QZ2 (Positions Quiz) - tests OP1-DP2
-- 17-20: TO1, TO2, CP1, CP2
-- 21:    QZ3 (Turnovers & Penalties Quiz) - tests TO1-CP2
-- 22-25: GS1, GS2, ST1, ST2
-- 26:    QZ4 (Game Structure Quiz) - tests GS1-ST2
-- 27:    TEST1 (Rookie Final Test)
-- ============================================================================

-- Update lessons (shifting positions to make room for quizzes)
-- OP1: 11 -> 12
UPDATE lessons SET order_index = 12 WHERE id = '00000001-0000-0000-0000-000000000011';

-- OP2: 12 -> 13
UPDATE lessons SET order_index = 13 WHERE id = '00000001-0000-0000-0000-000000000012';

-- DP1: 13 -> 14
UPDATE lessons SET order_index = 14 WHERE id = '00000001-0000-0000-0000-000000000013';

-- DP2: 14 -> 15
UPDATE lessons SET order_index = 15 WHERE id = '00000001-0000-0000-0000-000000000014';

-- TO1: 15 -> 17
UPDATE lessons SET order_index = 17 WHERE id = '00000001-0000-0000-0000-000000000015';

-- TO2: 16 -> 18
UPDATE lessons SET order_index = 18 WHERE id = '00000001-0000-0000-0000-000000000016';

-- CP1: 17 -> 19
UPDATE lessons SET order_index = 19 WHERE id = '00000001-0000-0000-0000-000000000017';

-- CP2: 18 -> 20
UPDATE lessons SET order_index = 20 WHERE id = '00000001-0000-0000-0000-000000000018';

-- GS1: 19 -> 22
UPDATE lessons SET order_index = 22 WHERE id = '00000001-0000-0000-0000-000000000019';

-- GS2: 20 -> 23
UPDATE lessons SET order_index = 23 WHERE id = '00000001-0000-0000-0000-000000000020';

-- ST1: 21 -> 24
UPDATE lessons SET order_index = 24 WHERE id = '00000001-0000-0000-0000-000000000021';

-- ST2: 22 -> 25
UPDATE lessons SET order_index = 25 WHERE id = '00000001-0000-0000-0000-000000000022';

-- Update quizzes to proper positions
-- QZ1 (Foundations): 23 -> 11
UPDATE lessons SET order_index = 11 WHERE id = '00000001-0000-0000-0000-000000000023';

-- QZ2 (Positions): 24 -> 16
UPDATE lessons SET order_index = 16 WHERE id = '00000001-0000-0000-0000-000000000024';

-- QZ3 (Turnovers & Penalties): 25 -> 21
UPDATE lessons SET order_index = 21 WHERE id = '00000001-0000-0000-0000-000000000025';

-- QZ4 (Game Structure): 26 -> 26 (unchanged)
-- TEST1: 27 -> 27 (unchanged)

-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    code,
    title,
    order_index
FROM lessons
WHERE module_id = '11111111-1111-1111-1111-111111111111'
ORDER BY order_index;
