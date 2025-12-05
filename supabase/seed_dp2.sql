-- ============================================================================
-- DP2 (Defensive Positions 2) - Seed Data
-- ============================================================================
-- DP2 is the FIFTEENTH lesson (ORDER: 15)
-- DP2 covers: Cornerback and safety positions
--
-- Prerequisites: DP1 (defensive line, linebacker)
-- Terms INTRODUCED here: Cornerback, safety, coverage
--
-- Can reference: Defensive line, linebacker, wide receiver, pass plays, catching
--
-- Structure:
-- - DP2 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create DP2 Lesson (ORDER: 15)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000014',
    '11111111-1111-1111-1111-111111111111',
    'Defensive Positions 2',
    'Meet the cornerbacks and safeties - the defenders who stop passes and protect against big plays.',
    15,
    4,
    50,
    true,
    'DP2',
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
-- STEP 5: Create DP2 Items (9 questions - cornerback, safety, coverage)
-- ============================================================================

-- Q1: What is a cornerback?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000014-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000014',
    'mcq',
    'What is a cornerback''s main job on defense?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000014-0001-0001-0000-000000000001',
    '00000014-0001-0000-0000-000000000001',
    1,
    'What is a cornerback''s main job on defense?',
    '["To rush the quarterback", "To cover wide receivers and try to prevent them from catching passes", "To tackle the running back", "To kick field goals"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: What does coverage mean?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000014-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000014',
    'mcq',
    'What does "coverage" mean in football defense?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000014-0001-0001-0000-000000000002',
    '00000014-0001-0000-0000-000000000002',
    1,
    'What does "coverage" mean in football defense?',
    '["Staying close to offensive players to prevent them from catching passes", "Covering the ball with your hands", "Covering your face with a helmet", "Putting a tarp on the field"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What is a safety?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000014-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000014',
    'mcq',
    'Where does a safety usually line up on the field?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000014-0001-0001-0000-000000000003',
    '00000014-0001-0000-0000-000000000003',
    1,
    'Where does a safety usually line up on the field?',
    '["Right at the line of scrimmage", "On the sideline", "Deep in the backfield, far from the line of scrimmage", "In the end zone"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: Safety's role
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000014-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000014',
    'mcq',
    'What is one of the safety''s main jobs on defense?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000014-0001-0001-0000-000000000004',
    '00000014-0001-0000-0000-000000000004',
    1,
    'What is one of the safety''s main jobs on defense?',
    '["To throw the ball", "To help stop long passes and provide backup for other defenders", "To kick field goals", "To hand off the ball"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: Cornerback vs wide receiver - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000014-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000014',
    'binary',
    'Cornerbacks often match up one-on-one against wide receivers.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000014-0001-0001-0000-000000000005',
    '00000014-0001-0000-0000-000000000005',
    1,
    'Cornerbacks often match up one-on-one against wide receivers.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Last line of defense
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000014-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000014',
    'binary',
    'Safeties are often called the "last line of defense" because they are positioned deepest on the field.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000014-0001-0001-0000-000000000006',
    '00000014-0001-0000-0000-000000000006',
    1,
    'Safeties are often called the "last line of defense" because they are positioned deepest on the field.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Situational - who broke up the pass?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000014-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000014',
    'mcq',
    'The Seattle Seahawks quarterback throws a pass to a wide receiver near the sideline. A defender runs alongside the receiver and knocks the ball away before it can be caught. What position was the defender most likely playing?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000014-0001-0001-0000-000000000007',
    '00000014-0001-0000-0000-000000000007',
    1,
    'The Seattle Seahawks quarterback throws a pass to a wide receiver near the sideline. A defender runs alongside the receiver and knocks the ball away before it can be caught. What position was the defender most likely playing?',
    '["Cornerback", "Defensive lineman", "Running back", "Quarterback"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Safety helps stop long pass
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000014-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000014',
    'mcq',
    'A quarterback throws a long pass down the middle of the field. A defender who was positioned deep comes over to help the cornerback and tackles the receiver right after the catch. What position was this deep defender most likely playing?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000014-0001-0001-0000-000000000008',
    '00000014-0001-0000-0000-000000000008',
    1,
    'A quarterback throws a long pass down the middle of the field. A defender who was positioned deep comes over to help the cornerback and tackles the receiver right after the catch. What position was this deep defender most likely playing?',
    '["Defensive lineman", "Linebacker", "Safety", "Running back"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Defensive secondary
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000014-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000014',
    'mcq',
    'Cornerbacks and safeties together are often called the "defensive secondary" or "defensive backs." What is their main goal?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000014-0001-0001-0000-000000000009',
    '00000014-0001-0000-0000-000000000009',
    1,
    'Cornerbacks and safeties together are often called the "defensive secondary" or "defensive backs." What is their main goal?',
    '["To throw passes", "To stop the passing game by covering receivers and preventing catches", "To run with the ball", "To kick field goals"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'DP2 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000014'

UNION ALL

SELECT
    'DP2 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000014';
