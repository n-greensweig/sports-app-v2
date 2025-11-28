-- ============================================================================
-- GB1 (Game Basics 1) - Seed Data
-- ============================================================================
-- GB1 is the FIRST lesson - assumes ZERO football knowledge
-- GB1 covers: What is football? Two teams, offense/defense, end zone objective
--
-- CRITICAL: This lesson uses ONLY basic everyday words. No football jargon.
-- Terms INTRODUCED here: offense, defense, end zone, possession
--
-- Structure:
-- - GB1 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create GB1 Lesson (ORDER: 1 - First lesson!)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000001',
    '11111111-1111-1111-1111-111111111111',
    'Game Basics 1',
    'What is football? Learn the basic objective and how two teams compete.',
    1,
    4,
    50,
    false,
    'GB1',
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
-- STEP 5: Create GB1 Items (9 questions)
-- ============================================================================

-- Q1: How many teams play?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000001-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000001',
    'mcq',
    'How many teams play in a football game?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000001-0001-0001-0000-000000000001',
    '00000001-0001-0000-0000-000000000001',
    1,
    'How many teams play in a football game?',
    '["1 team", "2 teams", "3 teams", "4 teams"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: What is the offense trying to do?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000001-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000001',
    'mcq',
    'In football, the "offense" is the team that has the ball. What is the offense trying to do?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000001-0001-0001-0000-000000000002',
    '00000001-0001-0000-0000-000000000002',
    1,
    'In football, the "offense" is the team that has the ball. What is the offense trying to do?',
    '["Stop the other team from scoring", "Kick the ball as far as possible", "Move the ball toward the opponent''s end of the field to score", "Stay in one place and protect the ball"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What is the defense trying to do?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000001-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000001',
    'mcq',
    'The "defense" is the team that does NOT have the ball. What is the defense trying to do?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000001-0001-0001-0000-000000000003',
    '00000001-0001-0000-0000-000000000003',
    1,
    'The "defense" is the team that does NOT have the ball. What is the defense trying to do?',
    '["Stop the offense from moving the ball and scoring", "Score points for their team", "Pass the ball to teammates", "Run with the ball toward the end zone"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: What is the end zone?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000001-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000001',
    'mcq',
    'Each end of the football field has an "end zone." What is the end zone?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000001-0001-0001-0000-000000000004',
    '00000001-0001-0000-0000-000000000004',
    1,
    'Each end of the football field has an "end zone." What is the end zone?',
    '["Where players rest between plays", "The scoring area at each end of the field", "Where the coaches stand", "The middle of the field"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: Teams take turns - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000001-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000001',
    'binary',
    'In football, the two teams take turns being on offense and defense.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000001-0001-0001-0000-000000000005',
    '00000001-0001-0000-0000-000000000005',
    1,
    'In football, the two teams take turns being on offense and defense.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Which team has the ball?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000001-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000001',
    'mcq',
    'Which team has the ball - the offense or the defense?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000001-0001-0001-0000-000000000006',
    '00000001-0001-0000-0000-000000000006',
    1,
    'Which team has the ball - the offense or the defense?',
    '["The offense", "The defense", "Both teams share the ball", "Neither team has the ball"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Basic objective
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000001-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000001',
    'mcq',
    'What is the main goal for the offense in football?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000001-0001-0001-0000-000000000007',
    '00000001-0001-0000-0000-000000000007',
    1,
    'What is the main goal for the offense in football?',
    '["Keep the ball away from the other team forever", "Kick the ball out of the stadium", "Get the ball into the opponent''s end zone to score", "Throw the ball as far as possible"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Two end zones
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000001-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000001',
    'mcq',
    'How many end zones are on a football field?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000001-0001-0001-0000-000000000008',
    '00000001-0001-0000-0000-000000000008',
    1,
    'How many end zones are on a football field?',
    '["1 - in the middle", "2 - one at each end", "4 - one in each corner", "None"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Which end zone does offense want?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000001-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000001',
    'mcq',
    'There are two end zones on the field. Which end zone does the offense want to reach?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000001-0001-0001-0000-000000000009',
    '00000001-0001-0000-0000-000000000009',
    1,
    'There are two end zones on the field. Which end zone does the offense want to reach?',
    '["Their own end zone (behind them)", "The opponent''s end zone (in front of them)", "Either end zone - it doesn''t matter", "The end zone in the middle of the field"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'GB1 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000001'

UNION ALL

SELECT
    'GB1 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000001';
