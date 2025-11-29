-- ============================================================================
-- TF3 (The Field 3) - Seed Data
-- ============================================================================
-- TF3 is the NINTH lesson (after GB1, TF1, TF2, SC1, DS1, DS2, PT1, SC2)
-- TF3 covers: Line of scrimmage, hash marks, pylons
--
-- Prerequisites: All previous lessons (especially TF1, TF2 for field concepts)
-- Terms INTRODUCED here: Line of scrimmage, hash marks, pylons
--
-- Can reference: Yard lines, end zone, sidelines, downs, plays, touchdown, field goal
--
-- Structure:
-- - TF3 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create TF3 Lesson (ORDER: 9)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000009',
    '11111111-1111-1111-1111-111111111111',
    'The Field 3',
    'Learn about the line of scrimmage, hash marks, and pylons that mark important spots on the field.',
    9,
    4,
    50,
    true,
    'TF3',
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
-- STEP 5: Create TF3 Items (9 questions - line of scrimmage, hash marks, pylons)
-- ============================================================================

-- Q1: What is the line of scrimmage?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000009-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000009',
    'mcq',
    'What is the line of scrimmage?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000009-0001-0001-0000-000000000001',
    '00000009-0001-0000-0000-000000000001',
    1,
    'What is the line of scrimmage?',
    '["The imaginary line where the ball is placed before each play begins", "The line at the back of the end zone", "The sideline along the edge of the field", "The 50-yard line in the middle of the field"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: Line of scrimmage - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000009-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000009',
    'binary',
    'The line of scrimmage changes position after each play, depending on where the ball ends up.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000009-0001-0001-0000-000000000002',
    '00000009-0001-0000-0000-000000000002',
    1,
    'The line of scrimmage changes position after each play, depending on where the ball ends up.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What are hash marks?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000009-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000009',
    'mcq',
    'What are hash marks on a football field?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000009-0001-0001-0000-000000000003',
    '00000009-0001-0000-0000-000000000003',
    1,
    'What are hash marks on a football field?',
    '["The numbers painted on the field", "Short lines running down the middle of the field that show where the ball can be placed", "The lines at the edge of the field", "Marks showing where players should stand"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: What are pylons?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000009-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000009',
    'mcq',
    'What are the orange markers at the corners of each end zone called?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000009-0001-0001-0000-000000000004',
    '00000009-0001-0000-0000-000000000004',
    1,
    'What are the orange markers at the corners of each end zone called?',
    '["Goal posts", "Hash marks", "Pylons", "Sideline markers"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: Purpose of pylons
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000009-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000009',
    'mcq',
    'Why are pylons placed at the corners of the end zone?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000009-0001-0001-0000-000000000005',
    '00000009-0001-0000-0000-000000000005',
    1,
    'Why are pylons placed at the corners of the end zone?',
    '["To help players and referees see exactly where the end zone boundaries are", "To give players something to catch", "To mark where the goalposts should go", "To show where the 50-yard line is"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Where is the ball placed?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000009-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000009',
    'mcq',
    'Before each play, where is the ball placed on the field?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000009-0001-0001-0000-000000000006',
    '00000009-0001-0000-0000-000000000006',
    1,
    'Before each play, where is the ball placed on the field?',
    '["In the end zone", "On or near the hash marks, at the line of scrimmage", "On the sideline", "At the 50-yard line"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Situational - line of scrimmage after a play
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000009-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000009',
    'mcq',
    'The New England Patriots run a play and the runner is tackled at the 35-yard line. Where will the new line of scrimmage be for the next play?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000009-0001-0001-0000-000000000007',
    '00000009-0001-0000-0000-000000000007',
    1,
    'The New England Patriots run a play and the runner is tackled at the 35-yard line. Where will the new line of scrimmage be for the next play?',
    '["At the 50-yard line", "At the goal line", "At the 35-yard line (where the runner was tackled)", "At the end zone"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Hash marks - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000009-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000009',
    'binary',
    'Hash marks run along the entire length of the field from one end zone to the other.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000009-0001-0001-0000-000000000008',
    '00000009-0001-0000-0000-000000000008',
    1,
    'Hash marks run along the entire length of the field from one end zone to the other.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Pylon touchdown scenario
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000009-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000009',
    'mcq',
    'A player is running toward the end zone and reaches out to touch the pylon with the ball before going out of bounds. What happens?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000009-0001-0001-0000-000000000009',
    '00000009-0001-0000-0000-000000000009',
    1,
    'A player is running toward the end zone and reaches out to touch the pylon with the ball before going out of bounds. What happens?',
    '["It''s a touchdown! The pylon marks the corner of the end zone.", "The play is dead with no score", "The player must go back to the line of scrimmage", "A field goal is awarded"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'TF3 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000009'

UNION ALL

SELECT
    'TF3 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000009';
