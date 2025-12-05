-- ============================================================================
-- DP1 (Defensive Positions 1) - Seed Data
-- ============================================================================
-- DP1 is the FOURTEENTH lesson (ORDER: 14)
-- DP1 covers: Defensive line and linebacker positions
--
-- Prerequisites: OP1, OP2 (offensive positions)
-- Terms INTRODUCED here: Defensive line, linebacker, rushing the quarterback, tackling
--
-- Can reference: Offense, defense, quarterback, running back, run plays, pass plays
--
-- Structure:
-- - DP1 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create DP1 Lesson (ORDER: 14)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000013',
    '11111111-1111-1111-1111-111111111111',
    'Defensive Positions 1',
    'Learn about the defensive line and linebackers - the first defenders the offense must get past.',
    14,
    4,
    50,
    true,
    'DP1',
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
-- STEP 5: Create DP1 Items (9 questions - defensive line, linebacker)
-- ============================================================================

-- Q1: What is the defensive line?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000013-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000013',
    'mcq',
    'What is the defensive line?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000013-0001-0001-0000-000000000001',
    '00000013-0001-0000-0000-000000000001',
    1,
    'What is the defensive line?',
    '["The group of big defensive players at the front who try to stop runs and get to the quarterback", "The line at the back of the end zone", "The players who catch passes", "The sideline on the field"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: What does the defensive line do against run plays?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000013-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000013',
    'mcq',
    'What does the defensive line try to do when the offense runs the ball?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000013-0001-0001-0000-000000000002',
    '00000013-0001-0000-0000-000000000002',
    1,
    'What does the defensive line try to do when the offense runs the ball?',
    '["Catch the ball", "Stop the running back by tackling them or blocking their path", "Throw the ball", "Kick a field goal"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What is rushing the quarterback?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000013-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000013',
    'mcq',
    'What does it mean when a defensive player "rushes the quarterback"?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000013-0001-0001-0000-000000000003',
    '00000013-0001-0000-0000-000000000003',
    1,
    'What does it mean when a defensive player "rushes the quarterback"?',
    '["Runs away from the quarterback", "Gives the ball to the quarterback", "Tries to get to the quarterback before they can throw the ball", "Blocks for the quarterback"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: What is a linebacker?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000013-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000013',
    'mcq',
    'Where do linebackers line up on the field?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000013-0001-0001-0000-000000000004',
    '00000013-0001-0000-0000-000000000004',
    1,
    'Where do linebackers line up on the field?',
    '["Behind the defensive line, a few yards back", "On the sideline", "In the end zone", "Next to the quarterback"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: Linebacker responsibilities
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000013-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000013',
    'mcq',
    'What can linebackers do on defense?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000013-0001-0001-0000-000000000005',
    '00000013-0001-0000-0000-000000000005',
    1,
    'What can linebackers do on defense?',
    '["Only kick the ball", "Only catch passes", "Tackle runners AND cover receivers who might catch passes", "Only throw the ball"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: What is tackling?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000013-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000013',
    'mcq',
    'What does it mean to "tackle" someone in football?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000013-0001-0001-0000-000000000006',
    '00000013-0001-0000-0000-000000000006',
    1,
    'What does it mean to "tackle" someone in football?',
    '["Throw the ball to them", "Bring them down to the ground to stop the play", "Catch a pass from them", "Give them the ball"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Defensive line size - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000013-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000013',
    'binary',
    'Players on the defensive line are usually some of the biggest and strongest players on the team.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000013-0001-0001-0000-000000000007',
    '00000013-0001-0000-0000-000000000007',
    1,
    'Players on the defensive line are usually some of the biggest and strongest players on the team.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Situational - who made the tackle?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000013-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000013',
    'mcq',
    'The Denver Broncos running back takes a handoff and runs through a hole in the line. A defender waiting behind the line tackles him after a 4-yard gain. What position was the defender most likely playing?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000013-0001-0001-0000-000000000008',
    '00000013-0001-0000-0000-000000000008',
    1,
    'The Denver Broncos running back takes a handoff and runs through a hole in the line. A defender waiting behind the line tackles him after a 4-yard gain. What position was the defender most likely playing?',
    '["Quarterback", "Linebacker", "Wide Receiver", "Running Back"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: First line of defense - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000013-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000013',
    'binary',
    'The defensive line is the first group of defenders the offense must get past on each play.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000013-0001-0001-0000-000000000009',
    '00000013-0001-0000-0000-000000000009',
    1,
    'The defensive line is the first group of defenders the offense must get past on each play.',
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
    'DP1 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000013'

UNION ALL

SELECT
    'DP1 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000013';
