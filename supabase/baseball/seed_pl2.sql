-- ============================================================================
-- PL2 (Plays 2) - Baseball Seed Data
-- ============================================================================
-- PL2 is the TENTH lesson (after PL1)
-- PL2 covers: Double plays, stealing bases, situational plays
--
-- Prerequisites: GB1-PL1 (outs, force outs, tag outs)
-- Terms INTRODUCED here: double play, stolen base, caught stealing,
--                        pickoff, tag up
--
-- Structure:
-- - PL2 Lesson (9 questions, 5 shown per session, 5 completions to master)
-- ============================================================================

-- ============================================================================
-- STEP 1: Ensure Baseball sport exists
-- ============================================================================

INSERT INTO sports (id, slug, name, accent_color, description, order_index, is_active)
VALUES (
    '02ba5eba-1100-0000-0000-000000000000',
    'baseball',
    'Baseball',
    '#C41E3A',
    'Baseball - MLB and College',
    2,
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
    '22222222-2222-2222-2222-222222222222',
    '02ba5eba-1100-0000-0000-000000000000',
    'Rookie',
    'Start your baseball journey! Learn the basics of the diamond, scoring, and key terms.',
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
-- STEP 4: Create PL2 Lesson (ORDER: 10)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-00000000000a',
    '22222222-2222-2222-2222-222222222222',
    'Plays 2',
    'Learn about double plays, stolen bases, and strategic plays.',
    10,
    4,
    50,
    true,
    'PL2',
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
-- STEP 5: Create PL2 Items (9 questions)
-- ============================================================================

-- Q1: What is a double play?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002a-0001-0000-0000-000000000001',
    '00000002-0000-0000-0000-00000000000a',
    'mcq',
    'What is a "double play"?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002a-0001-0001-0000-000000000001',
    '0000002a-0001-0000-0000-000000000001',
    1,
    'What is a "double play"?',
    '["When a batter hits the ball twice", "When a runner scores two runs", "When the defense gets two outs on one play", "When a pitcher throws two strikes in a row"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: Common double play scenario
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002a-0001-0000-0000-000000000002',
    '00000002-0000-0000-0000-00000000000a',
    'mcq',
    'The most common double play starts with a ground ball. If there''s a runner on first, what typically happens?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002a-0001-0001-0000-000000000002',
    '0000002a-0001-0000-0000-000000000002',
    1,
    'The most common double play starts with a ground ball. If there''s a runner on first, what typically happens?',
    '["The fielder throws to second for the force out, then second base throws to first for another force out", "Both runners go home", "The batter runs to second base", "The pitcher catches the ball"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: What is a stolen base?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002a-0001-0000-0000-000000000003',
    '00000002-0000-0000-0000-00000000000a',
    'mcq',
    'What is a "stolen base"?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002a-0001-0001-0000-000000000003',
    '0000002a-0001-0000-0000-000000000003',
    1,
    'What is a "stolen base"?',
    '["Taking a base that was removed from the field", "When a runner advances to the next base during a pitch, without the batter hitting the ball", "Running backwards around the bases", "When the defense loses track of the ball"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: What is caught stealing?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002a-0001-0000-0000-000000000004',
    '00000002-0000-0000-0000-00000000000a',
    'mcq',
    'What does "caught stealing" mean?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002a-0001-0001-0000-000000000004',
    '0000002a-0001-0000-0000-000000000004',
    1,
    'What does "caught stealing" mean?',
    '["The runner was caught taking a base that wasn''t theirs", "The batter was caught cheating", "A runner tried to steal a base but was tagged out before reaching it", "The umpire caught a mistake"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: What is a pickoff?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002a-0001-0000-0000-000000000005',
    '00000002-0000-0000-0000-00000000000a',
    'mcq',
    'What is a "pickoff"?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002a-0001-0001-0000-000000000005',
    '0000002a-0001-0000-0000-000000000005',
    1,
    'What is a "pickoff"?',
    '["When a pitcher or catcher throws to a base to try to get a runner out before they can return", "When a fielder picks up a ground ball", "When the batter picks which pitch to swing at", "Choosing a player in the draft"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Tag up explained
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002a-0001-0000-0000-000000000006',
    '00000002-0000-0000-0000-00000000000a',
    'mcq',
    'What does it mean to "tag up"?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002a-0001-0001-0000-000000000006',
    '0000002a-0001-0000-0000-000000000006',
    1,
    'What does it mean to "tag up"?',
    '["To tag a runner out", "On a fly ball, a runner returns to their base and can advance after the catch is made", "To switch players during the game", "To add a run to the scoreboard"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Triple play
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002a-0001-0000-0000-000000000007',
    '00000002-0000-0000-0000-00000000000a',
    'mcq',
    'A "triple play" is very rare. What is it?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002a-0001-0001-0000-000000000007',
    '0000002a-0001-0000-0000-000000000007',
    1,
    'A "triple play" is very rare. What is it?',
    '["When a batter hits a triple", "When three runners score on one play", "When the defense gets three outs on one play", "When a pitcher strikes out three batters in a row"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Runners can steal on any pitch - True/False
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002a-0001-0000-0000-000000000008',
    '00000002-0000-0000-0000-00000000000a',
    'binary',
    'Runners can attempt to steal a base as soon as the pitcher begins their motion to throw.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002a-0001-0001-0000-000000000008',
    '0000002a-0001-0000-0000-000000000008',
    1,
    'Runners can attempt to steal a base as soon as the pitcher begins their motion to throw.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Sacrifice fly scenario
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '0000002a-0001-0000-0000-000000000009',
    '00000002-0000-0000-0000-00000000000a',
    'mcq',
    'There''s a runner on third base with less than 2 outs. The batter hits a deep fly ball that is caught. What can the runner on third do?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '0000002a-0001-0001-0000-000000000009',
    '0000002a-0001-0000-0000-000000000009',
    1,
    'There''s a runner on third base with less than 2 outs. The batter hits a deep fly ball that is caught. What can the runner on third do?',
    '["They are automatically out", "They can ''tag up'' (touch third base after the catch) and try to score", "They must stay at third base no matter what", "They must run to home immediately"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'PL2 Lesson' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000002-0000-0000-0000-00000000000a'

UNION ALL

SELECT
    'PL2 Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000002-0000-0000-0000-00000000000a';
