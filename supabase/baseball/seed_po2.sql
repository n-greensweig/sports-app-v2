-- ============================================================================
-- PO2 (Positions 2) - Baseball Seed Data
-- ============================================================================
-- PO2 is the EIGHTH lesson (after PO1)
-- PO2 covers: Outfielders (LF, CF, RF), designated hitter (DH)
--
-- Prerequisites: GB1-PO1 (infield positions, defensive positions)
-- Terms INTRODUCED here: left fielder, center fielder, right fielder,
--                        outfielder, designated hitter (DH)
--
-- Structure:
-- - PO2 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create PO2 Lesson (ORDER: 8)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-000000000008',
    '22222222-2222-2222-2222-222222222222',
    'Positions 2',
    'Learn about the outfield positions and the designated hitter.',
    8,
    4,
    50,
    true,
    'PO2',
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
-- STEP 5: Create PO2 Items (9 questions)
-- ============================================================================

-- Q1: How many outfielders?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000028-0001-0000-0000-000000000001',
    '00000002-0000-0000-0000-000000000008',
    'mcq',
    'How many outfielders are on the field?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000028-0001-0001-0000-000000000001',
    '00000028-0001-0000-0000-000000000001',
    1,
    'How many outfielders are on the field?',
    '["1", "2", "3", "4"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: Names of outfield positions
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000028-0001-0000-0000-000000000002',
    '00000002-0000-0000-0000-000000000008',
    'mcq',
    'What are the three outfield positions called?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000028-0001-0001-0000-000000000002',
    '00000028-0001-0000-0000-000000000002',
    1,
    'What are the three outfield positions called?',
    '["Left fielder, center fielder, right fielder", "Front fielder, back fielder, side fielder", "Near fielder, far fielder, middle fielder", "First fielder, second fielder, third fielder"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: Center fielder coverage
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000028-0001-0000-0000-000000000003',
    '00000002-0000-0000-0000-000000000008',
    'mcq',
    'The center fielder typically covers the largest area. Why is this position important?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000028-0001-0001-0000-000000000003',
    '00000028-0001-0000-0000-000000000003',
    1,
    'The center fielder typically covers the largest area. Why is this position important?',
    '["They hit the most home runs", "They need speed and good judgment to cover lots of ground and catch fly balls", "They throw the most pitches", "They are closest to the dugout"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: Left vs right field perspective
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000028-0001-0000-0000-000000000004',
    '00000002-0000-0000-0000-000000000008',
    'mcq',
    'Left field and right field are named from whose perspective?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000028-0001-0001-0000-000000000004',
    '00000028-0001-0000-0000-000000000004',
    1,
    'Left field and right field are named from whose perspective?',
    '["From the pitcher''s view", "From the fans'' view", "From the batter''s or catcher''s view (looking out at the field)", "From the outfielder''s view"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: What is the DH?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000028-0001-0000-0000-000000000005',
    '00000002-0000-0000-0000-000000000008',
    'mcq',
    'What is a "designated hitter" (DH)?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000028-0001-0001-0000-000000000005',
    '00000028-0001-0000-0000-000000000005',
    1,
    'What is a "designated hitter" (DH)?',
    '["A player who only plays defense", "A player who bats in place of the pitcher but doesn''t play defense", "The team''s best hitter who bats first", "A backup player"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: DH plays defense - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000028-0001-0000-0000-000000000006',
    '00000002-0000-0000-0000-000000000008',
    'binary',
    'The designated hitter (DH) plays a defensive position in the field.',
    '{"correct_boolean": false}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000028-0001-0001-0000-000000000006',
    '00000028-0001-0000-0000-000000000006',
    1,
    'The designated hitter (DH) plays a defensive position in the field.',
    '["True", "False"]',
    '{"boolean": false}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Outfielder main job
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000028-0001-0000-0000-000000000007',
    '00000002-0000-0000-0000-000000000008',
    'mcq',
    'What is the main job of an outfielder?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000028-0001-0001-0000-000000000007',
    '00000028-0001-0000-0000-000000000007',
    1,
    'What is the main job of an outfielder?',
    '["Catch fly balls and field hits that get past the infield", "Pitch to the batters", "Call the plays", "Guard the bases"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Right fielder arm strength
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000028-0001-0000-0000-000000000008',
    '00000002-0000-0000-0000-000000000008',
    'mcq',
    'Right fielders often need strong throwing arms. Why?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000028-0001-0001-0000-000000000008',
    '00000028-0001-0000-0000-000000000008',
    1,
    'Right fielders often need strong throwing arms. Why?',
    '["They throw the most pitches", "They are farthest from home plate", "They have the longest throw to third base to prevent runners from advancing", "They need to throw to the pitcher"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Total defensive positions
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000028-0001-0000-0000-000000000009',
    '00000002-0000-0000-0000-000000000008',
    'mcq',
    'Including all positions (pitcher, catcher, infielders, outfielders), how many defensive positions are there?',
    '{"correct_index": 3}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000028-0001-0001-0000-000000000009',
    '00000028-0001-0000-0000-000000000009',
    1,
    'Including all positions (pitcher, catcher, infielders, outfielders), how many defensive positions are there?',
    '["6", "7", "8", "9"]',
    '{"index": 3}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'PO2 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000002-0000-0000-0000-000000000008'

UNION ALL

SELECT
    'PO2 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000002-0000-0000-0000-000000000008';
