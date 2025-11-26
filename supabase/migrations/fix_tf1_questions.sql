-- ============================================================================
-- TF1 Content Fixes and New Questions Migration
-- ============================================================================
-- This migration:
-- 1. Fixes "Goal Lines" capitalization → "goal lines"
-- 2. Removes "American" from "in American football" → "in football"
-- 3. Updates required_completions from 3 to 5
-- 4. Adds 4 new questions to TF1 (Q10-Q13)
-- ============================================================================

-- ============================================================================
-- STEP 1: Fix "Goal Lines" capitalization
-- ============================================================================

UPDATE item_variants
SET prompt_richtext = REPLACE(prompt_richtext, 'Goal Lines', 'goal lines')
WHERE prompt_richtext LIKE '%Goal Lines%';

UPDATE items
SET base_prompt = REPLACE(base_prompt, 'Goal Lines', 'goal lines')
WHERE base_prompt LIKE '%Goal Lines%';

-- ============================================================================
-- STEP 2: Remove "American" from question text
-- ============================================================================

UPDATE item_variants
SET prompt_richtext = REPLACE(prompt_richtext, 'in American football', 'in football')
WHERE prompt_richtext LIKE '%in American football%';

UPDATE items
SET base_prompt = REPLACE(base_prompt, 'in American football', 'in football')
WHERE base_prompt LIKE '%in American football%';

-- Also fix sport description
UPDATE sports
SET description = REPLACE(description, 'American Football', 'Football')
WHERE description LIKE '%American Football%';

-- ============================================================================
-- STEP 3: Update TF1 lesson required_completions from 3 to 5
-- ============================================================================

UPDATE lessons
SET required_completions = 5
WHERE code = 'TF1' OR title = 'The Field 1';

-- ============================================================================
-- STEP 4: Add 4 new questions to TF1 (Q10-Q13)
-- Using dynamic lookup to find the actual TF1 lesson ID and system user
-- ============================================================================

DO $$
DECLARE
    tf1_lesson_id UUID;
    system_user_id UUID;
BEGIN
    -- Find TF1 lesson by code or title
    SELECT id INTO tf1_lesson_id
    FROM lessons
    WHERE code = 'TF1' OR title = 'The Field 1'
    LIMIT 1;

    -- Find system user or any admin user for author_id
    SELECT id INTO system_user_id
    FROM users
    WHERE role = 'admin' OR email LIKE '%system%'
    LIMIT 1;

    -- If no system user found, use the first user
    IF system_user_id IS NULL THEN
        SELECT id INTO system_user_id FROM users LIMIT 1;
    END IF;

    -- Only proceed if we found the TF1 lesson
    IF tf1_lesson_id IS NOT NULL AND system_user_id IS NOT NULL THEN

        -- Q10: Hash marks (Markings)
        INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
        VALUES (
            gen_random_uuid(),
            tf1_lesson_id,
            'mcq',
            'What are the short lines between the yard line numbers called?',
            '{"correct_index": 1}',
            system_user_id,
            'live',
            1
        )
        ON CONFLICT DO NOTHING;

        -- Q11: Goal line color (Goal lines)
        INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
        VALUES (
            gen_random_uuid(),
            tf1_lesson_id,
            'mcq',
            'What color is the goal line typically painted?',
            '{"correct_index": 2}',
            system_user_id,
            'live',
            1
        )
        ON CONFLICT DO NOTHING;

        -- Q12: End zone location (End zones)
        INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
        VALUES (
            gen_random_uuid(),
            tf1_lesson_id,
            'mcq',
            'Where are the end zones located on a football field?',
            '{"correct_index": 2}',
            system_user_id,
            'live',
            1
        )
        ON CONFLICT DO NOTHING;

        -- Q13: Yard numbers direction (Markings)
        INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
        VALUES (
            gen_random_uuid(),
            tf1_lesson_id,
            'binary',
            'From the 50-yard line, yard numbers count down toward each end zone.',
            '{"correct_boolean": true}',
            system_user_id,
            'live',
            1
        )
        ON CONFLICT DO NOTHING;

        RAISE NOTICE 'Successfully added questions to TF1 lesson (ID: %)', tf1_lesson_id;
    ELSE
        RAISE NOTICE 'Could not find TF1 lesson or system user. Lesson ID: %, User ID: %', tf1_lesson_id, system_user_id;
    END IF;
END $$;

-- ============================================================================
-- STEP 5: Add item_variants for the new questions
-- ============================================================================

DO $$
DECLARE
    item_record RECORD;
BEGIN
    -- Add variants for hash marks question
    FOR item_record IN
        SELECT id FROM items WHERE base_prompt = 'What are the short lines between the yard line numbers called?'
    LOOP
        INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
        VALUES (
            gen_random_uuid(),
            item_record.id,
            1,
            'What are the short lines between the yard line numbers called?',
            '["Sidelines", "Hash marks", "Goal markers", "Field stripes"]',
            '{"index": 1}',
            'Hash marks are the short lines that run parallel to the sidelines. They mark where the ball is placed for each play and help players and officials align properly.',
            true
        )
        ON CONFLICT DO NOTHING;
    END LOOP;

    -- Add variants for goal line color question
    FOR item_record IN
        SELECT id FROM items WHERE base_prompt = 'What color is the goal line typically painted?'
    LOOP
        INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
        VALUES (
            gen_random_uuid(),
            item_record.id,
            1,
            'What color is the goal line typically painted?',
            '["Yellow", "Blue", "White", "Red"]',
            '{"index": 2}',
            'The goal line is painted white, like most field markings. It marks the boundary between the playing field and the end zone.',
            true
        )
        ON CONFLICT DO NOTHING;
    END LOOP;

    -- Add variants for end zone location question
    FOR item_record IN
        SELECT id FROM items WHERE base_prompt = 'Where are the end zones located on a football field?'
    LOOP
        INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
        VALUES (
            gen_random_uuid(),
            item_record.id,
            1,
            'Where are the end zones located on a football field?',
            '["In the middle of the field", "On the sidelines", "At each end of the 100-yard field", "Behind the bleachers"]',
            '{"index": 2}',
            'The end zones are the 10-yard areas at each end of the 100-yard playing field. A team scores a touchdown by getting the ball into their opponent''s end zone.',
            true
        )
        ON CONFLICT DO NOTHING;
    END LOOP;

    -- Add variants for yard numbers direction question
    FOR item_record IN
        SELECT id FROM items WHERE base_prompt = 'From the 50-yard line, yard numbers count down toward each end zone.'
    LOOP
        INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
        VALUES (
            gen_random_uuid(),
            item_record.id,
            1,
            'From the 50-yard line, yard numbers count down toward each end zone.',
            '["True", "False"]',
            '{"boolean": true}',
            'Correct! The yard numbers go 50, 40, 30, 20, 10 as you move from midfield toward either end zone. This helps players and fans quickly understand field position.',
            true
        )
        ON CONFLICT DO NOTHING;
    END LOOP;
END $$;

-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    l.title as lesson,
    COUNT(i.id) as item_count,
    l.required_completions
FROM lessons l
LEFT JOIN items i ON i.lesson_id = l.id
WHERE l.code = 'TF1' OR l.title = 'The Field 1'
GROUP BY l.id, l.title, l.required_completions;
