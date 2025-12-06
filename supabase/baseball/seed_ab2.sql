-- ============================================================================
-- AB2 (At Bats 2) - Baseball Seed Data
-- ============================================================================
-- AB2 is the SIXTH lesson (after AB1)
-- AB2 covers: Types of hits, batting order, outs at the plate
--
-- Prerequisites: GB1-AB1 (strikes, balls, strikeouts, walks)
-- Terms INTRODUCED here: single, double, triple, batting order, lineup
--
-- Structure:
-- - AB2 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create AB2 Lesson (ORDER: 6)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-000000000006',
    '22222222-2222-2222-2222-222222222222',
    'At Bats 2',
    'Learn about different types of hits and how the batting order works.',
    6,
    4,
    50,
    true,
    'AB2',
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
-- STEP 5: Create AB2 Items (9 questions)
-- ============================================================================

-- Q1: What is a single?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000026-0001-0000-0000-000000000001',
    '00000002-0000-0000-0000-000000000006',
    'mcq',
    'What is a "single" in baseball?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000026-0001-0001-0000-000000000001',
    '00000026-0001-0000-0000-000000000001',
    1,
    'What is a "single" in baseball?',
    '["A hit where the batter reaches first base safely", "A hit where the batter reaches second base", "When only one player is on base", "A pitch that results in one strike"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: What is a double?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000026-0001-0000-0000-000000000002',
    '00000002-0000-0000-0000-000000000006',
    'mcq',
    'What is a "double" in baseball?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000026-0001-0001-0000-000000000002',
    '00000026-0001-0000-0000-000000000002',
    1,
    'What is a "double" in baseball?',
    '["When two players are on base", "A hit where the batter reaches second base safely", "Two outs in an inning", "A ball hit twice"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What is a triple?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000026-0001-0000-0000-000000000003',
    '00000002-0000-0000-0000-000000000006',
    'mcq',
    'What is a "triple" in baseball?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000026-0001-0001-0000-000000000003',
    '00000026-0001-0000-0000-000000000003',
    1,
    'What is a "triple" in baseball?',
    '["Three strikes", "Three balls", "A hit where the batter reaches third base safely", "When three runners are on base"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: Batting order
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000026-0001-0000-0000-000000000004',
    '00000002-0000-0000-0000-000000000006',
    'mcq',
    'How many batters are in a team''s batting order (lineup)?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000026-0001-0001-0000-000000000004',
    '00000026-0001-0000-0000-000000000004',
    1,
    'How many batters are in a team''s batting order (lineup)?',
    '["5 batters", "7 batters", "9 batters", "11 batters"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: Batting order cycles - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000026-0001-0000-0000-000000000005',
    '00000002-0000-0000-0000-000000000006',
    'binary',
    'After the 9th batter hits, the batting order starts over with the 1st batter.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000026-0001-0001-0000-000000000005',
    '00000026-0001-0000-0000-000000000005',
    1,
    'After the 9th batter hits, the batting order starts over with the 1st batter.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: What is a hit?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000026-0001-0000-0000-000000000006',
    '00000002-0000-0000-0000-000000000006',
    'mcq',
    'When does a batter get credit for a "hit"?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000026-0001-0001-0000-000000000006',
    '00000026-0001-0000-0000-000000000006',
    1,
    'When does a batter get credit for a "hit"?',
    '["Any time they swing the bat", "When they hit the ball into fair territory and reach base safely without an error", "When they hit a foul ball", "When they get walked"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Leadoff hitter
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000026-0001-0000-0000-000000000007',
    '00000002-0000-0000-0000-000000000006',
    'mcq',
    'The "leadoff hitter" is the player who bats in which position in the lineup?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000026-0001-0001-0000-000000000007',
    '00000026-0001-0000-0000-000000000007',
    1,
    'The "leadoff hitter" is the player who bats in which position in the lineup?',
    '["1st", "4th", "9th", "5th"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Cleanup hitter
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000026-0001-0000-0000-000000000008',
    '00000002-0000-0000-0000-000000000006',
    'mcq',
    'The "cleanup hitter" traditionally bats in which position?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000026-0001-0001-0000-000000000008',
    '00000026-0001-0000-0000-000000000008',
    1,
    'The "cleanup hitter" traditionally bats in which position?',
    '["1st", "4th", "9th", "3rd"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: At bat vs plate appearance
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000026-0001-0000-0000-000000000009',
    '00000002-0000-0000-0000-000000000006',
    'mcq',
    'A walk does NOT count as an official "at bat" for the batter. Why might this matter?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000026-0001-0001-0000-000000000009',
    '00000026-0001-0000-0000-000000000009',
    1,
    'A walk does NOT count as an official "at bat" for the batter. Why might this matter?',
    '["It affects how runs are counted", "It changes the batting order", "It affects the batter''s batting average (hits divided by at bats)", "It doesn''t matter at all"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'AB2 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000002-0000-0000-0000-000000000006'

UNION ALL

SELECT
    'AB2 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000002-0000-0000-0000-000000000006';
