-- ============================================================================
-- Rookie Positions Quiz - Seed Data
-- ============================================================================
-- This quiz comes after DP2 (lesson 14) and tests positions lessons OP1-DP2
-- Contains 10 questions about offensive and defensive positions
--
-- ORDER: 24
-- Type: Quiz
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
-- STEP 4: Create Rookie Positions Quiz (ORDER: 24)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000024',
    '11111111-1111-1111-1111-111111111111',
    'Rookie Positions Quiz',
    'Test your knowledge of offensive and defensive positions!',
    24,
    5,
    75,
    true,
    'QZ2',
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
-- STEP 5: Create Quiz Items (10 questions from OP1-DP2)
-- ============================================================================

-- Q1: From OP1 - Quarterback role
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000024-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000024',
    'mcq',
    'What is the quarterback''s main job on the offense?',
    '{"correct_index": 0}',
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
    'What is the quarterback''s main job on the offense?',
    '["To throw passes and hand off the ball to teammates", "To catch passes", "To kick field goals", "To tackle the other team"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: From OP1 - Running back role
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000024-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000024',
    'mcq',
    'What does a running back usually do on a run play?',
    '{"correct_index": 1}',
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
    'What does a running back usually do on a run play?',
    '["Throws the ball to teammates", "Takes a handoff and runs with the ball", "Kicks field goals", "Blocks for the quarterback"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: From OP2 - Wide receiver role
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000024-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000024',
    'mcq',
    'What is a wide receiver''s main job?',
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
    'What is a wide receiver''s main job?',
    '["To throw passes", "To tackle runners", "To run down the field and catch passes from the quarterback", "To kick the ball"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: From OP2 - Tight end versatility
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000024-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000024',
    'binary',
    'A tight end can both catch passes and block for teammates.',
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
    'A tight end can both catch passes and block for teammates.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: From DP1 - Defensive line
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000024-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000024',
    'mcq',
    'What does the defensive line try to do?',
    '{"correct_index": 0}',
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
    'What does the defensive line try to do?',
    '["Stop runs and rush the quarterback", "Catch passes", "Throw the ball", "Kick field goals"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: From DP1 - Linebacker position
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000024-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000024',
    'mcq',
    'Where do linebackers line up on the field?',
    '{"correct_index": 1}',
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
    'Where do linebackers line up on the field?',
    '["Right at the line of scrimmage", "Behind the defensive line", "In the end zone", "On the sideline"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: From DP2 - Cornerback role
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000024-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000024',
    'mcq',
    'What is a cornerback''s main job on defense?',
    '{"correct_index": 2}',
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
    'What is a cornerback''s main job on defense?',
    '["To rush the quarterback", "To stop the running back", "To cover wide receivers and prevent them from catching passes", "To kick the ball"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: From DP2 - Safety position
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000024-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000024',
    'binary',
    'Safeties are positioned deep in the backfield and help stop long passes.',
    '{"correct_boolean": true}',
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
    'Safeties are positioned deep in the backfield and help stop long passes.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Abbreviations
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000024-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000024',
    'mcq',
    'What do the abbreviations QB, RB, WR, and TE stand for?',
    '{"correct_index": 0}',
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
    'What do the abbreviations QB, RB, WR, and TE stand for?',
    '["Quarterback, Running Back, Wide Receiver, Tight End", "Quick Ball, Right Back, Wing Runner, Tackle Expert", "Quarter Boss, Rush Blocker, Wide Rusher, Team Expert", "None of the above"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q10: Situational - who caught the pass?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000024-0001-0000-0000-000000000010',
    '00000001-0000-0000-0000-000000000024',
    'mcq',
    'The quarterback throws a long pass down the sideline and a player catches it for a touchdown. Which position most likely made the catch?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000024-0001-0001-0000-000000000010',
    '00000024-0001-0000-0000-000000000010',
    1,
    'The quarterback throws a long pass down the sideline and a player catches it for a touchdown. Which position most likely made the catch?',
    '["Running Back", "Wide Receiver", "Linebacker", "Defensive Lineman"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'Rookie Positions Quiz' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000024'

UNION ALL

SELECT
    'Quiz Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000024';
