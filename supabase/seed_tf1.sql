-- ============================================================================
-- TF1 (The Field 1) - Seed Data
-- ============================================================================
-- This seed creates the Rookie section and the first lesson (TF1)
-- TF1 covers: Dimensions, markings (yard lines), goal lines, end zones
--
-- Structure:
-- - Rookie Module (Section)
-- - TF1 Lesson (9 questions, 5 shown per session, 3 completions to master)
-- ============================================================================

-- ============================================================================
-- STEP 1: Ensure Football sport exists
-- ============================================================================

INSERT INTO sports (id, slug, name, accent_color, description, order_index, is_active)
VALUES (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    'football',
    'Football',
    '#2E7D32',
    'American Football - NFL and College',
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
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
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
-- STEP 3: Create TF1 Lesson
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000001',
    '11111111-1111-1111-1111-111111111111',
    'The Field 1',
    'Learn about field dimensions, yard lines, goal lines, and end zones',
    1,
    4,
    50,
    false,
    'TF1',
    5,
    3
)
ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    code = EXCLUDED.code,
    items_per_session = EXCLUDED.items_per_session,
    required_completions = EXCLUDED.required_completions;


-- ============================================================================
-- STEP 4: Create System User for content authoring (if not exists)
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
-- STEP 5: Create TF1 Items (9 questions)
-- ============================================================================

-- Q1: Field length (Dimensions)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000001-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000001',
    'mcq',
    'How long is a football field from goal line to goal line?',
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
    'How long is a football field from goal line to goal line?',
    '["80 yards", "100 yards", "120 yards", "150 yards"]',
    '{"index": 1}',
    'A football field is exactly 100 yards (300 feet) from goal line to goal line. The end zones add another 10 yards on each side.',
    true
)
ON CONFLICT (id) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext;


-- Q2: Field width (Dimensions)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000001-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000001',
    'mcq',
    'How wide is a regulation football field?',
    '{"correct_index": 1}',
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
    'How wide is a regulation football field?',
    '["40 yards", "53⅓ yards", "60 yards", "75 yards"]',
    '{"index": 1}',
    'A regulation football field is 53⅓ yards (160 feet) wide. This width is the same for both NFL and college football.',
    true
)
ON CONFLICT (id) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext;


-- Q3: End zone depth (End zones)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000001-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000001',
    'binary',
    'Each end zone is 10 yards deep.',
    '{"correct_boolean": true}',
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
    'Each end zone is 10 yards deep.',
    '["True", "False"]',
    '{"boolean": true}',
    'Correct! Each end zone extends 10 yards beyond the goal line, adding 20 total yards to the field''s overall length of 120 yards.',
    true
)
ON CONFLICT (id) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext;


-- Q4: Yard line markings (Markings)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000001-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000001',
    'mcq',
    'Yard lines are marked on the field every how many yards?',
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
    'Yard lines are marked on the field every how many yards?',
    '["1 yard", "5 yards", "10 yards", "20 yards"]',
    '{"index": 1}',
    'Yard lines are painted across the field every 5 yards. Numbers are displayed every 10 yards to help players and fans track field position.',
    true
)
ON CONFLICT (id) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext;


-- Q5: Goal line / touchdown (Goal lines)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000001-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000001',
    'mcq',
    'What does a player need to do to score a touchdown?',
    '{"correct_index": 1}',
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
    'What does a player need to do to score a touchdown?',
    '["Touch the goal line", "Cross the goal line with the ball", "Throw the ball over the goal line", "Kick the ball through the uprights"]',
    '{"index": 1}',
    'To score a touchdown, the ball must cross (or "break the plane of") the goal line while in a player''s possession. The goal line is the front edge of the end zone.',
    true
)
ON CONFLICT (id) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext;


-- Q6: Total field length (Dimensions)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000001-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000001',
    'mcq',
    'Including both end zones, how long is a football field in total?',
    '{"correct_index": 2}',
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
    'Including both end zones, how long is a football field in total?',
    '["100 yards", "110 yards", "120 yards", "130 yards"]',
    '{"index": 2}',
    'The total length is 120 yards: 100 yards of playing field plus two 10-yard end zones (one at each end).',
    true
)
ON CONFLICT (id) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext;


-- Q7: 50-yard line (Markings)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000001-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000001',
    'binary',
    'The 50-yard line is at the exact center of the field.',
    '{"correct_boolean": true}',
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
    'The 50-yard line is at the exact center of the field.',
    '["True", "False"]',
    '{"boolean": true}',
    'The 50-yard line marks the midfield point, exactly halfway between both goal lines. Yard numbers count down from 50 toward each end zone (50, 40, 30, 20, 10).',
    true
)
ON CONFLICT (id) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext;


-- Q8: End zone purpose (End zones)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000001-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000001',
    'mcq',
    'What is the primary purpose of the end zone?',
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
    'What is the primary purpose of the end zone?',
    '["A rest area for tired players", "The scoring area for touchdowns", "Where the coaches stand", "A warmup area before plays"]',
    '{"index": 1}',
    'The end zone is the scoring area! When an offensive player carries or catches the ball in the end zone, their team scores a touchdown (6 points).',
    true
)
ON CONFLICT (id) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext;


-- Q9: Goal line location (Goal lines)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000001-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000001',
    'mcq',
    'Where is the goal line located?',
    '{"correct_index": 2}',
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
    'Where is the goal line located?',
    '["In the middle of the end zone", "At the back of the end zone", "At the front edge of the end zone", "Behind the goalposts"]',
    '{"index": 2}',
    'The goal line is at the front edge of the end zone, separating the 100-yard playing field from the end zone. It''s the line a player must cross to score a touchdown.',
    true
)
ON CONFLICT (id) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

-- Verify the data was inserted correctly
SELECT
    'Modules' as entity,
    COUNT(*) as count
FROM modules
WHERE sport_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'

UNION ALL

SELECT
    'Lessons' as entity,
    COUNT(*) as count
FROM lessons
WHERE module_id = '11111111-1111-1111-1111-111111111111'

UNION ALL

SELECT
    'Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000001';
