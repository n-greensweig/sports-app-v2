-- ============================================================================
-- SC2 (Scoring 2) - Seed Data
-- ============================================================================
-- SC2 is the EIGHTH lesson (after GB1, TF1, TF2, SC1, DS1, DS2, PT1)
-- SC2 covers: Field goals, extra points, goalposts/uprights
--
-- Prerequisites: SC1 (touchdown), DS1/DS2 (downs), PT1 (play types)
-- Terms INTRODUCED here: Field goal (3 pts), extra point (1 pt), goalposts/uprights
--
-- Can reference: Touchdown (6 pts), end zone, yards, downs, run/pass plays
--
-- Structure:
-- - SC2 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create SC2 Lesson (ORDER: 8)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000008',
    '11111111-1111-1111-1111-111111111111',
    'Scoring 2',
    'Learn about field goals, extra points, and the goalposts at the back of each end zone.',
    8,
    4,
    50,
    true,
    'SC2',
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
-- STEP 5: Create SC2 Items (9 questions - field goals, extra points, goalposts)
-- ============================================================================

-- Q1: What are the goalposts?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000008-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000008',
    'mcq',
    'What are the tall yellow posts at the back of each end zone called?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000008-0001-0001-0000-000000000001',
    '00000008-0001-0000-0000-000000000001',
    1,
    'What are the tall yellow posts at the back of each end zone called?',
    '["Yard markers", "Goalposts (or uprights)", "Sideline poles", "End zone flags"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: What is a field goal?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000008-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000008',
    'mcq',
    'What is a field goal in football?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000008-0001-0001-0000-000000000002',
    '00000008-0001-0000-0000-000000000002',
    1,
    'What is a field goal in football?',
    '["When the ball is kicked through the goalposts for points", "When a player runs into the end zone", "When a player catches the ball", "When the defense stops the offense"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: How many points is a field goal worth?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000008-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000008',
    'mcq',
    'How many points is a field goal worth?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000008-0001-0001-0000-000000000003',
    '00000008-0001-0000-0000-000000000003',
    1,
    'How many points is a field goal worth?',
    '["1 point", "2 points", "3 points", "6 points"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: What is an extra point?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000008-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000008',
    'mcq',
    'What is an extra point in football?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000008-0001-0001-0000-000000000004',
    '00000008-0001-0000-0000-000000000004',
    1,
    'What is an extra point in football?',
    '["A bonus point given for a long run", "A kick through the goalposts attempted after scoring a touchdown", "A point scored when the defense stops the offense", "A point given for winning the coin toss"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: How many points is an extra point worth?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000008-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000008',
    'mcq',
    'How many points is an extra point worth?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000008-0001-0001-0000-000000000005',
    '00000008-0001-0000-0000-000000000005',
    1,
    'How many points is an extra point worth?',
    '["1 point", "2 points", "3 points", "6 points"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: When can a team attempt an extra point?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000008-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000008',
    'mcq',
    'When can a team attempt an extra point?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000008-0001-0001-0000-000000000006',
    '00000008-0001-0000-0000-000000000006',
    1,
    'When can a team attempt an extra point?',
    '["At the start of the game", "After making a field goal", "After scoring a touchdown", "At the end of each quarter"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Touchdown + extra point total
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000008-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000008',
    'mcq',
    'A team scores a touchdown (6 points) and then kicks the extra point successfully. How many total points did they score on that drive?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000008-0001-0001-0000-000000000007',
    '00000008-0001-0000-0000-000000000007',
    1,
    'A team scores a touchdown (6 points) and then kicks the extra point successfully. How many total points did they score on that drive?',
    '["6 points", "3 points", "7 points", "9 points"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Field goal vs touchdown - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000008-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000008',
    'binary',
    'A field goal is worth more points than a touchdown.',
    '{"correct_boolean": false}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000008-0001-0001-0000-000000000008',
    '00000008-0001-0000-0000-000000000008',
    1,
    'A field goal is worth more points than a touchdown.',
    '["True", "False"]',
    '{"boolean": false}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Situational - when to kick a field goal
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000008-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000008',
    'mcq',
    'The Dallas Cowboys are on 4th down and have not gained enough yards for a first down. They are close to the end zone but not quite there. What might they do to still score points?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000008-0001-0001-0000-000000000009',
    '00000008-0001-0000-0000-000000000009',
    1,
    'The Dallas Cowboys are on 4th down and have not gained enough yards for a first down. They are close to the end zone but not quite there. What might they do to still score points?',
    '["Give the ball to the other team", "Attempt a field goal (kick it through the goalposts for 3 points)", "Start the game over", "Call a timeout to score automatically"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'SC2 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000008'

UNION ALL

SELECT
    'SC2 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000008';
