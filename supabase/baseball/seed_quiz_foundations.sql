-- ============================================================================
-- Baseball Rookie Foundations Quiz - Seed Data
-- ============================================================================
-- This quiz covers all concepts from the Rookie section:
-- GB1, TF1, TF2, SC1, AB1, AB2, PO1, PO2, PL1, PL2
--
-- Prerequisites: All Rookie lessons completed
--
-- Structure:
-- - Quiz (15 questions, 10 shown per session, 3 completions to master)
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
-- STEP 4: Create Rookie Foundations Quiz (ORDER: 11)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-00000000000b',
    '22222222-2222-2222-2222-222222222222',
    'Rookie Foundations Quiz',
    'Test your knowledge of baseball fundamentals! Covers all Rookie lessons.',
    11,
    6,
    100,
    true,
    'RFQ',
    10,
    3
)
ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    code = EXCLUDED.code,
    order_index = EXCLUDED.order_index,
    items_per_session = EXCLUDED.items_per_session,
    required_completions = EXCLUDED.required_completions;


-- ============================================================================
-- STEP 5: Create Quiz Items (15 questions - mixed from all lessons)
-- ============================================================================

-- Q1: Game structure (from GB1)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002b-0001-0000-0000-000000000001',
    '00000002-0000-0000-0000-00000000000b',
    'mcq',
    'How many innings are in a standard professional baseball game?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002b-0001-0001-0000-000000000001',
    '0000002b-0001-0000-0000-000000000001',
    1,
    'How many innings are in a standard professional baseball game?',
    '["6 innings", "7 innings", "9 innings", "10 innings"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: Field layout (from TF1)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002b-0001-0000-0000-000000000002',
    '00000002-0000-0000-0000-00000000000b',
    'mcq',
    'How far apart are the bases in professional baseball?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002b-0001-0001-0000-000000000002',
    '0000002b-0001-0000-0000-000000000002',
    1,
    'How far apart are the bases in professional baseball?',
    '["60 feet", "75 feet", "90 feet", "100 feet"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: Foul territory (from TF2)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002b-0001-0000-0000-000000000003',
    '00000002-0000-0000-0000-00000000000b',
    'mcq',
    'What is "foul territory"?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002b-0001-0001-0000-000000000003',
    '0000002b-0001-0000-0000-000000000003',
    1,
    'What is "foul territory"?',
    '["The area between the bases", "The area outside the foul lines", "The pitcher''s mound", "The dugout area"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: Scoring (from SC1)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002b-0001-0000-0000-000000000004',
    '00000002-0000-0000-0000-00000000000b',
    'mcq',
    'What is the maximum number of runs that can score on a single home run?',
    '{"correct_index": 3}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002b-0001-0001-0000-000000000004',
    '0000002b-0001-0000-0000-000000000004',
    1,
    'What is the maximum number of runs that can score on a single home run?',
    '["1 run", "2 runs", "3 runs", "4 runs (grand slam)"]',
    '{"index": 3}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: Count (from AB1)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002b-0001-0000-0000-000000000005',
    '00000002-0000-0000-0000-00000000000b',
    'mcq',
    'What is a "full count"?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002b-0001-0001-0000-000000000005',
    '0000002b-0001-0000-0000-000000000005',
    1,
    'What is a "full count"?',
    '["2 balls, 2 strikes", "3 balls, 2 strikes", "4 balls, 3 strikes", "0 balls, 0 strikes"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Hits (from AB2)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002b-0001-0000-0000-000000000006',
    '00000002-0000-0000-0000-00000000000b',
    'mcq',
    'What is a "double" in baseball?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002b-0001-0001-0000-000000000006',
    '0000002b-0001-0000-0000-000000000006',
    1,
    'What is a "double" in baseball?',
    '["A hit where the batter reaches second base safely", "Two runs scored", "Two strikeouts", "A hit that bounces twice"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Pitcher/Catcher (from PO1)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002b-0001-0000-0000-000000000007',
    '00000002-0000-0000-0000-00000000000b',
    'mcq',
    'The pitcher and catcher together are called the:',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002b-0001-0001-0000-000000000007',
    '0000002b-0001-0000-0000-000000000007',
    1,
    'The pitcher and catcher together are called the:',
    '["Power duo", "Diamond pair", "Battery", "Throwing team"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Outfielders (from PO2)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002b-0001-0000-0000-000000000008',
    '00000002-0000-0000-0000-00000000000b',
    'mcq',
    'How many outfielders are on the field during a play?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002b-0001-0001-0000-000000000008',
    '0000002b-0001-0000-0000-000000000008',
    1,
    'How many outfielders are on the field during a play?',
    '["2", "4", "3", "5"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Force out (from PL1)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002b-0001-0000-0000-000000000009',
    '00000002-0000-0000-0000-00000000000b',
    'mcq',
    'What is a "force out"?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002b-0001-0001-0000-000000000009',
    '0000002b-0001-0000-0000-000000000009',
    1,
    'What is a "force out"?',
    '["Tagging a runner between bases", "Touching the base before a runner who must advance", "Catching a fly ball", "Striking out a batter"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q10: Double play (from PL2)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002b-0001-0000-0000-000000000010',
    '00000002-0000-0000-0000-00000000000b',
    'mcq',
    'What is a "double play"?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002b-0001-0001-0000-000000000010',
    '0000002b-0001-0000-0000-000000000010',
    1,
    'What is a "double play"?',
    '["Hitting the ball twice", "Scoring two runs", "Getting two outs on one play", "Playing two positions"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q11: Situational - runner on base (mixed concepts)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002b-0001-0000-0000-000000000011',
    '00000002-0000-0000-0000-00000000000b',
    'mcq',
    'The New York Yankees have a runner on second base. The batter hits a single to right field. What most likely happens?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    2
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002b-0001-0001-0000-000000000011',
    '0000002b-0001-0000-0000-000000000011',
    1,
    'The New York Yankees have a runner on second base. The batter hits a single to right field. What most likely happens?',
    '["The runner on second scores and the batter ends up on first", "The runner on second stays at second", "Both runners are out", "The inning ends"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q12: Strikeout and walk (AB1 review)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002b-0001-0000-0000-000000000012',
    '00000002-0000-0000-0000-00000000000b',
    'mcq',
    'How many strikes equal a strikeout, and how many balls equal a walk?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002b-0001-0001-0000-000000000012',
    '0000002b-0001-0000-0000-000000000012',
    1,
    'How many strikes equal a strikeout, and how many balls equal a walk?',
    '["2 strikes, 3 balls", "3 strikes, 4 balls", "4 strikes, 4 balls", "3 strikes, 3 balls"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q13: DH (from PO2)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002b-0001-0000-0000-000000000013',
    '00000002-0000-0000-0000-00000000000b',
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
    '0000002b-0001-0001-0000-000000000013',
    '0000002b-0001-0000-0000-000000000013',
    1,
    'The designated hitter (DH) plays a defensive position in the field.',
    '["True", "False"]',
    '{"boolean": false}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q14: Outs per half inning (GB1 review)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002b-0001-0000-0000-000000000014',
    '00000002-0000-0000-0000-00000000000b',
    'mcq',
    'How many outs does a team get before switching from batting to fielding?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002b-0001-0001-0000-000000000014',
    '0000002b-0001-0000-0000-000000000014',
    1,
    'How many outs does a team get before switching from batting to fielding?',
    '["1 out", "2 outs", "3 outs", "4 outs"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q15: Stolen base (PL2 review)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002b-0001-0000-0000-000000000015',
    '00000002-0000-0000-0000-00000000000b',
    'mcq',
    'What is a "stolen base"?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002b-0001-0001-0000-000000000015',
    '0000002b-0001-0000-0000-000000000015',
    1,
    'What is a "stolen base"?',
    '["Taking the actual base off the field", "Advancing to the next base during a pitch without the batter hitting the ball", "Running the wrong direction", "Hiding at a base"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'Rookie Foundations Quiz' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000002-0000-0000-0000-00000000000b'

UNION ALL

SELECT
    'Quiz Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000002-0000-0000-0000-00000000000b';
