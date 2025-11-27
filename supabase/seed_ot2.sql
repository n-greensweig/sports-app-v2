-- ============================================================================
-- OT2 (Offensive Terms 2) - Seed Data
-- ============================================================================
-- OT2 covers: Field goal, touchdown, extra point, safety
--
-- Structure:
-- - OT2 Lesson (10 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create OT2 Lesson
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000004',
    '11111111-1111-1111-1111-111111111111',
    'Offensive Terms 2',
    'Learn about scoring: touchdowns, field goals, extra points, and safeties',
    4,
    4,
    50,
    true,
    'OT2',
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
-- STEP 5: Create OT2 Items (10 questions)
-- ============================================================================

-- Q1: What is a touchdown? (Touchdown)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000004-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000004',
    'mcq',
    'What is a touchdown in football?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000004-0001-0001-0000-000000000001',
    '00000004-0001-0000-0000-000000000001',
    1,
    'What is a touchdown in football?',
    '["Kicking the ball through the goalposts", "Tackling the quarterback behind the line of scrimmage", "When a player carries or catches the ball in the opponent''s end zone", "When the defense intercepts a pass"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q2: How many points is a touchdown? (Touchdown)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000004-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000004',
    'mcq',
    'How many points is a touchdown worth?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000004-0001-0001-0000-000000000002',
    '00000004-0001-0000-0000-000000000002',
    1,
    'How many points is a touchdown worth?',
    '["3 points", "6 points", "7 points", "1 point"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q3: What is a field goal? (Field Goal)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000004-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000004',
    'mcq',
    'What is a field goal?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000004-0001-0001-0000-000000000003',
    '00000004-0001-0000-0000-000000000003',
    1,
    'What is a field goal?',
    '["A kick through the uprights during a regular play, worth 3 points", "A pass completed in the end zone", "A punt that goes into the end zone", "A running play that gains more than 10 yards"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q4: How many points is a field goal? (Field Goal)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000004-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000004',
    'mcq',
    'How many points is a field goal worth?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000004-0001-0001-0000-000000000004',
    '00000004-0001-0000-0000-000000000004',
    1,
    'How many points is a field goal worth?',
    '["1 point", "2 points", "3 points", "6 points"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q5: What is an extra point? (Extra Point)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000004-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000004',
    'mcq',
    'What is an extra point (PAT)?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000004-0001-0001-0000-000000000005',
    '00000004-0001-0000-0000-000000000005',
    1,
    'What is an extra point (PAT)?',
    '["A bonus touchdown awarded for excellent play", "A kick through the uprights attempted after a touchdown", "An additional down given after a first down", "A point given for fair catches"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q6: What is a safety? (Safety)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000004-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000004',
    'mcq',
    'What is a safety in football?',
    '{"correct_index": 3}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000004-0001-0001-0000-000000000006',
    '00000004-0001-0000-0000-000000000006',
    1,
    'What is a safety in football?',
    '["A protective piece of equipment", "A type of defensive player", "When a kick goes out of bounds", "When the offense is tackled in their own end zone, giving the defense 2 points"]',
    '{"index": 3}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q7: How many points is a safety? (Safety)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000004-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000004',
    'mcq',
    'How many points is a safety worth?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000004-0001-0001-0000-000000000007',
    '00000004-0001-0000-0000-000000000007',
    1,
    'How many points is a safety worth?',
    '["1 point", "2 points", "3 points", "6 points"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q8: True/False - Touchdown + Extra Point (Touchdown/Extra Point)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000004-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000004',
    'binary',
    'A touchdown plus a successful extra point kick equals 7 total points.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000004-0001-0001-0000-000000000008',
    '00000004-0001-0000-0000-000000000008',
    1,
    'A touchdown plus a successful extra point kick equals 7 total points.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q9: Situational - Scoring decision (Field Goal vs Touchdown)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000004-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000004',
    'mcq',
    'The Denver Broncos are close to the opponent''s end zone but it''s getting hard to advance the ball. They could try for a touchdown (6 points) or kick a field goal (3 points). When might a team choose to kick a field goal instead of going for a touchdown?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    2
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000004-0001-0001-0000-000000000009',
    '00000004-0001-0000-0000-000000000009',
    1,
    'The Denver Broncos are close to the opponent''s end zone but it''s getting hard to advance the ball. They could try for a touchdown (6 points) or kick a field goal (3 points). When might a team choose to kick a field goal instead of going for a touchdown?',
    '["When they want to score more points", "When they want guaranteed points rather than risk getting nothing", "When they are losing by a lot", "Field goals are always better than touchdowns"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q10: Situational - Safety scenario (Safety)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000004-0001-0000-0000-000000000010',
    '00000001-0000-0000-0000-000000000004',
    'mcq',
    'The New England Patriots have the ball near their own goal line. A running back takes the ball but is tackled in his own end zone by the Buffalo Bills defense. What is the result?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    2
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000004-0001-0001-0000-000000000010',
    '00000004-0001-0000-0000-000000000010',
    1,
    'The New England Patriots have the ball near their own goal line. A running back takes the ball but is tackled in his own end zone by the Buffalo Bills defense. What is the result?',
    '["Touchdown for the Bills", "The play doesn''t count", "Safety! 2 points for the Bills", "First down for the Patriots"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

-- Verify the data was inserted correctly
SELECT
    'OT2 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000004'

UNION ALL

SELECT
    'OT2 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000004';
