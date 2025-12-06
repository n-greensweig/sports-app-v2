-- ============================================================================
-- GB1 (Game Basics 1) - Baseball Seed Data
-- ============================================================================
-- GB1 is the FIRST lesson - assumes ZERO baseball knowledge
-- GB1 covers: What is baseball? Two teams, 9 innings, batting/fielding turns
--
-- CRITICAL: This lesson uses ONLY basic everyday words. No baseball jargon.
-- Terms INTRODUCED here: inning, batting team, fielding team, run
--
-- Structure:
-- - GB1 Lesson (9 questions, 5 shown per session, 5 completions to master)
-- ============================================================================

-- ============================================================================
-- Baseball Lesson ID Pattern: 00000002-0000-0000-0000-00000000000X
-- Baseball Item ID Pattern:   0000002X-0001-0000-0000-00000000000Y
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
-- STEP 4: Create GB1 Lesson (ORDER: 1 - First lesson!)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-000000000001',
    '22222222-2222-2222-2222-222222222222',
    'Game Basics 1',
    'What is baseball? Learn the basic objective and how two teams compete.',
    1,
    4,
    50,
    false,
    'GB1',
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
-- STEP 5: Create GB1 Items (9 questions)
-- ============================================================================

-- Q1: How many teams play?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000021-0001-0000-0000-000000000001',
    '00000002-0000-0000-0000-000000000001',
    'mcq',
    'How many teams play in a baseball game?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000021-0001-0001-0000-000000000001',
    '00000021-0001-0000-0000-000000000001',
    1,
    'How many teams play in a baseball game?',
    '["1 team", "2 teams", "3 teams", "4 teams"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: What does the batting team try to do?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000021-0001-0000-0000-000000000002',
    '00000002-0000-0000-0000-000000000001',
    'mcq',
    'One team bats while the other team plays in the field. What is the batting team trying to do?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000021-0001-0001-0000-000000000002',
    '00000021-0001-0000-0000-000000000002',
    1,
    'One team bats while the other team plays in the field. What is the batting team trying to do?',
    '["Catch the ball", "Strike out the other players", "Hit the ball and score runs", "Throw the ball as far as possible"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What does the fielding team try to do?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000021-0001-0000-0000-000000000003',
    '00000002-0000-0000-0000-000000000001',
    'mcq',
    'The fielding team spreads out across the field. What are they trying to do?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000021-0001-0001-0000-000000000003',
    '00000021-0001-0000-0000-000000000003',
    1,
    'The fielding team spreads out across the field. What are they trying to do?',
    '["Get the batting team''s players out and prevent runs", "Score more runs than the batting team", "Hit the ball back to the batters", "Run around the bases"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: How many innings in a standard game?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000021-0001-0000-0000-000000000004',
    '00000002-0000-0000-0000-000000000001',
    'mcq',
    'A baseball game is divided into sections called "innings." How many innings are in a standard professional baseball game?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000021-0001-0001-0000-000000000004',
    '00000021-0001-0000-0000-000000000004',
    1,
    'A baseball game is divided into sections called "innings." How many innings are in a standard professional baseball game?',
    '["4 innings", "7 innings", "9 innings", "12 innings"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: Teams switch - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000021-0001-0000-0000-000000000005',
    '00000002-0000-0000-0000-000000000001',
    'binary',
    'In baseball, the two teams take turns batting and fielding during each inning.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000021-0001-0001-0000-000000000005',
    '00000021-0001-0000-0000-000000000005',
    1,
    'In baseball, the two teams take turns batting and fielding during each inning.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: How do you win?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000021-0001-0000-0000-000000000006',
    '00000002-0000-0000-0000-000000000001',
    'mcq',
    'How does a team win a baseball game?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000021-0001-0001-0000-000000000006',
    '00000021-0001-0000-0000-000000000006',
    1,
    'How does a team win a baseball game?',
    '["By hitting the most home runs", "By scoring more runs than the other team", "By getting the most hits", "By playing the most innings"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: What is a run?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000021-0001-0000-0000-000000000007',
    '00000002-0000-0000-0000-000000000001',
    'mcq',
    'In baseball, a "run" is a point. How does a player score a run?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000021-0001-0001-0000-000000000007',
    '00000021-0001-0000-0000-000000000007',
    1,
    'In baseball, a "run" is a point. How does a player score a run?',
    '["By hitting the ball", "By catching the ball", "By running around all the bases and touching home plate", "By throwing the ball to a teammate"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: How many outs in a half-inning?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000021-0001-0000-0000-000000000008',
    '00000002-0000-0000-0000-000000000001',
    'mcq',
    'Each team bats until they get a certain number of "outs." How many outs does a team get before they switch to fielding?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000021-0001-0001-0000-000000000008',
    '00000021-0001-0000-0000-000000000008',
    1,
    'Each team bats until they get a certain number of "outs." How many outs does a team get before they switch to fielding?',
    '["1 out", "2 outs", "3 outs", "4 outs"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Top and bottom of inning
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000021-0001-0000-0000-000000000009',
    '00000002-0000-0000-0000-000000000001',
    'mcq',
    'Each inning has two halves: the "top" and the "bottom." What happens during each half?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000021-0001-0001-0000-000000000009',
    '00000021-0001-0000-0000-000000000009',
    1,
    'Each inning has two halves: the "top" and the "bottom." What happens during each half?',
    '["Both teams bat at the same time", "One team bats while the other fields, then they switch", "The teams take a break", "The game clock runs down"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'GB1 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000002-0000-0000-0000-000000000001'

UNION ALL

SELECT
    'GB1 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000002-0000-0000-0000-000000000001';
