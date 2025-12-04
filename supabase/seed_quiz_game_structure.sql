-- ============================================================================
-- Rookie Game Structure Quiz - Seed Data
-- ============================================================================
-- This quiz comes after ST2 (lesson 22) and tests GS1-ST2
-- Contains 10 questions about game structure and special teams
--
-- ORDER: 26
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
-- STEP 4: Create Rookie Game Structure Quiz (ORDER: 26)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000026',
    '11111111-1111-1111-1111-111111111111',
    'Rookie Game Structure Quiz',
    'Test your knowledge of game timing and special teams plays!',
    26,
    5,
    75,
    true,
    'QZ4',
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
-- STEP 5: Create Quiz Items (10 questions from GS1-ST2)
-- ============================================================================

-- Q1: From GS1 - How many quarters?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000026-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000026',
    'mcq',
    'How many quarters are in a football game?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000026-0001-0001-0000-000000000001',
    '00000026-0001-0000-0000-000000000001',
    1,
    'How many quarters are in a football game?',
    '["2 quarters", "3 quarters", "4 quarters", "5 quarters"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: From GS1 - Quarter length
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000026-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000026',
    'mcq',
    'In the NFL, how long is each quarter?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000026-0001-0001-0000-000000000002',
    '00000026-0001-0000-0000-000000000002',
    1,
    'In the NFL, how long is each quarter?',
    '["10 minutes", "15 minutes", "20 minutes", "30 minutes"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: From GS1 - Halftime
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000026-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000026',
    'mcq',
    'Between which quarters does halftime occur?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000026-0001-0001-0000-000000000003',
    '00000026-0001-0000-0000-000000000003',
    1,
    'Between which quarters does halftime occur?',
    '["1st and 2nd", "2nd and 3rd", "3rd and 4th", "After the 4th"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: From GS2 - Timeout
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000026-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000026',
    'mcq',
    'What happens when a team calls a timeout?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000026-0001-0001-0000-000000000004',
    '00000026-0001-0000-0000-000000000004',
    1,
    'What happens when a team calls a timeout?',
    '["The game clock stops and the team gets a short break", "The game ends", "A penalty is called", "The other team scores"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: From GS2 - Overtime
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000026-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000026',
    'mcq',
    'When does a game go to overtime?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000026-0001-0001-0000-000000000005',
    '00000026-0001-0000-0000-000000000005',
    1,
    'When does a game go to overtime?',
    '["When one team is winning by a lot", "When the score is tied at the end of the 4th quarter", "At halftime", "Every game has overtime"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: From ST1 - What is a kickoff?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000026-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000026',
    'mcq',
    'When does a kickoff occur?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000026-0001-0001-0000-000000000006',
    '00000026-0001-0000-0000-000000000006',
    1,
    'When does a kickoff occur?',
    '["Only at halftime", "Only after penalties", "At the start of each half and after a team scores", "Every play"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: From ST1 - What is a punt?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000026-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000026',
    'mcq',
    'Why would a team punt the ball?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000026-0001-0001-0000-000000000007',
    '00000026-0001-0000-0000-000000000007',
    1,
    'Why would a team punt the ball?',
    '["On 4th down to push the other team back when they can''t get a first down", "To score a touchdown", "To stop the clock", "To call a timeout"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: From ST2 - What is a touchback?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000026-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000026',
    'mcq',
    'What is a touchback?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000026-0001-0001-0000-000000000008',
    '00000026-0001-0000-0000-000000000008',
    1,
    'What is a touchback?',
    '["A touchdown", "When a kick goes into the end zone and the receiving team gets the ball at a set yard line", "A penalty", "A type of pass"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: From ST2 - What is a fair catch?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000026-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000026',
    'mcq',
    'What happens when a player signals for a fair catch?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000026-0001-0001-0000-000000000009',
    '00000026-0001-0000-0000-000000000009',
    1,
    'What happens when a player signals for a fair catch?',
    '["They can run with the ball", "The play is replayed", "They catch the ball safely without being tackled, but can''t run", "A penalty is called"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q10: From GS2 - Two-minute warning
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000026-0001-0000-0000-000000000010',
    '00000001-0000-0000-0000-000000000026',
    'binary',
    'The two-minute warning is an automatic stoppage when 2 minutes remain in the 2nd and 4th quarters.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000026-0001-0001-0000-000000000010',
    '00000026-0001-0000-0000-000000000010',
    1,
    'The two-minute warning is an automatic stoppage when 2 minutes remain in the 2nd and 4th quarters.',
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
    'Rookie Game Structure Quiz' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000026'

UNION ALL

SELECT
    'Quiz Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000026';
