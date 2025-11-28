-- ============================================================================
-- PT1 (Play Types 1) - Seed Data
-- ============================================================================
-- PT1 is the SEVENTH lesson (after GB1, TF1, TF2, SC1, DS1, DS2)
-- PT1 covers: Run plays vs pass plays, throwing, catching, handoff
--
-- Prerequisites: DS1, DS2 (downs system)
-- Terms INTRODUCED here: Run play, pass play, throw, catch, handoff
--
-- CRITICAL: NO position names yet (quarterback, running back - that's OP1)
-- Just "a player throws" or "a player catches"
--
-- Structure:
-- - PT1 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create PT1 Lesson (ORDER: 7)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000007',
    '11111111-1111-1111-1111-111111111111',
    'Play Types 1',
    'Learn the two main ways to move the ball: running and passing.',
    7,
    4,
    50,
    true,
    'PT1',
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
-- STEP 5: Create PT1 Items (9 questions - run and pass plays)
-- ============================================================================

-- Q1: Two main ways to move the ball
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000007-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000007',
    'mcq',
    'What are the two main ways the offense can move the ball down the field?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000007-0001-0001-0000-000000000001',
    '00000007-0001-0000-0000-000000000001',
    1,
    'What are the two main ways the offense can move the ball down the field?',
    '["Kicking and punting", "Walking and crawling", "Running with it or throwing (passing) it", "Rolling and bouncing"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: What is a run play?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000007-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000007',
    'mcq',
    'What is a "run play"?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000007-0001-0001-0000-000000000002',
    '00000007-0001-0000-0000-000000000002',
    1,
    'What is a "run play"?',
    '["When a player carries the ball and runs with it", "When a player throws the ball to a teammate", "When a player kicks the ball", "When a player stands still with the ball"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What is a pass play?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000007-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000007',
    'mcq',
    'What is a "pass play"?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000007-0001-0001-0000-000000000003',
    '00000007-0001-0000-0000-000000000003',
    1,
    'What is a "pass play"?',
    '["When a player runs with the ball", "When the ball is thrown through the air to a teammate", "When the ball is kicked", "When a player hands the ball to the referee"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: What is a catch?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000007-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000007',
    'mcq',
    'On a pass play, what does it mean to "catch" the ball?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000007-0001-0001-0000-000000000004',
    '00000007-0001-0000-0000-000000000004',
    1,
    'On a pass play, what does it mean to "catch" the ball?',
    '["To throw the ball", "To kick the ball", "To receive and hold onto the ball that was thrown", "To drop the ball"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: What is a handoff?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000007-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000007',
    'mcq',
    'What is a "handoff" in football?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000007-0001-0001-0000-000000000005',
    '00000007-0001-0000-0000-000000000005',
    1,
    'What is a "handoff" in football?',
    '["When one player hands the ball directly to a teammate (not thrown)", "When a player throws the ball", "When a player kicks the ball to a teammate", "When a player drops the ball"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Run play vs pass play - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000007-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000007',
    'binary',
    'A run play involves carrying the ball, while a pass play involves throwing the ball.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000007-0001-0001-0000-000000000006',
    '00000007-0001-0000-0000-000000000006',
    1,
    'A run play involves carrying the ball, while a pass play involves throwing the ball.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Which type of play - running with ball
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000007-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000007',
    'mcq',
    'A player receives a handoff and runs forward with the ball. What type of play is this?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000007-0001-0001-0000-000000000007',
    '00000007-0001-0000-0000-000000000007',
    1,
    'A player receives a handoff and runs forward with the ball. What type of play is this?',
    '["A run play", "A pass play", "A kick", "A timeout"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Which type of play - throwing the ball
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000007-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000007',
    'mcq',
    'A player throws the ball through the air and a teammate catches it. What type of play is this?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000007-0001-0001-0000-000000000008',
    '00000007-0001-0000-0000-000000000008',
    1,
    'A player throws the ball through the air and a teammate catches it. What type of play is this?',
    '["A run play", "A pass play", "A kick", "A fumble"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Both can gain yards
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000007-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000007',
    'binary',
    'Both run plays and pass plays can be used to gain yards toward a first down.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000007-0001-0001-0000-000000000009',
    '00000007-0001-0000-0000-000000000009',
    1,
    'Both run plays and pass plays can be used to gain yards toward a first down.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'PT1 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000007'

UNION ALL

SELECT
    'PT1 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000007';
