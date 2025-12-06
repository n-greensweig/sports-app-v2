-- ============================================================================
-- SC1 (Scoring 1) - Baseball Seed Data
-- ============================================================================
-- SC1 is the FOURTH lesson (after TF2)
-- SC1 covers: Runs (detailed), how to score, RBIs, home runs
--
-- Prerequisites: GB1, TF1, TF2 (runs concept, bases, home plate)
-- Terms INTRODUCED here: run (detailed), RBI, home run, grand slam
--
-- Structure:
-- - SC1 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create SC1 Lesson (ORDER: 4)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-000000000004',
    '22222222-2222-2222-2222-222222222222',
    'Scoring 1',
    'Learn how runs are scored, what home runs are, and basic scoring concepts.',
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
-- STEP 5: Create SC1 Items (9 questions)
-- ============================================================================

-- Q1: How to score a run
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000024-0001-0000-0000-000000000001',
    '00000002-0000-0000-0000-000000000004',
    'mcq',
    'How does a player score a run in baseball?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000024-0001-0001-0000-000000000001',
    '00000024-0001-0000-0000-000000000001',
    1,
    'How does a player score a run in baseball?',
    '["By hitting the ball", "By touching all the bases and returning to home plate safely", "By catching a fly ball", "By throwing out a runner"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: How many points is a run worth?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000024-0001-0000-0000-000000000002',
    '00000002-0000-0000-0000-000000000004',
    'mcq',
    'In baseball, how much is each run worth?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000024-0001-0001-0000-000000000002',
    '00000024-0001-0000-0000-000000000002',
    1,
    'In baseball, how much is each run worth?',
    '["1 point - all runs are worth the same", "2 points", "It depends on how the run was scored", "3 points for a home run, 1 for regular runs"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What is a home run?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000024-0001-0000-0000-000000000003',
    '00000002-0000-0000-0000-000000000004',
    'mcq',
    'What is a "home run"?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000024-0001-0001-0000-000000000003',
    '00000024-0001-0000-0000-000000000003',
    1,
    'What is a "home run"?',
    '["Running from third base to home plate", "A ball caught by the home team", "A hit that goes over the outfield wall in fair territory, allowing the batter to run all the bases and score", "The first run of the game"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: Home run - batter scores automatically - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000024-0001-0000-0000-000000000004',
    '00000002-0000-0000-0000-000000000004',
    'binary',
    'When a batter hits a home run, they must still run around all the bases to score.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000024-0001-0001-0000-000000000004',
    '00000024-0001-0000-0000-000000000004',
    1,
    'When a batter hits a home run, they must still run around all the bases to score.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: What is an RBI?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000024-0001-0000-0000-000000000005',
    '00000002-0000-0000-0000-000000000004',
    'mcq',
    'RBI stands for "Run Batted In." What does it mean when a batter gets an RBI?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000024-0001-0001-0000-000000000005',
    '00000024-0001-0000-0000-000000000005',
    1,
    'RBI stands for "Run Batted In." What does it mean when a batter gets an RBI?',
    '["The batter scored a run", "The batter''s hit helped a teammate score", "The batter hit a home run", "The batter struck out"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Grand slam
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000024-0001-0000-0000-000000000006',
    '00000002-0000-0000-0000-000000000004',
    'mcq',
    'A "grand slam" is a special type of home run. What makes it a grand slam?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000024-0001-0001-0000-000000000006',
    '00000024-0001-0000-0000-000000000006',
    1,
    'A "grand slam" is a special type of home run. What makes it a grand slam?',
    '["The ball goes extra far", "It''s hit in the final inning", "There are runners on all three bases when the home run is hit, so 4 runs score", "It bounces off the wall"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: How many runs on a grand slam?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000024-0001-0000-0000-000000000007',
    '00000002-0000-0000-0000-000000000004',
    'mcq',
    'What is the maximum number of runs that can score on a single play?',
    '{"correct_index": 3}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000024-0001-0001-0000-000000000007',
    '00000024-0001-0000-0000-000000000007',
    1,
    'What is the maximum number of runs that can score on a single play?',
    '["1 run", "2 runs", "3 runs", "4 runs (a grand slam)"]',
    '{"index": 3}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Runners already on base
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000024-0001-0000-0000-000000000008',
    '00000002-0000-0000-0000-000000000004',
    'mcq',
    'If there is a runner on third base and the batter hits a single, what usually happens?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000024-0001-0001-0000-000000000008',
    '00000024-0001-0000-0000-000000000008',
    1,
    'If there is a runner on third base and the batter hits a single, what usually happens?',
    '["The runner on third scores a run", "The runner on third stays at third", "Both runners are out", "The inning ends"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Must touch home plate
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000024-0001-0000-0000-000000000009',
    '00000002-0000-0000-0000-000000000004',
    'binary',
    'A runner MUST physically touch home plate for the run to count.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000024-0001-0001-0000-000000000009',
    '00000024-0001-0000-0000-000000000009',
    1,
    'A runner MUST physically touch home plate for the run to count.',
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
    'SC1 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000002-0000-0000-0000-000000000004'

UNION ALL

SELECT
    'SC1 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000002-0000-0000-0000-000000000004';
