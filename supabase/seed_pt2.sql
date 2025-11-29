-- ============================================================================
-- PT2 (Play Types 2) - Seed Data
-- ============================================================================
-- PT2 is the TENTH lesson (after GB1, TF1, TF2, SC1, DS1, DS2, PT1, SC2, TF3)
-- PT2 covers: First down scenarios, incomplete passes, applying all previous knowledge
--
-- Prerequisites: ALL previous lessons
-- Terms INTRODUCED here: Incomplete pass, first down (achieved)
--
-- Can reference: ALL previous concepts - this is where situational questions shine!
-- - Offense, defense, end zone, yard lines, sidelines, out of bounds
-- - Touchdown (6 pts), field goal (3 pts), extra point (1 pt), goalposts
-- - Downs (1st-4th), "1st and 10" notation, 10-yard requirement
-- - Run play, pass play, throw, catch, handoff
-- - Line of scrimmage, hash marks, pylons
--
-- Structure:
-- - PT2 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create PT2 Lesson (ORDER: 10)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000010',
    '11111111-1111-1111-1111-111111111111',
    'Play Types 2',
    'Apply what you''ve learned! Practice with game scenarios involving downs, yards, and scoring.',
    10,
    4,
    50,
    true,
    'PT2',
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
-- STEP 5: Create PT2 Items (9 questions - situational scenarios applying all knowledge)
-- ============================================================================

-- Q1: What is an incomplete pass?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000010-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000010',
    'mcq',
    'What happens when a pass is thrown but no one catches it?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000010-0001-0001-0000-000000000001',
    '00000010-0001-0000-0000-000000000001',
    1,
    'What happens when a pass is thrown but no one catches it?',
    '["The offense gains 10 yards", "It''s an incomplete pass - the ball goes back to the line of scrimmage and the next down begins", "The defense scores a touchdown", "The offense can try the same play again"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: Incomplete pass - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000010-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000010',
    'binary',
    'On an incomplete pass, the offense loses yards.',
    '{"correct_boolean": false}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000010-0001-0001-0000-000000000002',
    '00000010-0001-0000-0000-000000000002',
    1,
    'On an incomplete pass, the offense loses yards.',
    '["True", "False"]',
    '{"boolean": false}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: Situational - gaining a first down
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000010-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000010',
    'mcq',
    'The Miami Dolphins have the ball on 2nd and 7 (2nd down, 7 yards to go). A player catches a pass and runs for 9 yards. What happens next?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000010-0001-0001-0000-000000000003',
    '00000010-0001-0000-0000-000000000003',
    1,
    'The Miami Dolphins have the ball on 2nd and 7 (2nd down, 7 yards to go). A player catches a pass and runs for 9 yards. What happens next?',
    '["First down! They get a new set of 4 downs because they gained more than 7 yards", "3rd down - they need to try again", "The other team gets the ball", "They must kick a field goal"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: Situational - not getting first down
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000010-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000010',
    'mcq',
    'The San Francisco 49ers have the ball on 1st and 10. They run the ball and gain 3 yards. What is the next down situation?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000010-0001-0001-0000-000000000004',
    '00000010-0001-0000-0000-000000000004',
    1,
    'The San Francisco 49ers have the ball on 1st and 10. They run the ball and gain 3 yards. What is the next down situation?',
    '["1st and 10 (start over)", "1st and 7", "2nd and 7 (2nd down, 7 yards still needed)", "Touchdown"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: Situational - 4th down decision
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000010-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000010',
    'mcq',
    'The Chicago Bears are on 4th and 2 at their opponent''s 25-yard line. They don''t think they can get the 2 yards. What might they do to try to score?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000010-0001-0001-0000-000000000005',
    '00000010-0001-0000-0000-000000000005',
    1,
    'The Chicago Bears are on 4th and 2 at their opponent''s 25-yard line. They don''t think they can get the 2 yards. What might they do to try to score?',
    '["Give up and walk off the field", "Attempt a field goal (kick it through the goalposts for 3 points)", "Wait until the next quarter", "Ask for extra downs"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Situational - touchdown scenario
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000010-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000010',
    'mcq',
    'The Green Bay Packers have the ball on 1st and goal at the 5-yard line. A player catches a pass and runs into the end zone. What happens?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000010-0001-0001-0000-000000000006',
    '00000010-0001-0000-0000-000000000006',
    1,
    'The Green Bay Packers have the ball on 1st and goal at the 5-yard line. A player catches a pass and runs into the end zone. What happens?',
    '["Touchdown! The Packers score 6 points and can attempt an extra point", "First down - they get 4 more tries", "Field goal - they score 3 points", "The defense gets the ball"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Run vs pass choice
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000010-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000010',
    'binary',
    'If the offense needs 15 yards for a first down, a long pass play could get them there in one play.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000010-0001-0001-0000-000000000007',
    '00000010-0001-0000-0000-000000000007',
    1,
    'If the offense needs 15 yards for a first down, a long pass play could get them there in one play.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Situational - out of bounds
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000010-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000010',
    'mcq',
    'The Buffalo Bills are on 3rd and 5. A player catches a pass and runs 4 yards but then steps out of bounds on the sideline. What happens?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000010-0001-0001-0000-000000000008',
    '00000010-0001-0000-0000-000000000008',
    1,
    'The Buffalo Bills are on 3rd and 5. A player catches a pass and runs 4 yards but then steps out of bounds on the sideline. What happens?',
    '["First down - they got close enough", "Touchdown is scored", "The play ends where they went out; it''s now 4th and 1 (they gained 4 of the 5 yards needed)", "The play doesn''t count"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Complete scoring drive
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000010-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000010',
    'mcq',
    'The Kansas City Chiefs score a touchdown and then successfully kick the extra point. Later, they kick a field goal. How many total points did they score?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000010-0001-0001-0000-000000000009',
    '00000010-0001-0000-0000-000000000009',
    1,
    'The Kansas City Chiefs score a touchdown and then successfully kick the extra point. Later, they kick a field goal. How many total points did they score?',
    '["9 points (6 + 3)", "10 points (6 + 1 + 3)", "7 points (6 + 1)", "12 points"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'PT2 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000010'

UNION ALL

SELECT
    'PT2 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000010';
