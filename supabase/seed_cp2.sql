-- ============================================================================
-- CP2 (Common Penalties 2) - Seed Data
-- ============================================================================
-- CP2 is the TWENTIETH lesson (ORDER: 20)
-- CP2 covers: Holding and pass interference
--
-- Prerequisites: CP1 (penalty basics, false start, offside)
-- Terms INTRODUCED here: Holding, pass interference
--
-- Can reference: Penalties, offense, defense, passing, blocking, wide receivers
--
-- Structure:
-- - CP2 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create CP2 Lesson (ORDER: 20)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000018',
    '11111111-1111-1111-1111-111111111111',
    'Common Penalties 2',
    'Learn about holding and pass interference - two of the most common penalties in football.',
    20,
    4,
    50,
    true,
    'CP2',
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
-- STEP 5: Create CP2 Items (9 questions - holding, pass interference)
-- ============================================================================

-- Q1: What is holding?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000018-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000018',
    'mcq',
    'What is a "holding" penalty?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000018-0001-0001-0000-000000000001',
    '00000018-0001-0000-0000-000000000001',
    1,
    'What is a "holding" penalty?',
    '["Catching the ball with two hands", "When a player illegally grabs or holds onto another player", "When a player holds the ball too long", "When a team calls a timeout"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: Who can commit holding?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000018-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000018',
    'mcq',
    'Can both the offense and defense commit holding penalties?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000018-0001-0001-0000-000000000002',
    '00000018-0001-0000-0000-000000000002',
    1,
    'Can both the offense and defense commit holding penalties?',
    '["Yes, both teams can be called for holding", "No, only the offense can hold", "No, only the defense can hold", "No, holding is not a real penalty"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What is pass interference?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000018-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000018',
    'mcq',
    'What is "pass interference"?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000018-0001-0001-0000-000000000003',
    '00000018-0001-0000-0000-000000000003',
    1,
    'What is "pass interference"?',
    '["Throwing the ball too far", "Catching the ball with one hand", "When a player illegally prevents another player from catching a pass", "Running the wrong route"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: Defensive pass interference
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000018-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000018',
    'mcq',
    'A cornerback pushes a wide receiver to the ground before the ball arrives. What penalty is this?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000018-0001-0001-0000-000000000004',
    '00000018-0001-0000-0000-000000000004',
    1,
    'A cornerback pushes a wide receiver to the ground before the ball arrives. What penalty is this?',
    '["Holding", "Defensive pass interference", "False start", "Offside"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: Offensive holding scenario
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000018-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000018',
    'mcq',
    'An offensive lineman grabs a defensive player''s jersey and pulls them back to prevent them from reaching the quarterback. What penalty is this?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000018-0001-0001-0000-000000000005',
    '00000018-0001-0000-0000-000000000005',
    1,
    'An offensive lineman grabs a defensive player''s jersey and pulls them back to prevent them from reaching the quarterback. What penalty is this?',
    '["Offensive holding", "Pass interference", "Offside", "False start"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Pass interference is serious - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000018-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000018',
    'binary',
    'Pass interference is often a big penalty because it can result in a lot of yards being awarded to the other team.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000018-0001-0001-0000-000000000006',
    '00000018-0001-0000-0000-000000000006',
    1,
    'Pass interference is often a big penalty because it can result in a lot of yards being awarded to the other team.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Holding is common - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000018-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000018',
    'binary',
    'Holding is one of the most commonly called penalties in football.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000018-0001-0001-0000-000000000007',
    '00000018-0001-0000-0000-000000000007',
    1,
    'Holding is one of the most commonly called penalties in football.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Situational - DPI on long pass
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000018-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000018',
    'mcq',
    'The Houston Texans quarterback throws a deep pass. The cornerback grabs the wide receiver''s arm and prevents him from catching the ball. The referee throws a yellow flag. What will be called?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000018-0001-0001-0000-000000000008',
    '00000018-0001-0000-0000-000000000008',
    1,
    'The Houston Texans quarterback throws a deep pass. The cornerback grabs the wide receiver''s arm and prevents him from catching the ball. The referee throws a yellow flag. What will be called?',
    '["False start", "Offside", "Defensive pass interference", "Holding on the offense"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Why blocking becomes holding
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000018-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000018',
    'mcq',
    'What is the difference between legal blocking and illegal holding?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000018-0001-0001-0000-000000000009',
    '00000018-0001-0000-0000-000000000009',
    1,
    'What is the difference between legal blocking and illegal holding?',
    '["There is no difference", "Blocking uses your body, but holding involves grabbing or pulling a player''s jersey or body parts", "Holding is allowed in football", "Blocking is only for the defense"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'CP2 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000018'

UNION ALL

SELECT
    'CP2 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000018';
