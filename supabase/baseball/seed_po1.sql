-- ============================================================================
-- PO1 (Positions 1) - Baseball Seed Data
-- ============================================================================
-- PO1 is the SEVENTH lesson (after AB2)
-- PO1 covers: Pitcher, catcher, infielders (1B, 2B, SS, 3B)
--
-- Prerequisites: GB1-AB2 (field layout, batting, positions mentioned)
-- Terms INTRODUCED here: pitcher, catcher, first baseman, second baseman,
--                        shortstop, third baseman, battery
--
-- Structure:
-- - PO1 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create PO1 Lesson (ORDER: 7)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-000000000007',
    '22222222-2222-2222-2222-222222222222',
    'Positions 1',
    'Learn about the pitcher, catcher, and infield positions.',
    7,
    4,
    50,
    true,
    'PO1',
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
-- STEP 5: Create PO1 Items (9 questions)
-- ============================================================================

-- Q1: What does the pitcher do?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000001',
    '00000002-0000-0000-0000-000000000007',
    'mcq',
    'What is the pitcher''s main job?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000001',
    '00000027-0001-0000-0000-000000000001',
    1,
    'What is the pitcher''s main job?',
    '["To hit the ball", "To throw the ball to the batter and try to get them out", "To catch fly balls in the outfield", "To run the bases"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: What does the catcher do?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000002',
    '00000002-0000-0000-0000-000000000007',
    'mcq',
    'The catcher wears special protective gear. Where do they position themselves?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000002',
    '00000027-0001-0000-0000-000000000002',
    1,
    'The catcher wears special protective gear. Where do they position themselves?',
    '["Behind home plate, facing the pitcher", "On the pitcher''s mound", "In the outfield", "On first base"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What is the battery?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000003',
    '00000002-0000-0000-0000-000000000007',
    'mcq',
    'The pitcher and catcher together are called the "battery." Why are they called this?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000003',
    '00000027-0001-0000-0000-000000000003',
    1,
    'The pitcher and catcher together are called the "battery." Why are they called this?',
    '["They wear the most equipment", "They score the most runs", "They work together as a team within the team, communicating on every pitch", "They hit the hardest"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: First baseman position
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000004',
    '00000002-0000-0000-0000-000000000007',
    'mcq',
    'Where does the first baseman typically stand?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000004',
    '00000027-0001-0000-0000-000000000004',
    1,
    'Where does the first baseman typically stand?',
    '["Behind second base", "Near first base", "Behind home plate", "In center field"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: Shortstop position
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000005',
    '00000002-0000-0000-0000-000000000007',
    'mcq',
    'The shortstop plays between which two bases?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000005',
    '00000027-0001-0000-0000-000000000005',
    1,
    'The shortstop plays between which two bases?',
    '["Second base and third base", "First base and second base", "Home plate and first base", "Third base and home plate"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: How many infielders?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000006',
    '00000002-0000-0000-0000-000000000007',
    'mcq',
    'Not counting the pitcher and catcher, how many infielders are there?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000006',
    '00000027-0001-0000-0000-000000000006',
    1,
    'Not counting the pitcher and catcher, how many infielders are there?',
    '["2 (first and third baseman)", "3 (three basemen)", "4 (first baseman, second baseman, shortstop, third baseman)", "5 (four basemen plus shortstop)"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Second baseman position
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000007',
    '00000002-0000-0000-0000-000000000007',
    'mcq',
    'The second baseman plays between which two bases?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000007',
    '00000027-0001-0000-0000-000000000007',
    1,
    'The second baseman plays between which two bases?',
    '["Second base and third base", "First base and second base", "Home plate and first base", "Third base and home plate"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Third baseman nickname
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000008',
    '00000002-0000-0000-0000-000000000007',
    'mcq',
    'Third base is often called the "hot corner." Why?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000008',
    '00000027-0001-0000-0000-000000000008',
    1,
    'Third base is often called the "hot corner." Why?',
    '["The sun shines there most", "It''s closest to the dugout", "Hard-hit balls come at the third baseman very fast", "It''s the hottest spot temperature-wise"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Total fielders
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000009',
    '00000002-0000-0000-0000-000000000007',
    'binary',
    'There are 9 defensive players on the field at one time.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000009',
    '00000027-0001-0000-0000-000000000009',
    1,
    'There are 9 defensive players on the field at one time.',
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
    'PO1 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000002-0000-0000-0000-000000000007'

UNION ALL

SELECT
    'PO1 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000002-0000-0000-0000-000000000007';
