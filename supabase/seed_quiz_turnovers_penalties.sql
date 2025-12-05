-- ============================================================================
-- Rookie Turnovers & Penalties Quiz - Seed Data
-- ============================================================================
-- This quiz comes after CP2 (lesson 18) and tests TO1-CP2
-- Contains 10 questions about turnovers and penalties
--
-- ORDER: 21 (after CP2)
-- Type: Quiz
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
-- STEP 4: Create Rookie Turnovers & Penalties Quiz (ORDER: 21)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000025',
    '11111111-1111-1111-1111-111111111111',
    'Rookie Turnovers & Penalties Quiz',
    'Test your knowledge of turnovers and common penalties!',
    21,
    5,
    75,
    true,
    'QZ3',
    10,
    1
)
ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    code = EXCLUDED.code,
    order_index = EXCLUDED.order_index,
    items_per_session = EXCLUDED.items_per_session,
    required_completions = EXCLUDED.required_completions;


-- ============================================================================
-- STEP 5: Create Quiz Items (10 questions from TO1-CP2)
-- ============================================================================

-- Q1: From TO1 - What is a turnover?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000025-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000025',
    'mcq',
    'What is a turnover in football?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000025-0001-0001-0000-000000000001',
    '00000025-0001-0000-0000-000000000001',
    1,
    'What is a turnover in football?',
    '["When the offense loses possession of the ball to the defense", "When the game ends", "When a team scores", "When a timeout is called"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: From TO1 - What is an interception?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000025-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000025',
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
    '00000025-0001-0001-0000-000000000002',
    '00000025-0001-0000-0000-000000000002',
    1,
    'What is an interception?',
    '["A long pass", "When a defender catches a pass meant for the offense", "A type of penalty", "A field goal attempt"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: From TO1 - What is a fumble?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000025-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000025',
    'mcq',
    'What is a fumble?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000025-0001-0001-0000-000000000003',
    '00000025-0001-0000-0000-000000000003',
    1,
    'What is a fumble?',
    '["A type of pass", "A successful catch", "When a player drops the ball while running or after being hit", "A penalty"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: From TO2 - What is a pick-six?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000025-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000025',
    'mcq',
    'What is a pick-six?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000025-0001-0001-0000-000000000004',
    '00000025-0001-0000-0000-000000000004',
    1,
    'What is a pick-six?',
    '["An interception returned for a touchdown (6 points)", "Six interceptions in a game", "A penalty worth 6 yards", "Picking up 6 first downs"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: From CP1 - What is a penalty?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000025-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000025',
    'mcq',
    'What is a penalty in football?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000025-0001-0001-0000-000000000005',
    '00000025-0001-0000-0000-000000000005',
    1,
    'What is a penalty in football?',
    '["A scoring play", "A punishment when a player or team breaks a rule", "A type of pass", "A timeout"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: From CP1 - False start
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000025-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000025',
    'mcq',
    'What is a false start penalty?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000025-0001-0001-0000-000000000006',
    '00000025-0001-0000-0000-000000000006',
    1,
    'What is a false start penalty?',
    '["When the defense moves before the snap", "When a player catches the ball", "When an offensive player moves before the ball is snapped", "When the kicker misses"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: From CP1 - Offside
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000025-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000025',
    'mcq',
    'Who commits an offside penalty?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000025-0001-0001-0000-000000000007',
    '00000025-0001-0000-0000-000000000007',
    1,
    'Who commits an offside penalty?',
    '["The offense", "The defense (crossing the line of scrimmage before the snap)", "The kicker", "The referee"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: From CP2 - Holding
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000025-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000025',
    'mcq',
    'What is holding?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000025-0001-0001-0000-000000000008',
    '00000025-0001-0000-0000-000000000008',
    1,
    'What is holding?',
    '["When a player illegally grabs or holds onto another player", "When a player catches the ball", "When a player runs out of bounds", "When the clock stops"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: From CP2 - Pass interference
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000025-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000025',
    'mcq',
    'What is pass interference?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000025-0001-0001-0000-000000000009',
    '00000025-0001-0000-0000-000000000009',
    1,
    'What is pass interference?',
    '["Throwing the ball too far", "Running the wrong route", "When a player illegally prevents another player from catching a pass", "A type of scoring play"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q10: Situational - interception vs fumble
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000025-0001-0000-0000-000000000010',
    '00000001-0000-0000-0000-000000000025',
    'binary',
    'Both interceptions and fumbles (when recovered by the defense) are types of turnovers.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000025-0001-0001-0000-000000000010',
    '00000025-0001-0000-0000-000000000010',
    1,
    'Both interceptions and fumbles (when recovered by the defense) are types of turnovers.',
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
    'Rookie Turnovers & Penalties Quiz' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000025'

UNION ALL

SELECT
    'Quiz Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000025';
