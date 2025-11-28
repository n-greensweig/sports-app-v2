-- ============================================================================
-- DS1 (The Downs 1) - Seed Data
-- ============================================================================
-- DS1 is the FIFTH lesson (after GB1, TF1, TF2, SC1)
-- DS1 covers: What is a "down"? 4 downs to move 10 yards. Basic concept only.
--
-- Prerequisites: GB1 (offense, defense), TF1 (yard lines), TF2 (boundaries), SC1 (touchdown)
-- Terms INTRODUCED here: Down, 4 downs, 10-yard requirement, gaining yards
--
-- CRITICAL: NO "1st and 10" notation yet (that's DS2)
-- NO situational questions yet - just the basic concept
--
-- Structure:
-- - DS1 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create DS1 Lesson (ORDER: 5)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000005',
    '11111111-1111-1111-1111-111111111111',
    'The Downs 1',
    'Learn about "downs" - the system that gives the offense chances to move the ball.',
    5,
    4,
    50,
    true,
    'DS1',
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
-- STEP 5: Create DS1 Items (9 questions - basic downs concept ONLY)
-- ============================================================================

-- Q1: What is a down?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000005-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000005',
    'mcq',
    'In football, what is a "down"?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000005-0001-0001-0000-000000000001',
    '00000005-0001-0000-0000-000000000001',
    1,
    'In football, what is a "down"?',
    '["A type of score", "One play or attempt by the offense", "When a player falls to the ground", "A defensive position"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: How many downs does the offense get?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000005-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000005',
    'mcq',
    'How many downs (attempts) does the offense get to move the ball?',
    '{"correct_index": 3}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000005-0001-0001-0000-000000000002',
    '00000005-0001-0000-0000-000000000002',
    1,
    'How many downs (attempts) does the offense get to move the ball?',
    '["2 downs", "3 downs", "5 downs", "4 downs"]',
    '{"index": 3}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: How many yards must they gain?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000005-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000005',
    'mcq',
    'The offense has 4 downs to move the ball. How many yards must they gain in those 4 downs?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000005-0001-0001-0000-000000000003',
    '00000005-0001-0000-0000-000000000003',
    1,
    'The offense has 4 downs to move the ball. How many yards must they gain in those 4 downs?',
    '["5 yards", "10 yards", "15 yards", "20 yards"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: What happens if they gain 10 yards?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000005-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000005',
    'mcq',
    'If the offense gains 10 yards within their 4 downs, what happens?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000005-0001-0001-0000-000000000004',
    '00000005-0001-0000-0000-000000000004',
    1,
    'If the offense gains 10 yards within their 4 downs, what happens?',
    '["They get a new set of 4 downs", "They score a touchdown", "The other team gets the ball", "The game ends"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: 4 downs and 10 yards - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000005-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000005',
    'binary',
    'The offense gets 4 downs (attempts) to move the ball 10 yards.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000005-0001-0001-0000-000000000005',
    '00000005-0001-0000-0000-000000000005',
    1,
    'The offense gets 4 downs (attempts) to move the ball 10 yards.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: What is the goal of the downs system?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000005-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000005',
    'mcq',
    'Why does the offense need to gain 10 yards in 4 downs?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000005-0001-0001-0000-000000000006',
    '00000005-0001-0000-0000-000000000006',
    1,
    'Why does the offense need to gain 10 yards in 4 downs?',
    '["To score an automatic touchdown", "To end the game", "To keep the ball and get more chances to move toward the end zone", "To switch to defense"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Does gaining 10 yards score points?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000005-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000005',
    'binary',
    'Gaining 10 yards and getting a new set of downs scores points for the offense.',
    '{"correct_boolean": false}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000005-0001-0001-0000-000000000007',
    '00000005-0001-0000-0000-000000000007',
    1,
    'Gaining 10 yards and getting a new set of downs scores points for the offense.',
    '["True", "False"]',
    '{"boolean": false}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Each down is one...?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000005-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000005',
    'mcq',
    'Each "down" is one ______ for the offense.',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000005-0001-0001-0000-000000000008',
    '00000005-0001-0000-0000-000000000008',
    1,
    'Each "down" is one ______ for the offense.',
    '["point", "play or attempt", "yard", "quarter"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Can yards be gained across multiple downs?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000005-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000005',
    'mcq',
    'Can the offense add up yards from multiple downs to reach 10 yards?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000005-0001-0001-0000-000000000009',
    '00000005-0001-0000-0000-000000000009',
    1,
    'Can the offense add up yards from multiple downs to reach 10 yards?',
    '["Yes - they can gain yards over multiple plays to reach 10", "No - they must gain 10 yards in a single play", "No - each down starts over at 0 yards", "Yes - but only on the 4th down"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'DS1 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000005'

UNION ALL

SELECT
    'DS1 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000005';
