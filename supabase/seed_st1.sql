-- ============================================================================
-- ST1 (Special Teams 1) - Seed Data
-- ============================================================================
-- ST1 is the TWENTY-FIRST lesson (ORDER: 21)
-- ST1 covers: Kickoff, punt, special teams basics
--
-- Prerequisites: SC2, GS1 (scoring, game structure)
-- Terms INTRODUCED here: Kickoff, punt, special teams
--
-- Can reference: Field goal, touchdown, quarters, starting plays
--
-- Structure:
-- - ST1 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create ST1 Lesson (ORDER: 21)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000021',
    '11111111-1111-1111-1111-111111111111',
    'Special Teams 1',
    'Learn about kickoffs and punts - special plays that transfer possession of the ball.',
    21,
    4,
    50,
    true,
    'ST1',
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
-- STEP 5: Create ST1 Items (9 questions - kickoff, punt, special teams)
-- ============================================================================

-- Q1: What is special teams?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000021-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000021',
    'mcq',
    'What are "special teams" in football?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000021-0001-0001-0000-000000000001',
    '00000021-0001-0000-0000-000000000001',
    1,
    'What are "special teams" in football?',
    '["The players who are on the field for kicking plays like kickoffs, punts, and field goals", "The best players on the team", "The players who only play offense", "The coaches on the sideline"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: What is a kickoff?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000021-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000021',
    'mcq',
    'What is a kickoff?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000021-0001-0001-0000-000000000002',
    '00000021-0001-0000-0000-000000000002',
    1,
    'What is a kickoff?',
    '["A penalty for kicking too hard", "A kick that starts each half and follows scoring plays, giving the ball to the other team", "A pass that travels very far", "A timeout called by the kicker"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: When does a kickoff happen?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000021-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000021',
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
    '00000021-0001-0001-0000-000000000003',
    '00000021-0001-0000-0000-000000000003',
    1,
    'When does a kickoff occur?',
    '["Only at halftime", "Only after penalties", "At the start of each half and after a team scores", "Every play"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: What is a punt?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000021-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000021',
    'mcq',
    'What is a punt?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000021-0001-0001-0000-000000000004',
    '00000021-0001-0000-0000-000000000004',
    1,
    'What is a punt?',
    '["A kick where a team gives up the ball by kicking it far down the field to the other team", "A long pass", "A type of touchdown", "A timeout"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: Why punt?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000021-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000021',
    'mcq',
    'Why would a team choose to punt the ball?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000021-0001-0001-0000-000000000005',
    '00000021-0001-0000-0000-000000000005',
    1,
    'Why would a team choose to punt the ball?',
    '["To score a touchdown", "On 4th down when they can''t get a first down, to push the other team back", "To stop the game clock", "To earn extra points"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Kickoff after TD - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000021-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000021',
    'binary',
    'After a team scores a touchdown (and attempts the extra point), there is a kickoff.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000021-0001-0001-0000-000000000006',
    '00000021-0001-0000-0000-000000000006',
    1,
    'After a team scores a touchdown (and attempts the extra point), there is a kickoff.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Punt on 4th down - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000021-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000021',
    'binary',
    'Teams usually punt on 4th down if they are too far from the end zone to try a field goal.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000021-0001-0001-0000-000000000007',
    '00000021-0001-0000-0000-000000000007',
    1,
    'Teams usually punt on 4th down if they are too far from the end zone to try a field goal.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Situational - start of game
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000021-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000021',
    'mcq',
    'The Cleveland Browns and Pittsburgh Steelers are about to start their game. What happens first?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000021-0001-0001-0000-000000000008',
    '00000021-0001-0000-0000-000000000008',
    1,
    'The Cleveland Browns and Pittsburgh Steelers are about to start their game. What happens first?',
    '["A punt", "A kickoff to start the game", "A field goal attempt", "A timeout"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Situational - 4th down decision
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000021-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000021',
    'mcq',
    'The Detroit Lions have the ball on 4th and 8 at their own 30-yard line. They are too far to attempt a field goal. What will they likely do?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000021-0001-0001-0000-000000000009',
    '00000021-0001-0000-0000-000000000009',
    1,
    'The Detroit Lions have the ball on 4th and 8 at their own 30-yard line. They are too far to attempt a field goal. What will they likely do?',
    '["Punt the ball to push the other team back", "Try to score a touchdown", "Call a timeout", "Kick a field goal anyway"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'ST1 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000021'

UNION ALL

SELECT
    'ST1 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000021';
