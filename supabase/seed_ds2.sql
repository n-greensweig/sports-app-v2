-- ============================================================================
-- DS2 (The Downs 2) - Seed Data
-- ============================================================================
-- DS2 is the SIXTH lesson (after GB1, TF1, TF2, SC1, DS1)
-- DS2 covers: "1st and 10" notation, down progression (1st->2nd->3rd->4th),
--             what happens if you fail (turnover on downs)
--
-- Prerequisites: DS1 (4 downs, 10 yards concept)
-- Terms INTRODUCED here: "1st and 10", "2nd and 5", down progression, turnover on downs
--
-- CRITICAL: Now we can use down notation in questions!
-- Still NO play types yet (run/pass) - that's PT1
--
-- Structure:
-- - DS2 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create DS2 Lesson (ORDER: 6)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000006',
    '11111111-1111-1111-1111-111111111111',
    'The Downs 2',
    'Learn to read "1st and 10" and understand how downs progress during a game.',
    6,
    4,
    50,
    true,
    'DS2',
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
-- STEP 5: Create DS2 Items (9 questions - down notation and progression)
-- ============================================================================

-- Q1: What does "1st and 10" mean?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000006-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000006',
    'mcq',
    'When you see "1st and 10" on TV, what does it mean?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000006-0001-0001-0000-000000000001',
    '00000006-0001-0000-0000-000000000001',
    1,
    'When you see "1st and 10" on TV, what does it mean?',
    '["1 minute and 10 seconds left", "It''s the 1st down and 10 yards are needed for a new set of downs", "The score is 1 to 10", "1 player and 10 yards to the end zone"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: First number = which down
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000006-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000006',
    'mcq',
    'In "2nd and 7", what does the "2nd" tell you?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000006-0001-0001-0000-000000000002',
    '00000006-0001-0000-0000-000000000002',
    1,
    'In "2nd and 7", what does the "2nd" tell you?',
    '["It''s the 2nd down (2nd attempt out of 4)", "There are 2 minutes left", "The team has 2 points", "There are 2 players on the field"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: Second number = yards needed
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000006-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000006',
    'mcq',
    'In "3rd and 4", what does the "4" tell you?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000006-0001-0001-0000-000000000003',
    '00000006-0001-0000-0000-000000000003',
    1,
    'In "3rd and 4", what does the "4" tell you?',
    '["4 minutes left in the quarter", "4 points scored", "4 yards are needed to get a new set of downs", "4 players are near the ball"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: Downs go 1st -> 2nd -> 3rd -> 4th
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000006-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000006',
    'mcq',
    'In what order do the downs progress?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000006-0001-0001-0000-000000000004',
    '00000006-0001-0000-0000-000000000004',
    1,
    'In what order do the downs progress?',
    '["4th, 3rd, 2nd, 1st", "1st, 2nd, 3rd, 4th", "1st, 1st, 1st, 1st", "It''s random"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: What comes after 1st down if they don't get 10 yards?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000006-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000006',
    'mcq',
    'It''s 1st and 10. The offense gains 3 yards. What down is it now?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000006-0001-0001-0000-000000000005',
    '00000006-0001-0000-0000-000000000005',
    1,
    'It''s 1st and 10. The offense gains 3 yards. What down is it now?',
    '["Still 1st down", "2nd down", "3rd down", "4th down"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: How do yards to go change?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000006-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000006',
    'mcq',
    'It''s 1st and 10. The offense gains 3 yards. How many yards do they need now?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000006-0001-0001-0000-000000000006',
    '00000006-0001-0000-0000-000000000006',
    1,
    'It''s 1st and 10. The offense gains 3 yards. How many yards do they need now?',
    '["Still 10 yards", "3 yards", "7 yards", "13 yards"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: What happens on 4th down if they fail?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000006-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000006',
    'mcq',
    'It''s 4th down and the offense doesn''t gain enough yards. What happens?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000006-0001-0001-0000-000000000007',
    '00000006-0001-0000-0000-000000000007',
    1,
    'It''s 4th down and the offense doesn''t gain enough yards. What happens?',
    '["The other team gets the ball (turnover on downs)", "They get a 5th down", "The game ends", "They score 1 point"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: What resets the downs?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000006-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000006',
    'mcq',
    'When do the downs reset back to 1st and 10?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000006-0001-0001-0000-000000000008',
    '00000006-0001-0000-0000-000000000008',
    1,
    'When do the downs reset back to 1st and 10?',
    '["After every play", "When the offense gains 10 or more yards total", "At the end of each quarter", "Never - they always count up"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Reading the notation - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000006-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000006',
    'binary',
    '"2nd and 7" means it''s the 2nd down and the offense needs 7 more yards for a new set of downs.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000006-0001-0001-0000-000000000009',
    '00000006-0001-0000-0000-000000000009',
    1,
    '"2nd and 7" means it''s the 2nd down and the offense needs 7 more yards for a new set of downs.',
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
    'DS2 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000006'

UNION ALL

SELECT
    'DS2 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000006';
