-- ============================================================================
-- GS2 (Game Structure 2) - Seed Data
-- ============================================================================
-- GS2 is the TWENTY-THIRD lesson (ORDER: 23)
-- GS2 covers: Timeouts, two-minute warning, overtime
--
-- Prerequisites: GS1 (quarters, halftime, game clock)
-- Terms INTRODUCED here: Timeout, two-minute warning, overtime
--
-- Can reference: Quarters, halftime, game clock, scoring
--
-- Structure:
-- - GS2 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create GS2 Lesson (ORDER: 23)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000020',
    '11111111-1111-1111-1111-111111111111',
    'Game Structure 2',
    'Learn about timeouts, the two-minute warning, and what happens when the game is tied.',
    23,
    4,
    50,
    true,
    'GS2',
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
-- STEP 5: Create GS2 Items (9 questions - timeouts, two-minute warning, overtime)
-- ============================================================================

-- Q1: What is a timeout?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000020-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000020',
    'mcq',
    'What is a timeout in football?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000020-0001-0001-0000-000000000001',
    '00000020-0001-0000-0000-000000000001',
    1,
    'What is a timeout in football?',
    '["A penalty for taking too long", "A short break where the game clock stops so a team can rest or plan", "The end of a quarter", "A type of scoring play"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: How many timeouts per half?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000020-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000020',
    'mcq',
    'In the NFL, how many timeouts does each team get per half?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000020-0001-0001-0000-000000000002',
    '00000020-0001-0000-0000-000000000002',
    1,
    'In the NFL, how many timeouts does each team get per half?',
    '["1 timeout", "2 timeouts", "3 timeouts", "5 timeouts"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What is the two-minute warning?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000020-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000020',
    'mcq',
    'What is the "two-minute warning" in football?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000020-0001-0001-0000-000000000003',
    '00000020-0001-0000-0000-000000000003',
    1,
    'What is the "two-minute warning" in football?',
    '["An automatic stoppage when 2 minutes remain in the 2nd and 4th quarters", "A warning given to players for bad behavior", "A timeout that lasts 2 minutes", "A signal that overtime is about to start"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: What is overtime?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000020-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000020',
    'mcq',
    'What is overtime in football?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000020-0001-0001-0000-000000000004',
    '00000020-0001-0000-0000-000000000004',
    1,
    'What is overtime in football?',
    '["The last 2 minutes of the 4th quarter", "Extra time added for penalties", "An extra period played when the game is tied at the end of regulation", "A longer halftime break"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: When does overtime happen?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000020-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000020',
    'mcq',
    'When do teams play overtime?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000020-0001-0001-0000-000000000005',
    '00000020-0001-0000-0000-000000000005',
    1,
    'When do teams play overtime?',
    '["Every game has overtime", "When the score is tied at the end of the 4th quarter", "When one team requests it", "At halftime"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Timeout stops clock - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000020-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000020',
    'binary',
    'When a team calls a timeout, the game clock stops.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000020-0001-0001-0000-000000000006',
    '00000020-0001-0000-0000-000000000006',
    1,
    'When a team calls a timeout, the game clock stops.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Two-minute warning is like a timeout - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000020-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000020',
    'binary',
    'The two-minute warning acts like a free timeout - the game clock stops and both teams get a short break.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000020-0001-0001-0000-000000000007',
    '00000020-0001-0000-0000-000000000007',
    1,
    'The two-minute warning acts like a free timeout - the game clock stops and both teams get a short break.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Situational - saving timeouts
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000020-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000020',
    'mcq',
    'The Minnesota Vikings are losing by 4 points with 1 minute left in the 4th quarter. They have 2 timeouts remaining. Why might they use a timeout?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000020-0001-0001-0000-000000000008',
    '00000020-0001-0000-0000-000000000008',
    1,
    'The Minnesota Vikings are losing by 4 points with 1 minute left in the 4th quarter. They have 2 timeouts remaining. Why might they use a timeout?',
    '["To stop the clock and save time so they have more chances to score", "To give the other team extra points", "To end the game early", "Timeouts are only used at halftime"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Situational - overtime tied game
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000020-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000020',
    'mcq',
    'The score is Jacksonville Jaguars 21, Tennessee Titans 21 as the 4th quarter ends. What happens next?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000020-0001-0001-0000-000000000009',
    '00000020-0001-0000-0000-000000000009',
    1,
    'The score is Jacksonville Jaguars 21, Tennessee Titans 21 as the 4th quarter ends. What happens next?',
    '["The game ends in a tie", "They flip a coin to decide the winner", "The game goes to overtime to determine a winner", "Both teams win"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'GS2 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000020'

UNION ALL

SELECT
    'GS2 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000020';
