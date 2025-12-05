-- ============================================================================
-- OP1 (Offensive Positions 1) - Seed Data
-- ============================================================================
-- OP1 is the TWELFTH lesson (ORDER: 12, after QZ1)
-- OP1 covers: Quarterback (QB) and Running Back (RB)
--
-- Prerequisites: PT1, PT2 (run plays, pass plays)
-- Terms INTRODUCED here: Quarterback, running back, QB, RB
--
-- Can reference: Offense, defense, run plays, pass plays, handoffs, throws, catches
--
-- Structure:
-- - OP1 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create OP1 Lesson (ORDER: 12)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000011',
    '11111111-1111-1111-1111-111111111111',
    'Offensive Positions 1',
    'Meet the quarterback and running back - two key players on the offense.',
    12,
    4,
    50,
    true,
    'OP1',
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
-- STEP 5: Create OP1 Items (9 questions - quarterback and running back)
-- ============================================================================

-- Q1: What is a quarterback?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000011-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000011',
    'mcq',
    'What is the quarterback''s main job on the offense?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000011-0001-0001-0000-000000000001',
    '00000011-0001-0000-0000-000000000001',
    1,
    'What is the quarterback''s main job on the offense?',
    '["To throw passes and hand off the ball to teammates", "To kick field goals", "To tackle the other team", "To catch passes"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: QB abbreviation
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000011-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000011',
    'mcq',
    'What does "QB" stand for in football?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000011-0001-0001-0000-000000000002',
    '00000011-0001-0000-0000-000000000002',
    1,
    'What does "QB" stand for in football?',
    '["Quick Ball", "Quarter Boss", "Quarterback", "Quiet Back"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What is a running back?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000011-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000011',
    'mcq',
    'What is the running back''s main job on the offense?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000011-0001-0001-0000-000000000003',
    '00000011-0001-0000-0000-000000000003',
    1,
    'What is the running back''s main job on the offense?',
    '["To throw passes to teammates", "To carry the ball and run with it on run plays", "To kick the ball", "To block field goals"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: RB abbreviation
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000011-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000011',
    'mcq',
    'What does "RB" stand for in football?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000011-0001-0001-0000-000000000004',
    '00000011-0001-0000-0000-000000000004',
    1,
    'What does "RB" stand for in football?',
    '["Running Back", "Rushing Blocker", "Right Back", "Receiver Block"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: QB on a pass play
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000011-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000011',
    'binary',
    'On a pass play, the quarterback throws the ball to a teammate.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000011-0001-0001-0000-000000000005',
    '00000011-0001-0000-0000-000000000005',
    1,
    'On a pass play, the quarterback throws the ball to a teammate.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Handoff scenario
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000011-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000011',
    'mcq',
    'On a run play, the quarterback hands the ball to the running back. What does the running back do next?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000011-0001-0001-0000-000000000006',
    '00000011-0001-0000-0000-000000000006',
    1,
    'On a run play, the quarterback hands the ball to the running back. What does the running back do next?',
    '["Throws the ball", "Kicks the ball", "Runs with the ball and tries to gain yards", "Gives the ball to the referee"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Who starts with the ball?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000011-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000011',
    'mcq',
    'At the start of most plays, which player receives the ball first?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000011-0001-0001-0000-000000000007',
    '00000011-0001-0000-0000-000000000007',
    1,
    'At the start of most plays, which player receives the ball first?',
    '["The running back", "The quarterback", "The kicker", "A player on defense"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Situational - who is carrying?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000011-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000011',
    'mcq',
    'The Philadelphia Eagles call a run play. The quarterback hands the ball to a teammate who runs through the defense for 8 yards. What position is the player who ran with the ball most likely playing?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000011-0001-0001-0000-000000000008',
    '00000011-0001-0000-0000-000000000008',
    1,
    'The Philadelphia Eagles call a run play. The quarterback hands the ball to a teammate who runs through the defense for 8 yards. What position is the player who ran with the ball most likely playing?',
    '["Running back (RB)", "Quarterback (QB)", "Kicker", "Referee"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: QB leader - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000011-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000011',
    'binary',
    'The quarterback is often called the leader of the offense because they decide what happens with the ball on each play.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000011-0001-0001-0000-000000000009',
    '00000011-0001-0000-0000-000000000009',
    1,
    'The quarterback is often called the leader of the offense because they decide what happens with the ball on each play.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'OP1 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000011'

UNION ALL

SELECT
    'OP1 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000011';
