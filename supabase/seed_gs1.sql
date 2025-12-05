-- ============================================================================
-- GS1 (Game Structure 1) - Seed Data
-- ============================================================================
-- GS1 is the TWENTY-SECOND lesson (ORDER: 22, after QZ3)
-- GS1 covers: Quarters, halftime, game clock basics
--
-- Prerequisites: Basic scoring knowledge
-- Terms INTRODUCED here: Quarter, halftime, game clock
--
-- Can reference: Scoring, touchdowns, field goals, offense, defense
--
-- Structure:
-- - GS1 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create GS1 Lesson (ORDER: 22)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000019',
    '11111111-1111-1111-1111-111111111111',
    'Game Structure 1',
    'Learn how a football game is organized into quarters and halves.',
    22,
    4,
    50,
    true,
    'GS1',
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
-- STEP 5: Create GS1 Items (9 questions - quarters, halftime, game clock)
-- ============================================================================

-- Q1: How many quarters?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000019-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000019',
    'mcq',
    'How many quarters are in a football game?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000019-0001-0001-0000-000000000001',
    '00000019-0001-0000-0000-000000000001',
    1,
    'How many quarters are in a football game?',
    '["2 quarters", "3 quarters", "4 quarters", "5 quarters"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: How long is each quarter?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000019-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000019',
    'mcq',
    'In the NFL, how long is each quarter?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000019-0001-0001-0000-000000000002',
    '00000019-0001-0000-0000-000000000002',
    1,
    'In the NFL, how long is each quarter?',
    '["10 minutes", "15 minutes", "20 minutes", "30 minutes"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What is halftime?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000019-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000019',
    'mcq',
    'What is halftime in football?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000019-0001-0001-0000-000000000003',
    '00000019-0001-0000-0000-000000000003',
    1,
    'What is halftime in football?',
    '["A longer break between the 2nd and 3rd quarters when teams rest and make adjustments", "A penalty for taking too long", "The end of the game", "A timeout called by the coach"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: When is halftime?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000019-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000019',
    'mcq',
    'Between which quarters does halftime occur?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000019-0001-0001-0000-000000000004',
    '00000019-0001-0000-0000-000000000004',
    1,
    'Between which quarters does halftime occur?',
    '["Between the 1st and 2nd quarters", "Between the 2nd and 3rd quarters", "Between the 3rd and 4th quarters", "After the 4th quarter"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: What is the game clock?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000019-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000019',
    'mcq',
    'What does the game clock show?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000019-0001-0001-0000-000000000005',
    '00000019-0001-0000-0000-000000000005',
    1,
    'What does the game clock show?',
    '["The current score", "The number of yards gained", "How much time is left in the current quarter", "The number of touchdowns"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Switch sides - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000019-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000019',
    'binary',
    'Teams switch which end zone they are defending at halftime.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000019-0001-0001-0000-000000000006',
    '00000019-0001-0000-0000-000000000006',
    1,
    'Teams switch which end zone they are defending at halftime.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Clock counts down - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000019-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000019',
    'binary',
    'The game clock counts down from 15 minutes to 0 in each quarter.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000019-0001-0001-0000-000000000007',
    '00000019-0001-0000-0000-000000000007',
    1,
    'The game clock counts down from 15 minutes to 0 in each quarter.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: First and second half
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000019-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000019',
    'mcq',
    'Which quarters make up the first half of a football game?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000019-0001-0001-0000-000000000008',
    '00000019-0001-0000-0000-000000000008',
    1,
    'Which quarters make up the first half of a football game?',
    '["The 1st and 2nd quarters", "The 2nd and 3rd quarters", "The 3rd and 4th quarters", "Only the 1st quarter"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Total game time calculation
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000019-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000019',
    'mcq',
    'If each quarter is 15 minutes and there are 4 quarters, how much total game clock time is there in a regulation football game?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000019-0001-0001-0000-000000000009',
    '00000019-0001-0000-0000-000000000009',
    1,
    'If each quarter is 15 minutes and there are 4 quarters, how much total game clock time is there in a regulation football game?',
    '["30 minutes", "45 minutes", "60 minutes (1 hour)", "90 minutes"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'GS1 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000019'

UNION ALL

SELECT
    'GS1 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000019';
