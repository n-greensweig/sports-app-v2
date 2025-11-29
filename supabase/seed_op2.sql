-- ============================================================================
-- OP2 (Offensive Positions 2) - Seed Data
-- ============================================================================
-- OP2 is the TWELFTH lesson (ORDER: 12)
-- OP2 covers: Wide Receiver (WR), Tight End (TE), and basic blocking
--
-- Prerequisites: OP1 (quarterback, running back)
-- Terms INTRODUCED here: Wide receiver, tight end, WR, TE, blocking (basic)
--
-- Can reference: Quarterback, running back, pass plays, run plays, catching
--
-- Structure:
-- - OP2 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create OP2 Lesson (ORDER: 12)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000012',
    '11111111-1111-1111-1111-111111111111',
    'Offensive Positions 2',
    'Meet the wide receiver and tight end - players who catch passes and help the offense.',
    12,
    4,
    50,
    true,
    'OP2',
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
-- STEP 5: Create OP2 Items (9 questions - wide receiver, tight end, blocking)
-- ============================================================================

-- Q1: What is a wide receiver?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000012-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000012',
    'mcq',
    'What is a wide receiver''s main job on the offense?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000012-0001-0001-0000-000000000001',
    '00000012-0001-0000-0000-000000000001',
    1,
    'What is a wide receiver''s main job on the offense?',
    '["To throw the ball", "To run down the field and catch passes from the quarterback", "To kick field goals", "To tackle the other team"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: WR abbreviation
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000012-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000012',
    'mcq',
    'What does "WR" stand for in football?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000012-0001-0001-0000-000000000002',
    '00000012-0001-0000-0000-000000000002',
    1,
    'What does "WR" stand for in football?',
    '["Wide Receiver", "Wing Runner", "Wrist Rotation", "Wide Rusher"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What is a tight end?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000012-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000012',
    'mcq',
    'What makes a tight end special compared to other offensive players?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000012-0001-0001-0000-000000000003',
    '00000012-0001-0000-0000-000000000003',
    1,
    'What makes a tight end special compared to other offensive players?',
    '["They only throw the ball", "They only run with the ball", "They can both catch passes AND block for teammates", "They only kick the ball"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: TE abbreviation
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000012-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000012',
    'mcq',
    'What does "TE" stand for in football?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000012-0001-0001-0000-000000000004',
    '00000012-0001-0000-0000-000000000004',
    1,
    'What does "TE" stand for in football?',
    '["Tackle Expert", "Tight End", "Team Expert", "Touch End"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: What is blocking?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000012-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000012',
    'mcq',
    'What does "blocking" mean in football?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000012-0001-0001-0000-000000000005',
    '00000012-0001-0000-0000-000000000005',
    1,
    'What does "blocking" mean in football?',
    '["Using your body to get in the way of defenders so they can''t reach the ball carrier", "Throwing the ball", "Catching a pass", "Kicking a field goal"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Wide receiver location - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000012-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000012',
    'binary',
    'Wide receivers usually line up far from the quarterback, near the sidelines.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000012-0001-0001-0000-000000000006',
    '00000012-0001-0000-0000-000000000006',
    1,
    'Wide receivers usually line up far from the quarterback, near the sidelines.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Situational - who caught it?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000012-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000012',
    'mcq',
    'The Los Angeles Rams quarterback throws a long pass down the sideline. A player catches it and runs for a touchdown. Which position was most likely the player who caught the ball?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000012-0001-0001-0000-000000000007',
    '00000012-0001-0000-0000-000000000007',
    1,
    'The Los Angeles Rams quarterback throws a long pass down the sideline. A player catches it and runs for a touchdown. Which position was most likely the player who caught the ball?',
    '["Quarterback (QB)", "Running Back (RB)", "Wide Receiver (WR)", "Kicker"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Tight end versatility
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000012-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000012',
    'binary',
    'A tight end can help the running back by blocking defenders during a run play.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000012-0001-0001-0000-000000000008',
    '00000012-0001-0000-0000-000000000008',
    1,
    'A tight end can help the running back by blocking defenders during a run play.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Match positions to roles
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000012-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000012',
    'mcq',
    'Which offensive positions are known mainly for catching passes from the quarterback?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000012-0001-0001-0000-000000000009',
    '00000012-0001-0000-0000-000000000009',
    1,
    'Which offensive positions are known mainly for catching passes from the quarterback?',
    '["Quarterback and Running Back", "Wide Receiver and Tight End", "Kicker and Punter", "Running Back and Tight End"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'OP2 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000012'

UNION ALL

SELECT
    'OP2 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000012';
