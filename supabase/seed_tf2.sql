-- ============================================================================
-- TF2 (The Field 2) - Seed Data
-- ============================================================================
-- TF2 covers: Goalposts/uprights, hash marks, line of scrimmage, pylons,
--             sidelines, boundary lines - practical knowledge for watching games
--
-- Structure:
-- - TF2 Lesson (13 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create TF2 Lesson
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000002',
    '11111111-1111-1111-1111-111111111111',
    'The Field 2',
    'Learn about uprights, hash marks, the line of scrimmage, pylons, sidelines, and more field elements',
    2,
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
    items_per_session = EXCLUDED.items_per_session,
    required_completions = EXCLUDED.required_completions;


-- ============================================================================
-- STEP 5: Create TF2 Items (13 questions)
-- ============================================================================

-- Q1: Uprights / Goalposts purpose (Uprights)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'What are the tall yellow posts at the back of each end zone used for?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000001',
    '00000002-0001-0000-0000-000000000001',
    1,
    'What are the tall yellow posts at the back of each end zone used for?',
    '["Marking the sidelines", "Field goals and extra points", "Hanging team banners", "Measuring wind speed"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q2: Where are the goalposts located? (Uprights)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'Where are the goalposts (uprights) located on a football field?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000002',
    '00000002-0001-0000-0000-000000000002',
    1,
    'Where are the goalposts (uprights) located on a football field?',
    '["At the 50-yard line", "At the back of each end zone", "On the sidelines", "At the front of each end zone"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q3: Line of scrimmage definition (Line of Scrimmage)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'What is the line of scrimmage?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000003',
    '00000002-0001-0000-0000-000000000003',
    1,
    'What is the line of scrimmage?',
    '["The line where teams shake hands", "The imaginary line where the ball is placed before each play", "The boundary line on the sides of the field", "The line where the coach stands"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q4: Hash marks purpose (Hash Marks)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'What is the main purpose of the hash marks on a football field?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000004',
    '00000002-0001-0000-0000-000000000004',
    1,
    'What is the main purpose of the hash marks on a football field?',
    '["To mark the end zones", "To show where penalties occurred", "To mark where the ball is placed to start each play", "To indicate the 50-yard line"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q5: Where is the ball placed if a play ends near the sideline? (Hash Marks)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'If a play ends near the sideline, where is the ball placed for the next play?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000005',
    '00000002-0001-0000-0000-000000000005',
    1,
    'If a play ends near the sideline, where is the ball placed for the next play?',
    '["Exactly where the play ended", "At the 50-yard line", "On the nearest hash mark", "In the center of the field"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q6: Pylon definition (Pylon)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'What is a pylon in football?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000006',
    '00000002-0001-0000-0000-000000000006',
    1,
    'What is a pylon in football?',
    '["An orange marker at the corners of the end zone", "A yellow flag thrown by referees", "A type of blocking technique", "A measurement tool for first downs"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q7: Pylon count (Pylon)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'How many pylons are placed on a football field?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    2
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000007',
    '00000002-0001-0000-0000-000000000007',
    1,
    'How many pylons are placed on a football field?',
    '["4", "6", "8", "10"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q8: Sideline definition (Sideline)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'What happens when a player with the ball steps on the sideline?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000008',
    '00000002-0001-0000-0000-000000000008',
    1,
    'What happens when a player with the ball steps on the sideline?',
    '["The play continues", "The player is out of bounds and the play ends", "The player loses 5 yards", "The other team gets the ball"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q9: Boundary lines (Boundary Lines)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'What are the boundary lines on a football field?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000009',
    '00000002-0001-0000-0000-000000000009',
    1,
    'What are the boundary lines on a football field?',
    '["Only the goal lines", "Only the hash marks", "The sidelines and end lines that define the playing area", "The lines between the 10-yard markers"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q10: What must the ball do to score a field goal? (Field Goal Posts)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000010',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'For a field goal to count, where must the ball go?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000010',
    '00000002-0001-0000-0000-000000000010',
    1,
    'For a field goal to count, where must the ball go?',
    '["Between the uprights and above the crossbar", "Through the end zone", "Over the sideline", "Into the stands"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q11: True/False - Line of scrimmage changes (Line of Scrimmage)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000011',
    '00000001-0000-0000-0000-000000000002',
    'binary',
    'The line of scrimmage changes after every play.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000011',
    '00000002-0001-0000-0000-000000000011',
    1,
    'The line of scrimmage changes after every play.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q12: Where do the teams stand when not on the field? (Sidelines)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000012',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'Where do teams stand when they are not on the field playing?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000012',
    '00000002-0001-0000-0000-000000000012',
    1,
    'Where do teams stand when they are not on the field playing?',
    '["In the end zone", "On the sidelines (team bench area)", "Behind the goalposts", "In the stands with fans"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q13: Situational - Line of Scrimmage (Line of Scrimmage)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000013',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'The Chicago Bears are driving toward the Green Bay end zone. The line of scrimmage is at the Green Bay 25-yard line. The running back rushes for a 4-yard gain. On what yard line is the new line of scrimmage?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    2
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000013',
    '00000002-0001-0000-0000-000000000013',
    1,
    'The Chicago Bears are driving toward the Green Bay end zone. The line of scrimmage is at the Green Bay 25-yard line. The running back rushes for a 4-yard gain. On what yard line is the new line of scrimmage?',
    '["Green Bay 29-yard line", "Green Bay 21-yard line", "Green Bay 25-yard line", "Green Bay 20-yard line"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

-- Verify the data was inserted correctly
SELECT
    'TF2 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000002'

UNION ALL

SELECT
    'TF2 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000002';
