-- ============================================================================
-- TF1 (The Field 1) - Baseball Seed Data
-- ============================================================================
-- TF1 is the SECOND lesson (after GB1)
-- TF1 covers: Diamond shape, 4 bases, infield/outfield basics
--
-- Prerequisites: GB1 (batting team, fielding team, runs, innings, outs)
-- Terms INTRODUCED here: diamond, bases, first/second/third base, home plate,
--                        infield, outfield
--
-- Structure:
-- - TF1 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create TF1 Lesson (ORDER: 2)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-000000000002',
    '22222222-2222-2222-2222-222222222222',
    'The Field 1',
    'Learn the layout of a baseball field - the diamond, bases, and key areas.',
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
-- STEP 5: Create TF1 Items (9 questions)
-- ============================================================================

-- Q1: Shape of the infield
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000022-0001-0000-0000-000000000001',
    '00000002-0000-0000-0000-000000000002',
    'mcq',
    'The inner part of a baseball field is called the "infield." What shape is the infield?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000022-0001-0001-0000-000000000001',
    '00000022-0001-0000-0000-000000000001',
    1,
    'The inner part of a baseball field is called the "infield." What shape is the infield?',
    '["A circle", "A diamond (square tilted on its corner)", "A rectangle", "A triangle"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: How many bases?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000022-0001-0000-0000-000000000002',
    '00000002-0000-0000-0000-000000000002',
    'mcq',
    'How many bases are there on a baseball field?',
    '{"correct_index": 3}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000022-0001-0001-0000-000000000002',
    '00000022-0001-0000-0000-000000000002',
    1,
    'How many bases are there on a baseball field?',
    '["2 bases", "3 bases", "5 bases", "4 bases (including home plate)"]',
    '{"index": 3}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What is home plate?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000022-0001-0000-0000-000000000003',
    '00000002-0000-0000-0000-000000000002',
    'mcq',
    'What is "home plate" in baseball?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000022-0001-0001-0000-000000000003',
    '00000022-0001-0000-0000-000000000003',
    1,
    'What is "home plate" in baseball?',
    '["Where the pitcher stands", "A place to eat during the game", "Where the batter stands and where runners finish to score", "The center of the outfield"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: Order of bases
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000022-0001-0000-0000-000000000004',
    '00000002-0000-0000-0000-000000000002',
    'mcq',
    'A runner starts at home plate. In what order do they run around the bases?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000022-0001-0001-0000-000000000004',
    '00000022-0001-0000-0000-000000000004',
    1,
    'A runner starts at home plate. In what order do they run around the bases?',
    '["First base → Second base → Third base → Home plate", "Third base → Second base → First base → Home plate", "Second base → First base → Third base → Home plate", "Home plate → Third base → First base → Second base"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: Runners go counterclockwise - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000022-0001-0000-0000-000000000005',
    '00000002-0000-0000-0000-000000000002',
    'binary',
    'Runners move around the bases in a counterclockwise direction (turning left from home plate).',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000022-0001-0001-0000-000000000005',
    '00000022-0001-0000-0000-000000000005',
    1,
    'Runners move around the bases in a counterclockwise direction (turning left from home plate).',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: What is the outfield?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000022-0001-0000-0000-000000000006',
    '00000002-0000-0000-0000-000000000002',
    'mcq',
    'The "outfield" is the large grassy area beyond the infield. Where is it located?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000022-0001-0001-0000-000000000006',
    '00000022-0001-0000-0000-000000000006',
    1,
    'The "outfield" is the large grassy area beyond the infield. Where is it located?',
    '["Between home plate and first base", "Beyond the bases, stretching to the outfield wall", "Behind home plate", "Inside the diamond"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Distance between bases
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000022-0001-0000-0000-000000000007',
    '00000002-0000-0000-0000-000000000002',
    'mcq',
    'In professional baseball, how far apart are the bases?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000022-0001-0001-0000-000000000007',
    '00000022-0001-0000-0000-000000000007',
    1,
    'In professional baseball, how far apart are the bases?',
    '["45 feet", "60 feet", "90 feet", "120 feet"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: What are the corners of the diamond?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000022-0001-0000-0000-000000000008',
    '00000002-0000-0000-0000-000000000002',
    'mcq',
    'The four corners of the baseball diamond are marked by:',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000022-0001-0001-0000-000000000008',
    '00000022-0001-0000-0000-000000000008',
    1,
    'The four corners of the baseball diamond are marked by:',
    '["Home plate, first base, second base, and third base", "Four flags", "Four pitching mounds", "Four dugouts"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Infield surface
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000022-0001-0000-0000-000000000009',
    '00000002-0000-0000-0000-000000000002',
    'mcq',
    'What surface is the infield typically made of in professional baseball?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000022-0001-0001-0000-000000000009',
    '00000022-0001-0000-0000-000000000009',
    1,
    'What surface is the infield typically made of in professional baseball?',
    '["Only grass", "Mostly dirt with some grass", "Concrete", "Rubber turf"]',
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
WHERE id = '00000002-0000-0000-0000-000000000002'

UNION ALL

SELECT
    'TF1 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000002-0000-0000-0000-000000000002';
