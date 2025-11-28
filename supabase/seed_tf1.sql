-- ============================================================================
-- TF1 (The Field 1) - Seed Data
-- ============================================================================
-- TF1 is the SECOND lesson (after GB1)
-- TF1 covers: Field is 100 yards, yard lines, 50-yard line, end zone locations
--
-- Prerequisites: GB1 (offense, defense, end zone basic concept)
-- Terms INTRODUCED here: 100 yards, yard lines, 50-yard line, end zone location details
--
-- CRITICAL: NO scoring questions, NO gameplay questions, NO touchdown mechanics
-- This lesson is ONLY about the physical layout of the field.
--
-- Structure:
-- - TF1 Lesson (9 questions, 5 shown per session, 5 completions to master)
-- ============================================================================

-- ============================================================================
-- STEP 1: Ensure Football sport exists
-- ============================================================================

INSERT INTO sports (id, slug, name, accent_color, description, order_index, is_active)
VALUES (
    '0105433b-5bdd-4093-b6b1-157a0c3c515e',
    'football',
    'Football',
    '#2E7D32',
    'Football - NFL and College',
    1,
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
    '11111111-1111-1111-1111-111111111111',
    '0105433b-5bdd-4093-b6b1-157a0c3c515e',
    'Rookie',
    'Start your football journey! Learn the basics of the field, scoring, and key terms.',
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
-- STEP 4: Create TF1 Lesson (ORDER: 2)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000002',
    '11111111-1111-1111-1111-111111111111',
    'The Field 1',
    'Learn the layout of a football field - how long it is and what the markings mean.',
    2,
    4,
    50,
    true,
    'TF1',
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
-- STEP 5: Create TF1 Items (9 questions - field layout ONLY)
-- ============================================================================

-- Q1: Field length
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'How long is a football field (not counting the end zones)?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000001',
    '00000002-0001-0000-0000-000000000001',
    1,
    'How long is a football field (not counting the end zones)?',
    '["50 yards", "100 yards", "150 yards", "200 yards"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: What do the numbers on the field mean?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'You see large numbers painted on the field like 10, 20, 30, 40, 50. What do these numbers tell you?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000002',
    '00000002-0001-0000-0000-000000000002',
    1,
    'You see large numbers painted on the field like 10, 20, 30, 40, 50. What do these numbers tell you?',
    '["How many players are on the field", "The score of the game", "How many yards from the nearest end zone", "The time left in the game"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: 50-yard line location
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'Where is the 50-yard line located on the field?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000003',
    '00000002-0001-0000-0000-000000000003',
    1,
    'Where is the 50-yard line located on the field?',
    '["In the exact middle of the field", "Near one end zone", "There is no 50-yard line", "It moves during the game"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: End zone depth
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'How deep is each end zone?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000004',
    '00000002-0001-0000-0000-000000000004',
    1,
    'How deep is each end zone?',
    '["5 yards", "10 yards", "15 yards", "20 yards"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: Total field length including end zones
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'The main field is 100 yards. Each end zone is 10 yards deep. How long is the entire field including both end zones?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000005',
    '00000002-0001-0000-0000-000000000005',
    1,
    'The main field is 100 yards. Each end zone is 10 yards deep. How long is the entire field including both end zones?',
    '["100 yards", "110 yards", "120 yards", "130 yards"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Yard lines every how many yards?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'White lines run across the field at regular intervals. These are called yard lines. How often do the numbered yard lines appear?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000006',
    '00000002-0001-0000-0000-000000000006',
    1,
    'White lines run across the field at regular intervals. These are called yard lines. How often do the numbered yard lines appear?',
    '["Every 5 yards", "Every 10 yards", "Every 20 yards", "Every 25 yards"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Numbers count down toward end zone - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000002',
    'binary',
    'Starting from the 50-yard line, the numbers get smaller as you move toward either end zone (50, 40, 30, 20, 10).',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000007',
    '00000002-0001-0000-0000-000000000007',
    1,
    'Starting from the 50-yard line, the numbers get smaller as you move toward either end zone (50, 40, 30, 20, 10).',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Where are the end zones?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'Where are the two end zones located on a football field?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000008',
    '00000002-0001-0000-0000-000000000008',
    1,
    'Where are the two end zones located on a football field?',
    '["In the middle of the field", "On the sides of the field", "At opposite ends of the field", "There is only one end zone"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: What do smaller yard numbers mean?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'If the offense is at the 20-yard line, what does that tell you?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000009',
    '00000002-0001-0000-0000-000000000009',
    1,
    'If the offense is at the 20-yard line, what does that tell you?',
    '["They are in the middle of the field", "They are 20 yards away from an end zone", "They have scored 20 points", "There are 20 minutes left"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'TF1 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000002'

UNION ALL

SELECT
    'TF1 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000002';
