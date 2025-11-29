-- ============================================================================
-- TO1 (Turnovers 1) - Seed Data
-- ============================================================================
-- TO1 is the FIFTEENTH lesson (ORDER: 15)
-- TO1 covers: Interceptions and fumbles - the basic turnover concepts
--
-- Prerequisites: All position lessons (OP1, OP2, DP1, DP2)
-- Terms INTRODUCED here: Interception, fumble, turnover
--
-- Can reference: All positions, passing, catching, carrying the ball, defense
--
-- Structure:
-- - TO1 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create TO1 Lesson (ORDER: 15)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000015',
    '11111111-1111-1111-1111-111111111111',
    'Turnovers 1',
    'Learn about interceptions and fumbles - mistakes that give the ball to the other team.',
    15,
    4,
    50,
    true,
    'TO1',
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
-- STEP 5: Create TO1 Items (9 questions - interception, fumble, turnover)
-- ============================================================================

-- Q1: What is a turnover?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000015-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000015',
    'mcq',
    'What is a "turnover" in football?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000015-0001-0001-0000-000000000001',
    '00000015-0001-0000-0000-000000000001',
    1,
    'What is a "turnover" in football?',
    '["When the offense loses possession of the ball to the defense", "When the quarter ends", "When a team scores a touchdown", "When a player catches a pass"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: What is an interception?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000015-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000015',
    'mcq',
    'What is an interception?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000015-0001-0001-0000-000000000002',
    '00000015-0001-0000-0000-000000000002',
    1,
    'What is an interception?',
    '["When a receiver catches a pass from their quarterback", "When a defender catches a pass that was meant for an offensive player", "When a player kicks the ball", "When the game is paused"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What happens after an interception?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000015-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000015',
    'mcq',
    'After an interception, what happens?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000015-0001-0001-0000-000000000003',
    '00000015-0001-0000-0000-000000000003',
    1,
    'After an interception, what happens?',
    '["The offense keeps the ball", "The game pauses for a timeout", "The defense gets the ball and becomes the offense", "A field goal is awarded"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: What is a fumble?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000015-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000015',
    'mcq',
    'What is a fumble?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000015-0001-0001-0000-000000000004',
    '00000015-0001-0000-0000-000000000004',
    1,
    'What is a fumble?',
    '["When a player drops the ball while running or after being hit", "When a player catches a pass", "When a player throws the ball", "When a player kicks the ball"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: Who can recover a fumble?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000015-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000015',
    'mcq',
    'After a fumble, who can pick up (recover) the ball?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000015-0001-0001-0000-000000000005',
    '00000015-0001-0000-0000-000000000005',
    1,
    'After a fumble, who can pick up (recover) the ball?',
    '["Only the offense", "Only the defense", "Either team - whoever gets to it first", "Only the referees"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Interception is a turnover - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000015-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000015',
    'binary',
    'An interception is a type of turnover.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000015-0001-0001-0000-000000000006',
    '00000015-0001-0000-0000-000000000006',
    1,
    'An interception is a type of turnover.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Fumble can be turnover - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000015-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000015',
    'binary',
    'If the defense recovers a fumble, it is a turnover.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000015-0001-0001-0000-000000000007',
    '00000015-0001-0000-0000-000000000007',
    1,
    'If the defense recovers a fumble, it is a turnover.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Situational - interception scenario
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000015-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000015',
    'mcq',
    'The Tampa Bay Buccaneers quarterback throws a pass toward a wide receiver. A cornerback jumps in front and catches the ball instead. What just happened?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000015-0001-0001-0000-000000000008',
    '00000015-0001-0000-0000-000000000008',
    1,
    'The Tampa Bay Buccaneers quarterback throws a pass toward a wide receiver. A cornerback jumps in front and catches the ball instead. What just happened?',
    '["A touchdown", "An interception - the defense now has the ball", "A fumble", "An incomplete pass"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Situational - fumble scenario
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000015-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000015',
    'mcq',
    'The Cincinnati Bengals running back is carrying the ball when a linebacker hits him hard. The ball pops out and rolls on the ground. A defensive player picks it up. What happened?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000015-0001-0001-0000-000000000009',
    '00000015-0001-0000-0000-000000000009',
    1,
    'The Cincinnati Bengals running back is carrying the ball when a linebacker hits him hard. The ball pops out and rolls on the ground. A defensive player picks it up. What happened?',
    '["A fumble - the defense recovered it and now has the ball", "An interception", "A touchdown", "An incomplete pass"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'TO1 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000015'

UNION ALL

SELECT
    'TO1 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000015';
