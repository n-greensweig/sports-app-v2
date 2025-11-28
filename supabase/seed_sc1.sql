-- ============================================================================
-- SC1 (Scoring 1) - Seed Data
-- ============================================================================
-- SC1 is the FOURTH lesson (after GB1, TF1, TF2)
-- SC1 covers: Touchdown (6 points), goal line, how to score a touchdown
--
-- Prerequisites: GB1 (offense, defense, end zone), TF1 (yard lines), TF2 (boundaries)
-- Terms INTRODUCED here: Touchdown, goal line, 6 points, scoring
--
-- CRITICAL: NO field goals, NO extra points, NO downs yet
-- Just touchdowns - the main way to score
--
-- Structure:
-- - SC1 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create SC1 Lesson (ORDER: 4)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000004',
    '11111111-1111-1111-1111-111111111111',
    'Scoring 1',
    'Learn about the touchdown - the most exciting way to score in football!',
    4,
    4,
    50,
    true,
    'SC1',
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
-- STEP 5: Create SC1 Items (9 questions - touchdowns ONLY)
-- ============================================================================

-- Q1: What is a touchdown?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000004-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000004',
    'mcq',
    'What is a "touchdown" in football?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000004-0001-0001-0000-000000000001',
    '00000004-0001-0000-0000-000000000001',
    1,
    'What is a "touchdown" in football?',
    '["When a player kicks the ball", "When a player is tackled", "When the offense gets the ball into the opponent''s end zone", "When a player goes out of bounds"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: How many points is a touchdown?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000004-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000004',
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
    '00000004-0001-0001-0000-000000000002',
    '00000004-0001-0000-0000-000000000002',
    1,
    'How many points is a touchdown worth?',
    '["1 point", "3 points", "6 points", "7 points"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What is the goal line?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000004-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000004',
    'mcq',
    'What is the "goal line" in football?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000004-0001-0001-0000-000000000003',
    '00000004-0001-0000-0000-000000000003',
    1,
    'What is the "goal line" in football?',
    '["The 50-yard line in the middle of the field", "The line at the front of each end zone that you must cross to score", "The sideline", "The line where teams start the game"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: Where is the goal line located?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000004-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000004',
    'mcq',
    'Where is the goal line located on the field?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000004-0001-0001-0000-000000000004',
    '00000004-0001-0000-0000-000000000004',
    1,
    'Where is the goal line located on the field?',
    '["At the front edge of each end zone", "In the middle of the field", "At the back of each end zone", "On the sidelines"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: What must cross the goal line for a touchdown?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000004-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000004',
    'mcq',
    'To score a touchdown, what must cross the goal line?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000004-0001-0001-0000-000000000005',
    '00000004-0001-0000-0000-000000000005',
    1,
    'To score a touchdown, what must cross the goal line?',
    '["The player''s entire body", "The ball (while a player has it)", "The player''s feet", "Nothing needs to cross - just get close"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Touchdown = 6 points - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000004-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000004',
    'binary',
    'A touchdown is worth 6 points.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000004-0001-0001-0000-000000000006',
    '00000004-0001-0000-0000-000000000006',
    1,
    'A touchdown is worth 6 points.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Who scores the touchdown?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000004-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000004',
    'mcq',
    'Which team can score a touchdown - the offense or the defense?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000004-0001-0001-0000-000000000007',
    '00000004-0001-0000-0000-000000000007',
    1,
    'Which team can score a touchdown - the offense or the defense?',
    '["Only the offense", "Only the defense", "Either team can score a touchdown", "Neither team - touchdowns are automatic"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Which end zone does the offense want?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000004-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000004',
    'mcq',
    'To score a touchdown, which end zone must the offense reach?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000004-0001-0001-0000-000000000008',
    '00000004-0001-0000-0000-000000000008',
    1,
    'To score a touchdown, which end zone must the offense reach?',
    '["Their own end zone (behind them)", "The opponent''s end zone (in front of them)", "Either end zone", "The end zone closest to them"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: How can a player get the ball into the end zone?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000004-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000004',
    'mcq',
    'A player can score a touchdown by getting the ball into the end zone. Which of these is a way to do that?',
    '{"correct_index": 3}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000004-0001-0001-0000-000000000009',
    '00000004-0001-0000-0000-000000000009',
    1,
    'A player can score a touchdown by getting the ball into the end zone. Which of these is a way to do that?',
    '["Only by running with the ball", "Only by catching the ball in the end zone", "Only by kicking the ball", "By running with it OR catching it in the end zone"]',
    '{"index": 3}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'SC1 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000004'

UNION ALL

SELECT
    'SC1 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000004';
