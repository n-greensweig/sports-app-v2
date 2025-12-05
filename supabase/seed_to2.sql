-- ============================================================================
-- TO2 (Turnovers 2) - Seed Data
-- ============================================================================
-- TO2 is the EIGHTEENTH lesson (ORDER: 18)
-- TO2 covers: Forced fumble, fumble recovery, pick-six
--
-- Prerequisites: TO1 (interception, fumble, turnover)
-- Terms INTRODUCED here: Forced fumble, recovery, pick-six
--
-- Can reference: Interception, fumble, turnover, all positions
--
-- Structure:
-- - TO2 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create TO2 Lesson (ORDER: 18)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000016',
    '11111111-1111-1111-1111-111111111111',
    'Turnovers 2',
    'Learn about forced fumbles, fumble recoveries, and the exciting pick-six!',
    18,
    4,
    50,
    true,
    'TO2',
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
-- STEP 5: Create TO2 Items (9 questions - forced fumble, recovery, pick-six)
-- ============================================================================

-- Q1: What is a forced fumble?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000016-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000016',
    'mcq',
    'What is a "forced fumble"?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000016-0001-0001-0000-000000000001',
    '00000016-0001-0000-0000-000000000001',
    1,
    'What is a "forced fumble"?',
    '["When a player drops the ball on their own", "When a defender knocks or strips the ball out of an offensive player''s hands", "When a player throws an interception", "When a player kicks the ball away"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: What is a fumble recovery?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000016-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000016',
    'mcq',
    'What does it mean to "recover" a fumble?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000016-0001-0001-0000-000000000002',
    '00000016-0001-0000-0000-000000000002',
    1,
    'What does it mean to "recover" a fumble?',
    '["To pick up or gain possession of a loose ball after a fumble", "To throw the ball away", "To catch a pass", "To kick a field goal"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What is a pick-six?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000016-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000016',
    'mcq',
    'What is a "pick-six"?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000016-0001-0001-0000-000000000003',
    '00000016-0001-0000-0000-000000000003',
    1,
    'What is a "pick-six"?',
    '["When a team kicks six field goals", "When a running back scores six touchdowns", "When a defender intercepts a pass and returns it for a touchdown (6 points)", "When a quarterback throws six passes"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: Why is it called "pick-six"?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000016-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000016',
    'mcq',
    'Why is an interception returned for a touchdown called a "pick-six"?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000016-0001-0001-0000-000000000004',
    '00000016-0001-0000-0000-000000000004',
    1,
    'Why is an interception returned for a touchdown called a "pick-six"?',
    '["Because you pick the ball off the ground", "Because ''pick'' is slang for interception, and a touchdown is worth 6 points", "Because six players are involved", "Because it happens on 6th down"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: Forced fumble is impressive - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000016-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000016',
    'binary',
    'A forced fumble is considered a great defensive play because the defender actively causes the fumble.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000016-0001-0001-0000-000000000005',
    '00000016-0001-0000-0000-000000000005',
    1,
    'A forced fumble is considered a great defensive play because the defender actively causes the fumble.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Pick-six scores for defense
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000016-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000016',
    'binary',
    'On a pick-six, the defense scores a touchdown.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000016-0001-0001-0000-000000000006',
    '00000016-0001-0000-0000-000000000006',
    1,
    'On a pick-six, the defense scores a touchdown.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Situational - forced fumble scenario
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000016-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000016',
    'mcq',
    'The Arizona Cardinals running back is running with the ball. A linebacker tackles him and punches at the ball, knocking it loose. A defensive lineman then picks up the ball. What two things happened?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000016-0001-0001-0000-000000000007',
    '00000016-0001-0000-0000-000000000007',
    1,
    'The Arizona Cardinals running back is running with the ball. A linebacker tackles him and punches at the ball, knocking it loose. A defensive lineman then picks up the ball. What two things happened?',
    '["A forced fumble (by the linebacker) and a fumble recovery (by the lineman)", "An interception and a touchdown", "A pass and a catch", "A field goal and an extra point"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Situational - pick-six scenario
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000016-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000016',
    'mcq',
    'The Baltimore Ravens quarterback throws a pass. A safety jumps up and catches it, then runs 45 yards the other way into the end zone. What just happened?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000016-0001-0001-0000-000000000008',
    '00000016-0001-0000-0000-000000000008',
    1,
    'The Baltimore Ravens quarterback throws a pass. A safety jumps up and catches it, then runs 45 yards the other way into the end zone. What just happened?',
    '["A fumble recovery for a touchdown", "A passing touchdown for the Ravens", "A pick-six! The defense scored a touchdown", "A field goal"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Momentum change
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000016-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000016',
    'mcq',
    'Why are turnovers like interceptions and fumble recoveries so important in a football game?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000016-0001-0001-0000-000000000009',
    '00000016-0001-0000-0000-000000000009',
    1,
    'Why are turnovers like interceptions and fumble recoveries so important in a football game?',
    '["They are not important", "They take the ball away from the other team and give your team a chance to score", "They stop the game clock", "They are worth 3 points each"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'TO2 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000016'

UNION ALL

SELECT
    'TO2 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000016';
