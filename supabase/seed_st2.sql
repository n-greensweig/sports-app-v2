-- ============================================================================
-- ST2 (Special Teams 2) - Seed Data
-- ============================================================================
-- ST2 is the TWENTY-FIFTH lesson (ORDER: 25)
-- ST2 covers: Touchback, fair catch, field goal attempts
--
-- Prerequisites: ST1 (kickoff, punt)
-- Terms INTRODUCED here: Touchback, fair catch
--
-- Can reference: Kickoff, punt, field goal, end zone, special teams
--
-- Structure:
-- - ST2 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create ST2 Lesson (ORDER: 25)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000022',
    '11111111-1111-1111-1111-111111111111',
    'Special Teams 2',
    'Learn about touchbacks and fair catches - ways to safely receive kicks.',
    25,
    4,
    50,
    true,
    'ST2',
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
-- STEP 5: Create ST2 Items (9 questions - touchback, fair catch)
-- ============================================================================

-- Q1: What is a touchback?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000022-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000022',
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
    '00000022-0001-0001-0000-000000000001',
    '00000022-0001-0000-0000-000000000001',
    1,
    'What is a touchback?',
    '["A type of touchdown", "When a kick goes into or through the end zone and the receiving team gets the ball at a set yard line", "A penalty for touching the ball too soon", "A type of fumble"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: Where does the ball go after a touchback?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000022-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000022',
    'mcq',
    'After a touchback on a kickoff in the NFL, where does the receiving team start with the ball?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000022-0001-0001-0000-000000000002',
    '00000022-0001-0000-0000-000000000002',
    1,
    'After a touchback on a kickoff in the NFL, where does the receiving team start with the ball?',
    '["Their own 20-yard line", "The 50-yard line", "Their own 25-yard line", "Their own 10-yard line"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What is a fair catch?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000022-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000022',
    'mcq',
    'What is a "fair catch"?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000022-0001-0001-0000-000000000003',
    '00000022-0001-0000-0000-000000000003',
    1,
    'What is a "fair catch"?',
    '["When a player waves their arm before catching a kick, signaling they won''t run and can''t be tackled", "A catch made with both hands", "A catch in the end zone", "A pass caught by a running back"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: Why signal fair catch?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000022-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000022',
    'mcq',
    'Why would a player signal for a fair catch?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000022-0001-0001-0000-000000000004',
    '00000022-0001-0000-0000-000000000004',
    1,
    'Why would a player signal for a fair catch?',
    '["To score extra points", "To safely catch the ball without getting hit by defenders", "To stop the game clock", "To challenge the play"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: Fair catch signal
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000022-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000022',
    'mcq',
    'How does a player signal for a fair catch?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000022-0001-0001-0000-000000000005',
    '00000022-0001-0000-0000-000000000005',
    1,
    'How does a player signal for a fair catch?',
    '["By waving one arm above their head while the ball is in the air", "By yelling ''fair catch''", "By kneeling down", "By pointing at the ball"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Can't run after fair catch - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000022-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000022',
    'binary',
    'After signaling and making a fair catch, the player cannot run with the ball.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000022-0001-0001-0000-000000000006',
    '00000022-0001-0000-0000-000000000006',
    1,
    'After signaling and making a fair catch, the player cannot run with the ball.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Touchback is safe - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000022-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000022',
    'binary',
    'Taking a touchback (by kneeling in the end zone) is a safe option because the player avoids getting tackled.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000022-0001-0001-0000-000000000007',
    '00000022-0001-0000-0000-000000000007',
    1,
    'Taking a touchback (by kneeling in the end zone) is a safe option because the player avoids getting tackled.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Situational - kickoff into end zone
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000022-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000022',
    'mcq',
    'The Indianapolis Colts kick the ball deep on a kickoff. It goes into the end zone and the return man catches it but kneels down instead of running. What is this called?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000022-0001-0001-0000-000000000008',
    '00000022-0001-0000-0000-000000000008',
    1,
    'The Indianapolis Colts kick the ball deep on a kickoff. It goes into the end zone and the return man catches it but kneels down instead of running. What is this called?',
    '["A touchback", "A fair catch", "A fumble", "A touchdown"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Situational - fair catch on punt
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000022-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000022',
    'mcq',
    'The Atlanta Falcons punt the ball. The return man sees defenders running toward him quickly, so he waves his arm above his head before catching the ball. What happens next?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000022-0001-0001-0000-000000000009',
    '00000022-0001-0000-0000-000000000009',
    1,
    'The Atlanta Falcons punt the ball. The return man sees defenders running toward him quickly, so he waves his arm above his head before catching the ball. What happens next?',
    '["The defenders can tackle him immediately", "The play is dead and the ball is placed at the 25-yard line", "He makes a fair catch - the play ends where he caught it and he can''t be hit", "The punt is replayed"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'ST2 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000022'

UNION ALL

SELECT
    'ST2 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000022';
