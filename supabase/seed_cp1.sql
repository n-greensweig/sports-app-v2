-- ============================================================================
-- CP1 (Common Penalties 1) - Seed Data
-- ============================================================================
-- CP1 is the NINETEENTH lesson (ORDER: 19)
-- CP1 covers: False start, offside, and the snap
--
-- Prerequisites: TF3, OP1, DP1 (line of scrimmage, positions)
-- Terms INTRODUCED here: Penalty, false start, offside, snap
--
-- Can reference: Line of scrimmage, offense, defense, quarterback, all positions
--
-- Structure:
-- - CP1 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create CP1 Lesson (ORDER: 19)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000017',
    '11111111-1111-1111-1111-111111111111',
    'Common Penalties 1',
    'Learn about penalties - when players break the rules and what happens next.',
    19,
    4,
    50,
    true,
    'CP1',
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
-- STEP 5: Create CP1 Items (9 questions - penalty, false start, offside, snap)
-- ============================================================================

-- Q1: What is a penalty?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000017-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000017',
    'mcq',
    'What is a penalty in football?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000017-0001-0001-0000-000000000001',
    '00000017-0001-0000-0000-000000000001',
    1,
    'What is a penalty in football?',
    '["A punishment given when a player or team breaks a rule", "A type of scoring play", "A timeout called by the coach", "A special play at the end of the game"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: What is the snap?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000017-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000017',
    'mcq',
    'What is the "snap" in football?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000017-0001-0001-0000-000000000002',
    '00000017-0001-0000-0000-000000000002',
    1,
    'What is the "snap" in football?',
    '["When a player catches a pass", "When the ball is passed between the legs from the center to the quarterback to start a play", "When a player kicks the ball", "When a timeout is called"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What is a false start?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000017-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000017',
    'mcq',
    'What is a "false start" penalty?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000017-0001-0001-0000-000000000003',
    '00000017-0001-0000-0000-000000000003',
    1,
    'What is a "false start" penalty?',
    '["When the defense moves before the snap", "When a player catches the ball", "When an offensive player moves before the ball is snapped", "When a player scores a touchdown"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: Who commits false start?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000017-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000017',
    'mcq',
    'Which team can be called for a false start penalty?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000017-0001-0001-0000-000000000004',
    '00000017-0001-0000-0000-000000000004',
    1,
    'Which team can be called for a false start penalty?',
    '["The offense", "The defense", "Either team", "Neither team"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: What is offside?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000017-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000017',
    'mcq',
    'What is an "offside" penalty?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000017-0001-0001-0000-000000000005',
    '00000017-0001-0000-0000-000000000005',
    1,
    'What is an "offside" penalty?',
    '["When the offense moves before the snap", "When a defensive player crosses the line of scrimmage before the ball is snapped", "When a player catches the ball out of bounds", "When a player kicks the ball too far"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Who commits offside?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000017-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000017',
    'mcq',
    'Which team can be called for an offside penalty?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000017-0001-0001-0000-000000000006',
    '00000017-0001-0000-0000-000000000006',
    1,
    'Which team can be called for an offside penalty?',
    '["The offense", "The defense", "Only the kicking team", "Only the quarterback"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Penalties result in yards - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000017-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000017',
    'binary',
    'When a penalty is called, the team that committed the penalty usually loses yards.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000017-0001-0001-0000-000000000007',
    '00000017-0001-0000-0000-000000000007',
    1,
    'When a penalty is called, the team that committed the penalty usually loses yards.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Situational - false start
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000017-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000017',
    'mcq',
    'The Las Vegas Raiders are about to snap the ball. An offensive lineman flinches and moves forward before the snap. The referee blows the whistle. What penalty will be called?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000017-0001-0001-0000-000000000008',
    '00000017-0001-0000-0000-000000000008',
    1,
    'The Las Vegas Raiders are about to snap the ball. An offensive lineman flinches and moves forward before the snap. The referee blows the whistle. What penalty will be called?',
    '["False start - the offense moved before the snap", "Offside - the defense crossed the line", "Touchdown", "Interception"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Situational - offside
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000017-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000017',
    'mcq',
    'The New York Giants offense is lined up at the line of scrimmage. A defensive lineman jumps across the line too early, before the ball is snapped. What penalty will be called?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000017-0001-0001-0000-000000000009',
    '00000017-0001-0000-0000-000000000009',
    1,
    'The New York Giants offense is lined up at the line of scrimmage. A defensive lineman jumps across the line too early, before the ball is snapped. What penalty will be called?',
    '["False start", "Offside - the defense crossed the line before the snap", "Fumble", "Incomplete pass"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'CP1 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000017'

UNION ALL

SELECT
    'CP1 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000017';
