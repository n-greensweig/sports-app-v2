-- ============================================================================
-- PL1 (Plays 1) - Baseball Seed Data
-- ============================================================================
-- PL1 is the NINTH lesson (after PO2)
-- PL1 covers: Ways to get outs - force outs, tag outs, fly outs, ground outs
--
-- Prerequisites: GB1-PO2 (outs, bases, positions)
-- Terms INTRODUCED here: force out, tag out, fly out, ground out, pop fly
--
-- Structure:
-- - PL1 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create PL1 Lesson (ORDER: 9)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-000000000009',
    '22222222-2222-2222-2222-222222222222',
    'Plays 1',
    'Learn the different ways to get batters and runners out.',
    9,
    4,
    50,
    true,
    'PL1',
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
-- STEP 5: Create PL1 Items (9 questions)
-- ============================================================================

-- Q1: What is a fly out?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000029-0001-0000-0000-000000000001',
    '00000002-0000-0000-0000-000000000009',
    'mcq',
    'What is a "fly out"?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000029-0001-0001-0000-000000000001',
    '00000029-0001-0000-0000-000000000001',
    1,
    'What is a "fly out"?',
    '["When a runner is tagged out", "When a fielder catches a hit ball in the air before it touches the ground", "When a batter strikes out", "When a ball goes over the fence"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: What is a ground out?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000029-0001-0000-0000-000000000002',
    '00000002-0000-0000-0000-000000000009',
    'mcq',
    'What is a "ground out"?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000029-0001-0001-0000-000000000002',
    '00000029-0001-0000-0000-000000000002',
    1,
    'What is a "ground out"?',
    '["When a batter hits the ball on the ground and is thrown out at first base", "When the ball hits the ground in foul territory", "When a runner falls down", "When the pitcher throws the ball into the dirt"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What is a force out?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000029-0001-0000-0000-000000000003',
    '00000002-0000-0000-0000-000000000009',
    'mcq',
    'What is a "force out"?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000029-0001-0001-0000-000000000003',
    '00000029-0001-0000-0000-000000000003',
    1,
    'What is a "force out"?',
    '["When a fielder pushes a runner", "When the batter is forced to swing", "When a fielder touches the base before a runner who must advance reaches it", "When the pitcher throws very hard"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: When is there a force situation?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000029-0001-0000-0000-000000000004',
    '00000002-0000-0000-0000-000000000009',
    'mcq',
    'A runner is "forced" to run to the next base when:',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000029-0001-0001-0000-000000000004',
    '00000029-0001-0000-0000-000000000004',
    1,
    'A runner is "forced" to run to the next base when:',
    '["They want to score", "Another runner or the batter is coming to their base, so they must advance", "The coach tells them to", "They see a fly ball"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: What is a tag out?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000029-0001-0000-0000-000000000005',
    '00000002-0000-0000-0000-000000000009',
    'mcq',
    'What is a "tag out"?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000029-0001-0001-0000-000000000005',
    '00000029-0001-0000-0000-000000000005',
    1,
    'What is a "tag out"?',
    '["When a fielder touches a runner with the ball (or glove holding the ball) while the runner is not on a base", "When a fielder calls out the runner''s name", "When the umpire tags the runner", "When a runner touches a base"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Batter always forced to first - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000029-0001-0000-0000-000000000006',
    '00000002-0000-0000-0000-000000000009',
    'binary',
    'After hitting a fair ball, the batter is always "forced" to run to first base.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000029-0001-0001-0000-000000000006',
    '00000029-0001-0000-0000-000000000006',
    1,
    'After hitting a fair ball, the batter is always "forced" to run to first base.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Pop fly
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000029-0001-0000-0000-000000000007',
    '00000002-0000-0000-0000-000000000009',
    'mcq',
    'A "pop fly" is a ball hit:',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000029-0001-0001-0000-000000000007',
    '00000029-0001-0000-0000-000000000007',
    1,
    'A "pop fly" is a ball hit:',
    '["Along the ground", "High in the air, usually in the infield", "Over the outfield fence", "Into the dugout"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Line drive
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000029-0001-0000-0000-000000000008',
    '00000002-0000-0000-0000-000000000009',
    'mcq',
    'A "line drive" is a ball hit:',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000029-0001-0001-0000-000000000008',
    '00000029-0001-0000-0000-000000000008',
    1,
    'A "line drive" is a ball hit:',
    '["Along the ground slowly", "High in the air", "Hard and straight through the air, roughly parallel to the ground", "Backwards behind home plate"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Caught fly ball = out
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000029-0001-0000-0000-000000000009',
    '00000002-0000-0000-0000-000000000009',
    'mcq',
    'If a fly ball is caught, what happens to runners already on base?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000029-0001-0001-0000-000000000009',
    '00000029-0001-0000-0000-000000000009',
    1,
    'If a fly ball is caught, what happens to runners already on base?',
    '["They are automatically out", "They must return to their base (or ''tag up'') before trying to advance", "They can run freely to the next base", "The inning ends immediately"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'PL1 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000002-0000-0000-0000-000000000009'

UNION ALL

SELECT
    'PL1 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000002-0000-0000-0000-000000000009';
