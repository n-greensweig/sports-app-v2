-- ============================================================================
-- TF2 (The Field 2) - Seed Data
-- ============================================================================
-- TF2 covers: Uprights, hash marks, the line of scrimmage, pylon, sideline,
--             boundary lines, field goal posts, press box
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
    'The uprights (also called goalposts) are used for scoring field goals (3 points) and extra points (1 point). The ball must pass between the uprights and above the crossbar.',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q2: Field goal posts height (Uprights)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'How tall are the uprights (the vertical posts) on an NFL goalpost?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    2
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000002',
    '00000002-0001-0000-0000-000000000002',
    1,
    'How tall are the uprights (the vertical posts) on an NFL goalpost?',
    '["20 feet", "25 feet", "35 feet", "50 feet"]',
    '{"index": 2}',
    'NFL uprights extend 35 feet above the crossbar. The crossbar itself is 10 feet off the ground, so the total height from the ground to the top of the uprights is 45 feet.',
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
    'The line of scrimmage is an imaginary line that runs across the field at the spot where the ball is placed. Both teams line up on opposite sides of this line before each play begins.',
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
    'Hash marks indicate where the ball can be placed to start each play. If a play ends outside the hash marks, the ball is moved to the nearest hash mark for the next play. This keeps action near the center of the field.',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q5: NFL vs College hash marks (Hash Marks)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000002',
    'binary',
    'The hash marks in the NFL are closer together than in college football.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    2
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000005',
    '00000002-0001-0000-0000-000000000005',
    1,
    'The hash marks in the NFL are closer together than in college football.',
    '["True", "False"]',
    '{"boolean": true}',
    'Correct! NFL hash marks are 18 feet 6 inches apart, while college hash marks are 40 feet apart. The narrower NFL hash marks create a more balanced playing field for both sides of the offense.',
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
    'Pylons are bright orange, flexible markers placed at the four corners of each end zone. They help officials determine if a player has scored a touchdown or if the ball went out of bounds.',
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
    'There are 8 pylons total on a football field: 4 at each end zone (one at each corner). They mark where the goal line meets the sideline and the back of the end zone.',
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
    'When a player with the ball steps on or over the sideline, they are out of bounds and the play is over. The ball is spotted where the player went out.',
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
    'The boundary lines include the sidelines (running the length of the field) and the end lines (at the back of each end zone). Together, they define the in-bounds playing area.',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q10: Crossbar height (Field Goal Posts)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000010',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'How high is the crossbar of the goalpost off the ground?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    2
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000010',
    '00000002-0001-0000-0000-000000000010',
    1,
    'How high is the crossbar of the goalpost off the ground?',
    '["5 feet", "10 feet", "15 feet", "20 feet"]',
    '{"index": 1}',
    'The crossbar is 10 feet (3.05 meters) off the ground. For a field goal or extra point to count, the ball must go above the crossbar and between the two uprights.',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q11: Uprights width (Field Goal Posts)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000011',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'How far apart are the uprights on an NFL goalpost?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    2
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000002-0001-0001-0000-000000000011',
    '00000002-0001-0000-0000-000000000011',
    1,
    'How far apart are the uprights on an NFL goalpost?',
    '["12 feet", "18 feet 6 inches", "24 feet", "30 feet"]',
    '{"index": 1}',
    'The uprights are 18 feet 6 inches apart in the NFL. College goalposts are wider at 23 feet 4 inches, making college field goals slightly easier.',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q12: Press box location (Press Box)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000012',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'Where is the press box typically located at a football stadium?',
    '{"correct_index": 2}',
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
    'Where is the press box typically located at a football stadium?',
    '["On the field near the benches", "Behind the end zone", "Elevated in the stands, usually at midfield", "In the locker room area"]',
    '{"index": 2}',
    'The press box is an enclosed area high up in the stadium, typically at midfield. It provides an elevated view of the field for media members, broadcasters, coaches'' spotters, and team executives.',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q13: Situational - Line of Scrimmage (Line of Scrimmage)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000002-0001-0000-0000-000000000013',
    '00000001-0000-0000-0000-000000000002',
    'mcq',
    'The line of scrimmage is at the Green Bay 25-yard line. The running back rushes for a 4-yard gain. On what yard line is the new line of scrimmage?',
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
    'The line of scrimmage is at the Green Bay 25-yard line. The running back rushes for a 4-yard gain. On what yard line is the new line of scrimmage?',
    '["Green Bay 29-yard line", "Green Bay 21-yard line", "Green Bay 25-yard line", "Green Bay 20-yard line"]',
    '{"index": 1}',
    'The new line of scrimmage is at the Green Bay 21-yard line. A 4-yard gain toward the end zone moves the ball from the 25 to the 21 (25 - 4 = 21). Remember, yard numbers count down as you approach the goal line!',
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
