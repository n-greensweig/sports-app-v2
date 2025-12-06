-- ============================================================================
-- AB1 (At Bats 1) - Baseball Seed Data
-- ============================================================================
-- AB1 is the FIFTH lesson (after SC1)
-- AB1 covers: Strikes, balls, strikeouts, walks, the count
--
-- Prerequisites: GB1, TF1, TF2, SC1 (batting, pitcher's mound, batter's box)
-- Terms INTRODUCED here: strike, ball, count, strikeout, walk, full count
--
-- Structure:
-- - AB1 Lesson (9 questions, 5 shown per session, 5 completions to master)
-- ============================================================================

-- ============================================================================
-- STEP 1: Ensure Baseball sport exists
-- ============================================================================

INSERT INTO sports (id, slug, name, accent_color, description, order_index, is_active)
VALUES (
    '02ba5eba-1100-0000-0000-000000000000',
    'baseball',
    'Baseball',
    '#C41E3A',
    'Baseball - MLB and College',
    2,
    true
)
ON CONFLICT (slug) DO UPDATE SET
    name = EXCLUDED.name,
    accent_color = EXCLUDED.accent_color,
    description = EXCLUDED.description;


-- ============================================================================
-- STEP 2: Create Rookie Module (Section)
-- ============================================================================

INSERT INTO modules (id, sport_id, title, description, order_index, min_level, max_level, xp_reward)
VALUES (
    '22222222-2222-2222-2222-222222222222',
    '02ba5eba-1100-0000-0000-000000000000',
    'Rookie',
    'Start your baseball journey! Learn the basics of the diamond, scoring, and key terms.',
    1,
    1,
    2,
    500
)
ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description;


-- ============================================================================
-- STEP 3: Create System User for content authoring (if not exists)
-- ============================================================================

INSERT INTO users (id, clerk_user_id, email, role)
VALUES (
    '00000000-0000-0000-0000-000000000000',
    'system',
    'system@olaball.app',
    'admin'
)
ON CONFLICT (clerk_user_id) DO NOTHING;


-- ============================================================================
-- STEP 4: Create AB1 Lesson (ORDER: 5)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-000000000005',
    '22222222-2222-2222-2222-222222222222',
    'At Bats 1',
    'Learn about strikes, balls, and what happens during an at bat.',
    5,
    4,
    50,
    true,
    'AB1',
    5,
    5
)
ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    code = EXCLUDED.code,
    order_index = EXCLUDED.order_index,
    items_per_session = EXCLUDED.items_per_session,
    required_completions = EXCLUDED.required_completions;


-- ============================================================================
-- STEP 5: Create AB1 Items (9 questions)
-- ============================================================================

-- Q1: What is a strike?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000025-0001-0000-0000-000000000001',
    '00000002-0000-0000-0000-000000000005',
    'mcq',
    'What is a "strike" in baseball?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000025-0001-0001-0000-000000000001',
    '00000025-0001-0000-0000-000000000001',
    1,
    'What is a "strike" in baseball?',
    '["When a batter hits the ball", "A pitch in the strike zone that the batter doesn''t hit, or any pitch the batter swings at and misses", "When a runner is safe at a base", "When the pitcher drops the ball"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: What is a ball?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000025-0001-0000-0000-000000000002',
    '00000002-0000-0000-0000-000000000005',
    'mcq',
    'What is a "ball" (as in balls and strikes)?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000025-0001-0001-0000-000000000002',
    '00000025-0001-0000-0000-000000000002',
    1,
    'What is a "ball" (as in balls and strikes)?',
    '["A pitch that is outside the strike zone and the batter doesn''t swing at", "Any pitch that the batter hits", "A pitch that the catcher drops", "The baseball itself"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: How many strikes for a strikeout?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000025-0001-0000-0000-000000000003',
    '00000002-0000-0000-0000-000000000005',
    'mcq',
    'How many strikes does it take to strike out a batter?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000025-0001-0001-0000-000000000003',
    '00000025-0001-0000-0000-000000000003',
    1,
    'How many strikes does it take to strike out a batter?',
    '["1 strike", "2 strikes", "3 strikes", "4 strikes"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: How many balls for a walk?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000025-0001-0000-0000-000000000004',
    '00000002-0000-0000-0000-000000000005',
    'mcq',
    'If a pitcher throws too many balls, the batter gets to walk to first base. How many balls equal a "walk"?',
    '{"correct_index": 3}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000025-0001-0001-0000-000000000004',
    '00000025-0001-0000-0000-000000000004',
    1,
    'If a pitcher throws too many balls, the batter gets to walk to first base. How many balls equal a "walk"?',
    '["2 balls", "3 balls", "5 balls", "4 balls"]',
    '{"index": 3}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: What is the count?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000025-0001-0000-0000-000000000005',
    '00000002-0000-0000-0000-000000000005',
    'mcq',
    'The "count" tells you how many balls and strikes there are. If the count is "2-1," what does that mean?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000025-0001-0001-0000-000000000005',
    '00000025-0001-0000-0000-000000000005',
    1,
    'The "count" tells you how many balls and strikes there are. If the count is "2-1," what does that mean?',
    '["2 balls, 1 strike", "2 strikes, 1 ball", "2 outs, 1 run", "2 innings, 1 out"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Full count
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000025-0001-0000-0000-000000000006',
    '00000002-0000-0000-0000-000000000005',
    'mcq',
    'A "full count" is when the batter has the maximum balls and strikes without being out or walking. What is a full count?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000025-0001-0001-0000-000000000006',
    '00000025-0001-0000-0000-000000000006',
    1,
    'A "full count" is when the batter has the maximum balls and strikes without being out or walking. What is a full count?',
    '["2 balls, 2 strikes", "4 balls, 3 strikes", "3 balls, 2 strikes", "2 balls, 3 strikes"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Strikeout is an out - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000025-0001-0000-0000-000000000007',
    '00000002-0000-0000-0000-000000000005',
    'binary',
    'When a batter strikes out, it counts as one of the team''s three outs.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000025-0001-0001-0000-000000000007',
    '00000025-0001-0000-0000-000000000007',
    1,
    'When a batter strikes out, it counts as one of the team''s three outs.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Strike zone location
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000025-0001-0000-0000-000000000008',
    '00000002-0000-0000-0000-000000000005',
    'mcq',
    'The "strike zone" is an imaginary box over home plate. Where is it located vertically?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000025-0001-0001-0000-000000000008',
    '00000025-0001-0000-0000-000000000008',
    1,
    'The "strike zone" is an imaginary box over home plate. Where is it located vertically?',
    '["From the ground to the batter''s head", "Roughly from the batter''s knees to the middle of their torso", "From the batter''s waist to their shoulders only", "It''s the same for all batters regardless of height"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Foul ball as strike
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000025-0001-0000-0000-000000000009',
    '00000002-0000-0000-0000-000000000005',
    'mcq',
    'If a batter hits a foul ball, what happens to the count?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000025-0001-0001-0000-000000000009',
    '00000025-0001-0000-0000-000000000009',
    1,
    'If a batter hits a foul ball, what happens to the count?',
    '["It always counts as a ball", "It counts as a strikeout", "It counts as a strike, but you cannot strike out on a foul ball (unless it''s caught)", "Nothing - the count stays the same"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'AB1 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000002-0000-0000-0000-000000000005'

UNION ALL

SELECT
    'AB1 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000002-0000-0000-0000-000000000005';
