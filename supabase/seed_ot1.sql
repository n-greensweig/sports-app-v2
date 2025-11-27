-- ============================================================================
-- OT1 (Offensive Terms 1) - Seed Data
-- ============================================================================
-- OT1 covers: Run, pass, catch, first down
--
-- Structure:
-- - OT1 Lesson (9 questions, 5 shown per session, 5 completions to master)
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
-- STEP 4: Create OT1 Lesson
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000003',
    '11111111-1111-1111-1111-111111111111',
    'Offensive Terms 1',
    'Learn the basic offensive plays: running, passing, catching, and what a first down means',
    3,
    4,
    50,
    true,
    'OT1',
    5,
    5
)
ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    code = EXCLUDED.code,
    items_per_session = EXCLUDED.items_per_session,
    required_completions = EXCLUDED.required_completions;


-- ============================================================================
-- STEP 5: Create OT1 Items (10 questions)
-- ============================================================================

-- Q1: What is a run play? (Run)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000003-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000003',
    'mcq',
    'What is a "run play" in football?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000003-0001-0001-0000-000000000001',
    '00000003-0001-0000-0000-000000000001',
    1,
    'What is a "run play" in football?',
    '["When a player kicks the ball downfield", "When a player carries the ball and runs with it", "When the quarterback throws the ball to a receiver", "When the defense tackles the quarterback"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q2: What is a pass play? (Pass)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000003-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000003',
    'mcq',
    'What is a "pass play" in football?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000003-0001-0001-0000-000000000002',
    '00000003-0001-0000-0000-000000000002',
    1,
    'What is a "pass play" in football?',
    '["When a player runs with the ball", "When the ball is kicked through the uprights", "When the quarterback throws the ball to a teammate", "When the defense intercepts the ball"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q3: What is a catch? (Catch)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000003-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000003',
    'mcq',
    'What must happen for a receiver to be credited with a "catch"?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000003-0001-0001-0000-000000000003',
    '00000003-0001-0000-0000-000000000003',
    1,
    'What must happen for a receiver to be credited with a "catch"?',
    '["Secure the ball with control while inbounds", "Touch the ball with one hand", "Have the ball hit their body", "Run a route downfield"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q4: What is a first down? (First Down)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000003-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000003',
    'mcq',
    'What is a "first down" in football?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000003-0001-0001-0000-000000000004',
    '00000003-0001-0000-0000-000000000004',
    1,
    'What is a "first down" in football?',
    '["The first play of the game", "When the offense gains 10 yards and gets a new set of 4 downs", "When the defense stops the offense", "The first quarter of the game"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q5: How many downs to get a first down? (First Down)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000003-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000003',
    'mcq',
    'How many attempts (downs) does an offense have to gain 10 yards for a first down?',
    '{"correct_index": 3}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000003-0001-0001-0000-000000000005',
    '00000003-0001-0000-0000-000000000005',
    1,
    'How many attempts (downs) does an offense have to gain 10 yards for a first down?',
    '["2 downs", "3 downs", "5 downs", "4 downs"]',
    '{"index": 3}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q7: Who typically throws passes? (Pass)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000003-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000003',
    'mcq',
    'Which player typically throws the ball on a pass play?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000003-0001-0001-0000-000000000007',
    '00000003-0001-0000-0000-000000000007',
    1,
    'Which player typically throws the ball on a pass play?',
    '["Quarterback", "Wide receiver", "Running back", "Linebacker"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q8: Situational - First down scenario (First Down)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000003-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000003',
    'mcq',
    'The Dallas Cowboys have the ball at their own 30-yard line. It''s 1st and 10. The running back gains 6 yards. What down is it now?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    2
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000003-0001-0001-0000-000000000008',
    '00000003-0001-0000-0000-000000000008',
    1,
    'The Dallas Cowboys have the ball at their own 30-yard line. It''s 1st and 10. The running back gains 6 yards. What down is it now?',
    '["1st and 4", "2nd and 4", "2nd and 10", "1st and 10"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q9: Situational - First down achieved (First Down)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000003-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000003',
    'mcq',
    'The Kansas City Chiefs have the ball at the 50-yard line. It''s 2nd and 8. The quarterback throws a 15-yard pass to a wide receiver. What happens next?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    2
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000003-0001-0001-0000-000000000009',
    '00000003-0001-0000-0000-000000000009',
    1,
    'The Kansas City Chiefs have the ball at the 50-yard line. It''s 2nd and 8. The quarterback throws a 15-yard pass to a wide receiver. What happens next?',
    '["First down! New set of 4 downs at the opponent''s 35", "3rd and 7 at the opponent''s 35", "2nd and 8 at the 50", "Touchdown"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- Q10: Situational - Run play result (Run/First Down)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000003-0001-0000-0000-000000000010',
    '00000001-0000-0000-0000-000000000003',
    'mcq',
    'The Philadelphia Eagles are on 3rd down with 2 yards to go for a first down. The running back takes a handoff and runs for 3 yards. What is the result?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    2
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000003-0001-0001-0000-000000000010',
    '00000003-0001-0000-0000-000000000010',
    1,
    'The Philadelphia Eagles are on 3rd down with 2 yards to go for a first down. The running back takes a handoff and runs for 3 yards. What is the result?',
    '["4th and short", "Incomplete pass", "First down! New set of 4 downs", "Turnover on downs"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, explanation_richtext = EXCLUDED.explanation_richtext;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

-- Verify the data was inserted correctly
SELECT
    'OT1 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000003'

UNION ALL

SELECT
    'OT1 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000003';
