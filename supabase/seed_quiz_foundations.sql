-- ============================================================================
-- Rookie Foundations Quiz - Seed Data
-- ============================================================================
-- This quiz comes after PT2 (lesson 10) and tests lessons GB1-PT2
-- Contains 10 questions pulled from previous lessons
--
-- ORDER: 11 (between PT2 and OP1)
-- Type: Quiz (not a regular lesson)
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
-- STEP 4: Create Rookie Foundations Quiz (ORDER: 11 - after PT2, tests GB1-PT2)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000023',
    '11111111-1111-1111-1111-111111111111',
    'Rookie Foundations Quiz',
    'Test your knowledge of football basics, the field, scoring, and downs!',
    11,
    5,
    75,
    true,
    'QZ1',
    10,
    1
)
ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    code = EXCLUDED.code,
    order_index = EXCLUDED.order_index,
    items_per_session = EXCLUDED.items_per_session,
    required_completions = EXCLUDED.required_completions;


-- ============================================================================
-- STEP 5: Create Quiz Items (10 questions from GB1-PT2)
-- ============================================================================

-- Q1: From GB1 - Basic objective
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000023-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000023',
    'mcq',
    'What is the main goal of the offense in football?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000023-0001-0001-0000-000000000001',
    '00000023-0001-0000-0000-000000000001',
    1,
    'What is the main goal of the offense in football?',
    '["To stop the other team from scoring", "To move the ball into the opponent''s end zone and score", "To kick the ball as far as possible", "To run out the clock"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: From TF1 - Field length
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000023-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000023',
    'mcq',
    'How long is a football field (not including the end zones)?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000023-0001-0001-0000-000000000002',
    '00000023-0001-0000-0000-000000000002',
    1,
    'How long is a football field (not including the end zones)?',
    '["50 yards", "75 yards", "100 yards", "120 yards"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: From TF2 - Out of bounds
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000023-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000023',
    'binary',
    'If a player steps on the sideline while carrying the ball, they are out of bounds and the play stops.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000023-0001-0001-0000-000000000003',
    '00000023-0001-0000-0000-000000000003',
    1,
    'If a player steps on the sideline while carrying the ball, they are out of bounds and the play stops.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: From SC1 - Touchdown points
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000023-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000023',
    'mcq',
    'How many points is a touchdown worth?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000023-0001-0001-0000-000000000004',
    '00000023-0001-0000-0000-000000000004',
    1,
    'How many points is a touchdown worth?',
    '["3 points", "5 points", "6 points", "7 points"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: From DS1 - Number of downs
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000023-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000023',
    'mcq',
    'How many downs (tries) does the offense get to gain 10 yards?',
    '{"correct_index": 3}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000023-0001-0001-0000-000000000005',
    '00000023-0001-0000-0000-000000000005',
    1,
    'How many downs (tries) does the offense get to gain 10 yards?',
    '["1 down", "2 downs", "3 downs", "4 downs"]',
    '{"index": 3}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: From DS2 - Down notation
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000023-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000023',
    'mcq',
    'What does "2nd and 6" mean?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000023-0001-0001-0000-000000000006',
    '00000023-0001-0000-0000-000000000006',
    1,
    'What does "2nd and 6" mean?',
    '["2 points with 6 seconds left", "It''s the 2nd down and the offense needs 6 yards for a first down", "The score is 2 to 6", "There are 2 players and 6 yards to the end zone"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: From PT1 - Run vs pass
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000023-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000023',
    'mcq',
    'What is the difference between a run play and a pass play?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000023-0001-0001-0000-000000000007',
    '00000023-0001-0000-0000-000000000007',
    1,
    'What is the difference between a run play and a pass play?',
    '["Run play: player carries the ball; Pass play: ball is thrown through the air", "Run play: ball is kicked; Pass play: ball is thrown", "There is no difference", "Run play: defense has the ball; Pass play: offense has the ball"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: From SC2 - Field goal points
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000023-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000023',
    'mcq',
    'How many points is a field goal worth?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000023-0001-0001-0000-000000000008',
    '00000023-0001-0000-0000-000000000008',
    1,
    'How many points is a field goal worth?',
    '["1 point", "3 points", "6 points", "7 points"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: From TF3 - Line of scrimmage
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000023-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000023',
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
    '00000023-0001-0001-0000-000000000009',
    '00000023-0001-0000-0000-000000000009',
    1,
    'What is the line of scrimmage?',
    '["The imaginary line where the ball is placed before each play", "The goal line", "The 50-yard line", "The sideline"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q10: From PT2 - Situational (comprehensive)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000023-0001-0000-0000-000000000010',
    '00000001-0000-0000-0000-000000000023',
    'mcq',
    'A team scores a touchdown and then kicks the extra point successfully. How many total points did they score?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000023-0001-0001-0000-000000000010',
    '00000023-0001-0000-0000-000000000010',
    1,
    'A team scores a touchdown and then kicks the extra point successfully. How many total points did they score?',
    '["6 points", "3 points", "7 points", "9 points"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'Rookie Foundations Quiz' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000023'

UNION ALL

SELECT
    'Quiz Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000023';
