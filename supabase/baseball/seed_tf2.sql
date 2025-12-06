-- ============================================================================
-- TF2 (The Field 2) - Baseball Seed Data
-- ============================================================================
-- TF2 is the THIRD lesson (after TF1)
-- TF2 covers: Foul lines, fair/foul territory, pitcher's mound, batter's box
--
-- Prerequisites: GB1, TF1 (diamond, bases, infield/outfield)
-- Terms INTRODUCED here: foul lines, fair territory, foul territory,
--                        pitcher's mound, batter's box, dugout
--
-- Structure:
-- - TF2 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create TF2 Lesson (ORDER: 3)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-000000000003',
    '22222222-2222-2222-2222-222222222222',
    'The Field 2',
    'Learn about foul lines, the pitcher''s mound, and other key field features.',
    3,
    4,
    50,
    true,
    'TF2',
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
-- STEP 5: Create TF2 Items (9 questions)
-- ============================================================================

-- Q1: What are foul lines?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000023-0001-0000-0000-000000000001',
    '00000002-0000-0000-0000-000000000003',
    'mcq',
    'Two white lines extend from home plate down the first and third base sides. What are these lines called?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000023-0001-0001-0000-000000000001',
    '00000023-0001-0000-0000-000000000001',
    1,
    'Two white lines extend from home plate down the first and third base sides. What are these lines called?',
    '["Base lines", "Boundary lines", "Foul lines", "Fair lines"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: Fair vs foul territory
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000023-0001-0000-0000-000000000002',
    '00000002-0000-0000-0000-000000000003',
    'mcq',
    'The area between the two foul lines (where the bases are) is called "fair territory." What is the area outside the foul lines called?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000023-0001-0001-0000-000000000002',
    '00000023-0001-0000-0000-000000000002',
    1,
    'The area between the two foul lines (where the bases are) is called "fair territory." What is the area outside the foul lines called?',
    '["Out territory", "Foul territory", "Dead territory", "Side territory"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: Where is the pitcher's mound?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000023-0001-0000-0000-000000000003',
    '00000002-0000-0000-0000-000000000003',
    'mcq',
    'The pitcher throws from a raised dirt area called the "pitcher''s mound." Where is it located?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000023-0001-0001-0000-000000000003',
    '00000023-0001-0000-0000-000000000003',
    1,
    'The pitcher throws from a raised dirt area called the "pitcher''s mound." Where is it located?',
    '["In the center of the diamond, between home plate and second base", "Behind home plate", "Next to first base", "In the outfield"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: Pitcher's mound is raised - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000023-0001-0000-0000-000000000004',
    '00000002-0000-0000-0000-000000000003',
    'binary',
    'The pitcher''s mound is raised higher than the rest of the field.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000023-0001-0001-0000-000000000004',
    '00000023-0001-0000-0000-000000000004',
    1,
    'The pitcher''s mound is raised higher than the rest of the field.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: What is the batter's box?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000023-0001-0000-0000-000000000005',
    '00000002-0000-0000-0000-000000000003',
    'mcq',
    'On each side of home plate, there is a rectangle drawn in the dirt called the "batter''s box." What is it for?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000023-0001-0001-0000-000000000005',
    '00000023-0001-0000-0000-000000000005',
    1,
    'On each side of home plate, there is a rectangle drawn in the dirt called the "batter''s box." What is it for?',
    '["Where the catcher sits", "Where the umpire stands", "Where the batter must stand while batting", "Where runners wait"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: What is the dugout?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000023-0001-0000-0000-000000000006',
    '00000002-0000-0000-0000-000000000003',
    'mcq',
    'The "dugout" is a sheltered area along each baseline. Who sits there?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000023-0001-0001-0000-000000000006',
    '00000023-0001-0000-0000-000000000006',
    1,
    'The "dugout" is a sheltered area along each baseline. Who sits there?',
    '["Fans who have special tickets", "Players and coaches who are not currently on the field", "The umpires", "Security guards"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Distance from mound to home plate
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000023-0001-0000-0000-000000000007',
    '00000002-0000-0000-0000-000000000003',
    'mcq',
    'How far is the pitcher''s mound from home plate in professional baseball?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000023-0001-0001-0000-000000000007',
    '00000023-0001-0000-0000-000000000007',
    1,
    'How far is the pitcher''s mound from home plate in professional baseball?',
    '["45 feet", "60 feet, 6 inches", "75 feet", "90 feet"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: What happens if a ball lands in foul territory?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000023-0001-0000-0000-000000000008',
    '00000002-0000-0000-0000-000000000003',
    'mcq',
    'If a batted ball lands in foul territory (outside the foul lines), what happens?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000023-0001-0001-0000-000000000008',
    '00000023-0001-0000-0000-000000000008',
    1,
    'If a batted ball lands in foul territory (outside the foul lines), what happens?',
    '["It is called a foul ball and typically counts as a strike", "The batter is automatically out", "It counts as a hit", "The batter gets to run to first base"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Where do batters wait for their turn?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000023-0001-0000-0000-000000000009',
    '00000002-0000-0000-0000-000000000003',
    'mcq',
    'The "on-deck circle" is a marked area near the dugout. What is it used for?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000023-0001-0001-0000-000000000009',
    '00000023-0001-0000-0000-000000000009',
    1,
    'The "on-deck circle" is a marked area near the dugout. What is it used for?',
    '["Where pitchers warm up", "Where coaches give signals", "Where the next batter waits and warms up", "Where injured players recover"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'TF2 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000002-0000-0000-0000-000000000003'

UNION ALL

SELECT
    'TF2 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000002-0000-0000-0000-000000000003';
