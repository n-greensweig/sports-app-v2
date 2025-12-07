-- ============================================================================
-- VETERAN MODULE - Complete Seed Data
-- ============================================================================
-- All Veteran module content in one file for easy deployment
--
-- Includes:
-- - Veteran Module definition
-- - 10 Lessons (PEN1, PEN2, FMT1, FMT2, CLK1, LNG1, LNG2, LG1, LG2, STR1)
-- - 1 Quiz (QZVET)
-- - Rookie Test-Out configuration and questions
-- - Veteran Test-Out configuration and questions
--
-- Module ID: 33333333-3333-3333-3333-333333333333
-- ============================================================================

-- ============================================================================
-- STEP 1: Ensure Football sport and System User exist
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
ON CONFLICT (slug) DO NOTHING;

INSERT INTO users (id, clerk_user_id, email, role)
VALUES (
    '00000000-0000-0000-0000-000000000000',
    'system',
    'system@olaball.app',
    'admin'
)
ON CONFLICT (clerk_user_id) DO NOTHING;

-- ============================================================================
-- STEP 2: Create Veteran Module
-- ============================================================================

INSERT INTO modules (id, sport_id, title, description, order_index, min_level, max_level, xp_reward)
VALUES (
    '33333333-3333-3333-3333-333333333333',
    '0105433b-5bdd-4093-b6b1-157a0c3c515e',
    'Veteran',
    'Level up your game! Master penalties, formations, clock management, and the language of football.',
    2,
    2,
    2,
    750
)
ON CONFLICT (id) DO UPDATE SET
    sport_id = EXCLUDED.sport_id,
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    order_index = EXCLUDED.order_index;

-- ============================================================================
-- LESSON 1: PEN1 (Penalties I)
-- Concepts: False start, offsides, holding, pass interference
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000003-0000-0000-0000-000000000001',
    '33333333-3333-3333-3333-333333333333',
    'Penalties I',
    'Learn the most common penalties: false start, offsides, holding, and pass interference.',
    1, 4, 50, true, 'PEN1', 5, 5
)
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, order_index = EXCLUDED.order_index;

-- PEN1 Q1: What is a false start?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0001-0000-0000-000000000001', '00000003-0000-0000-0000-000000000001', 'mcq', 'What is a "false start" penalty in football?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0001-0001-0000-000000000001', '00000003-0001-0000-0000-000000000001', 1, 'What is a "false start" penalty in football?', '["When a defensive player crosses the line before the snap", "When an offensive player moves before the ball is snapped", "When a player starts running too fast", "When the quarterback fakes a handoff"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- PEN1 Q2: What is offsides?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0001-0000-0000-000000000002', '00000003-0000-0000-0000-000000000001', 'mcq', 'What is an "offsides" penalty?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0001-0001-0000-000000000002', '00000003-0001-0000-0000-000000000002', 1, 'What is an "offsides" penalty?', '["When a defensive player crosses the line of scrimmage before the snap", "When a player goes out of bounds during a play", "When too many players are on the field", "When the offense takes too long to snap the ball"]', '{"index": 0}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- PEN1 Q3: False start vs offsides
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0001-0000-0000-000000000003', '00000003-0000-0000-0000-000000000001', 'binary', 'A false start is called on the offense, while offsides is called on the defense.', '{"correct_boolean": true}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0001-0001-0000-000000000003', '00000003-0001-0000-0000-000000000003', 1, 'A false start is called on the offense, while offsides is called on the defense.', '["True", "False"]', '{"boolean": true}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- PEN1 Q4: What is holding?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0001-0000-0000-000000000004', '00000003-0000-0000-0000-000000000001', 'mcq', 'What is a "holding" penalty?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0001-0001-0000-000000000004', '00000003-0001-0000-0000-000000000004', 1, 'What is a "holding" penalty?', '["Holding the ball too long before throwing", "Holding onto the goalposts", "Illegally grabbing or restraining an opponent", "Waiting too long in the huddle"]', '{"index": 2}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- PEN1 Q5: What is pass interference?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0001-0000-0000-000000000005', '00000003-0000-0000-0000-000000000001', 'mcq', 'What is "pass interference"?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0001-0001-0000-000000000005', '00000003-0001-0000-0000-000000000005', 1, 'What is "pass interference"?', '["Throwing the ball to the wrong receiver", "Illegally contacting or impeding a receiver trying to catch a pass", "When two receivers run into each other", "When the defense intercepts a pass"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- PEN1 Q6: False start penalty yards
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0001-0000-0000-000000000006', '00000003-0000-0000-0000-000000000001', 'mcq', 'How many yards is the penalty for a false start?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0001-0001-0000-000000000006', '00000003-0001-0000-0000-000000000006', 1, 'How many yards is the penalty for a false start?', '["5 yards", "10 yards", "15 yards", "Loss of down"]', '{"index": 0}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- PEN1 Q7: Offensive holding penalty yards
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0001-0000-0000-000000000007', '00000003-0000-0000-0000-000000000001', 'mcq', 'How many yards is the penalty for offensive holding?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0001-0001-0000-000000000007', '00000003-0001-0000-0000-000000000007', 1, 'How many yards is the penalty for offensive holding?', '["5 yards", "10 yards", "15 yards", "20 yards"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- PEN1 Q8: Pass interference scenario
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0001-0000-0000-000000000008', '00000003-0000-0000-0000-000000000001', 'mcq', 'A cornerback pushes a wide receiver before the ball arrives. What penalty is called?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 3)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0001-0001-0000-000000000008', '00000003-0001-0000-0000-000000000008', 1, 'A cornerback pushes a wide receiver before the ball arrives. What penalty is called?', '["Holding", "Offsides", "Pass interference", "Illegal contact"]', '{"index": 2}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- PEN1 Q9: Dead ball fouls (Multi-select)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0001-0000-0000-000000000009', '00000003-0000-0000-0000-000000000001', 'multi_select', 'Which of these penalties stop the play immediately? Select all that apply.', '{"correct_indices": [0]}', '00000000-0000-0000-0000-000000000000', 'live', 3)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0001-0001-0000-000000000009', '00000003-0001-0000-0000-000000000009', 1, 'Which of these penalties stop the play immediately? Select all that apply.', '["False start", "Offsides (when defense touches offense)", "Pass interference", "Holding"]', '{"indices": [0, 1]}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- ============================================================================
-- LESSON 2: PEN2 (Penalties II)
-- Concepts: Facemask, roughing the passer, delay of game, unsportsmanlike conduct
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000003-0000-0000-0000-000000000002',
    '33333333-3333-3333-3333-333333333333',
    'Penalties II',
    'Learn more penalties: facemask, roughing the passer, delay of game, and unsportsmanlike conduct.',
    2, 4, 50, true, 'PEN2', 5, 5
)
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, order_index = EXCLUDED.order_index;

-- PEN2 Q1: What is a facemask penalty?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0002-0000-0000-000000000001', '00000003-0000-0000-0000-000000000002', 'mcq', 'What is a "facemask" penalty?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0002-0001-0000-000000000001', '00000003-0002-0000-0000-000000000001', 1, 'What is a "facemask" penalty?', '["Wearing an illegal helmet", "Grabbing or pulling an opponent''s facemask", "Not wearing a mouthguard", "Having tinted visors"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- PEN2 Q2: What is roughing the passer?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0002-0000-0000-000000000002', '00000003-0000-0000-0000-000000000002', 'mcq', 'What is "roughing the passer"?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0002-0001-0000-000000000002', '00000003-0002-0000-0000-000000000002', 1, 'What is "roughing the passer"?', '["When the quarterback throws too hard", "Hitting the quarterback illegally after he releases the ball", "When the quarterback runs out of bounds", "Throwing an interception"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- PEN2 Q3: What is delay of game?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0002-0000-0000-000000000003', '00000003-0000-0000-0000-000000000002', 'mcq', 'What causes a "delay of game" penalty?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0002-0001-0000-000000000003', '00000003-0002-0000-0000-000000000003', 1, 'What causes a "delay of game" penalty?', '["Taking too long in the huddle", "The offense not snapping the ball before the play clock expires", "Running the ball too slowly", "Calling too many timeouts"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- PEN2 Q4: Unsportsmanlike conduct examples (Multi-select)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0002-0000-0000-000000000004', '00000003-0000-0000-0000-000000000002', 'multi_select', 'Which of these could result in an unsportsmanlike conduct penalty? Select all that apply.', '{"correct_indices": [0]}', '00000000-0000-0000-0000-000000000000', 'live', 3)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0002-0001-0000-000000000004', '00000003-0002-0000-0000-000000000004', 1, 'Which of these could result in an unsportsmanlike conduct penalty? Select all that apply.', '["Taunting an opponent after a touchdown", "Celebrating in the end zone", "Throwing a punch", "Making a legal tackle"]', '{"indices": [0, 2]}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- PEN2 Q5: Facemask penalty yards
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0002-0000-0000-000000000005', '00000003-0000-0000-0000-000000000002', 'mcq', 'How many yards is the penalty for a facemask?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0002-0001-0000-000000000005', '00000003-0002-0000-0000-000000000005', 1, 'How many yards is the penalty for a facemask?', '["5 yards", "10 yards", "15 yards", "Ejection"]', '{"index": 2}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- PEN2 Q6: Personal foul category
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0002-0000-0000-000000000006', '00000003-0000-0000-0000-000000000002', 'binary', 'Roughing the passer and facemask are both considered personal fouls.', '{"correct_boolean": true}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0002-0001-0000-000000000006', '00000003-0002-0000-0000-000000000006', 1, 'Roughing the passer and facemask are both considered personal fouls.', '["True", "False"]', '{"boolean": true}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- PEN2 Q7: Delay of game yards
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0002-0000-0000-000000000007', '00000003-0000-0000-0000-000000000002', 'mcq', 'How many yards is the penalty for delay of game?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0002-0001-0000-000000000007', '00000003-0002-0000-0000-000000000007', 1, 'How many yards is the penalty for delay of game?', '["5 yards", "10 yards", "15 yards", "Loss of down"]', '{"index": 0}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- PEN2 Q8: Roughing the passer scenario
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0002-0000-0000-000000000008', '00000003-0000-0000-0000-000000000002', 'mcq', 'The quarterback throws the ball, and two seconds later a defender tackles him hard. What penalty is likely called?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 3)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0002-0001-0000-000000000008', '00000003-0002-0000-0000-000000000008', 1, 'The quarterback throws the ball, and two seconds later a defender tackles him hard. What penalty is likely called?', '["Offsides", "Holding", "Roughing the passer", "Pass interference"]', '{"index": 2}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- PEN2 Q9: Automatic first down
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0002-0000-0000-000000000009', '00000003-0000-0000-0000-000000000002', 'binary', 'Roughing the passer gives the offense an automatic first down.', '{"correct_boolean": true}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0002-0001-0000-000000000009', '00000003-0002-0000-0000-000000000009', 1, 'Roughing the passer gives the offense an automatic first down.', '["True", "False"]', '{"boolean": true}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- ============================================================================
-- LESSON 3: FMT1 (Formations I)
-- Concepts: Shotgun, I-formation, single-back, spread offense basics
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000003-0000-0000-0000-000000000003',
    '33333333-3333-3333-3333-333333333333',
    'Formations I',
    'Learn basic offensive formations: shotgun, I-formation, single-back, and spread offense.',
    3, 4, 50, true, 'FMT1', 5, 5
)
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, order_index = EXCLUDED.order_index;

-- FMT1 Q1: What is shotgun formation?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0003-0000-0000-000000000001', '00000003-0000-0000-0000-000000000003', 'mcq', 'In the "shotgun" formation, where does the quarterback line up?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0003-0001-0000-000000000001', '00000003-0003-0000-0000-000000000001', 1, 'In the "shotgun" formation, where does the quarterback line up?', '["Directly behind the center", "Several yards behind the center", "On the sideline", "At the line of scrimmage next to the center"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- FMT1 Q2: What is I-formation?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0003-0000-0000-000000000002', '00000003-0000-0000-0000-000000000003', 'mcq', 'The "I-formation" is named for what reason?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0003-0001-0000-000000000002', '00000003-0003-0000-0000-000000000002', 1, 'The "I-formation" is named for what reason?', '["The quarterback''s jersey number", "The backs line up in a vertical line behind the QB, forming an ''I''", "It was invented in Iowa", "The offensive line forms an ''I'' shape"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- FMT1 Q3: Under center vs shotgun
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0003-0000-0000-000000000003', '00000003-0000-0000-0000-000000000003', 'binary', 'In shotgun formation, the quarterback receives the ball via a direct snap (thrown or tossed) rather than a hand-off from under center.', '{"correct_boolean": true}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0003-0001-0000-000000000003', '00000003-0003-0000-0000-000000000003', 1, 'In shotgun formation, the quarterback receives the ball via a direct snap (thrown or tossed) rather than a hand-off from under center.', '["True", "False"]', '{"boolean": true}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- FMT1 Q4: What is spread offense?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0003-0000-0000-000000000004', '00000003-0000-0000-0000-000000000003', 'mcq', 'What is the main goal of a "spread" offense?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0003-0001-0000-000000000004', '00000003-0003-0000-0000-000000000004', 1, 'What is the main goal of a "spread" offense?', '["Keep all players close together", "Spread receivers across the field to create space and mismatches", "Only run the ball", "Use two quarterbacks at once"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- FMT1 Q5: Single-back formation
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0003-0000-0000-000000000005', '00000003-0000-0000-0000-000000000003', 'mcq', 'How many running backs are in the backfield in a "single-back" formation?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0003-0001-0000-000000000005', '00000003-0003-0000-0000-000000000005', 1, 'How many running backs are in the backfield in a "single-back" formation?', '["None", "One", "Two", "Three"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- FMT1 Q6: Shotgun advantage
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0003-0000-0000-000000000006', '00000003-0000-0000-0000-000000000003', 'mcq', 'Why do teams often use shotgun formation on passing plays?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0003-0001-0000-000000000006', '00000003-0003-0000-0000-000000000006', 1, 'Why do teams often use shotgun formation on passing plays?', '["It confuses the defense", "The QB can see the field better and has more time to throw", "It is required by NFL rules", "The center can block better"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- FMT1 Q7: I-formation advantage
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0003-0000-0000-000000000007', '00000003-0000-0000-0000-000000000003', 'mcq', 'The I-formation is traditionally used for what type of plays?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0003-0001-0000-000000000007', '00000003-0003-0000-0000-000000000007', 1, 'The I-formation is traditionally used for what type of plays?', '["Quick passing plays", "Power running plays", "Trick plays", "Punt returns"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- FMT1 Q8: Spread vs traditional (Multi-select)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0003-0000-0000-000000000008', '00000003-0000-0000-0000-000000000003', 'multi_select', 'Which are characteristics of a spread offense? Select all that apply.', '{"correct_indices": [0]}', '00000000-0000-0000-0000-000000000000', 'live', 3)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0003-0001-0000-000000000008', '00000003-0003-0000-0000-000000000008', 1, 'Which are characteristics of a spread offense? Select all that apply.', '["Multiple wide receivers", "Quarterback often in shotgun", "Two tight ends blocking", "Using the full width of the field"]', '{"indices": [0, 1, 3]}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- FMT1 Q9: Formation scenario
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0003-0000-0000-000000000009', '00000003-0000-0000-0000-000000000003', 'mcq', 'It''s 3rd and 15. Which formation would the offense most likely use?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 3)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0003-0001-0000-000000000009', '00000003-0003-0000-0000-000000000009', 1, 'It''s 3rd and 15. Which formation would the offense most likely use?', '["I-formation with two running backs", "Shotgun spread with multiple receivers", "Punt formation", "Goal line formation"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- ============================================================================
-- LESSON 4: FMT2 (Formations II)
-- Concepts: 3-4 vs 4-3 defense, nickel, dime packages
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000003-0000-0000-0000-000000000004',
    '33333333-3333-3333-3333-333333333333',
    'Formations II',
    'Learn defensive formations: 3-4, 4-3, nickel, and dime packages.',
    4, 4, 50, true, 'FMT2', 5, 5
)
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, order_index = EXCLUDED.order_index;

-- FMT2 Q1: What do the numbers in 4-3 mean?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0004-0000-0000-000000000001', '00000003-0000-0000-0000-000000000004', 'mcq', 'In a "4-3 defense," what do the numbers represent?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0004-0001-0000-000000000001', '00000003-0004-0000-0000-000000000001', 1, 'In a "4-3 defense," what do the numbers represent?', '["4 quarterbacks and 3 receivers", "4 defensive linemen and 3 linebackers", "4 safeties and 3 cornerbacks", "4 downs and 3 timeouts"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- FMT2 Q2: What is a 3-4 defense?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0004-0000-0000-000000000002', '00000003-0000-0000-0000-000000000004', 'mcq', 'A "3-4 defense" has how many defensive linemen?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0004-0001-0000-000000000002', '00000003-0004-0000-0000-000000000002', 1, 'A "3-4 defense" has how many defensive linemen?', '["Two", "Three", "Four", "Five"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- FMT2 Q3: What is nickel defense?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0004-0000-0000-000000000003', '00000003-0000-0000-0000-000000000004', 'mcq', 'What is a "nickel" defense?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0004-0001-0000-000000000003', '00000003-0004-0000-0000-000000000003', 1, 'What is a "nickel" defense?', '["A defense that costs 5 cents to run", "A defense with 5 defensive backs instead of the usual 4", "A defense named after a player nicknamed Nickel", "A prevent defense used at the end of games"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- FMT2 Q4: What is dime defense?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0004-0000-0000-000000000004', '00000003-0000-0000-0000-000000000004', 'mcq', 'If nickel has 5 defensive backs, how many does "dime" have?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0004-0001-0000-000000000004', '00000003-0004-0000-0000-000000000004', 1, 'If nickel has 5 defensive backs, how many does "dime" have?', '["4", "5", "6", "7"]', '{"index": 2}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- FMT2 Q5: When to use nickel
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0004-0000-0000-000000000005', '00000003-0000-0000-0000-000000000004', 'mcq', 'When would a defense typically use nickel or dime packages?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0004-0001-0000-000000000005', '00000003-0004-0000-0000-000000000005', 1, 'When would a defense typically use nickel or dime packages?', '["When expecting a run play", "When expecting a pass play", "On first down only", "In the red zone only"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- FMT2 Q6: 3-4 vs 4-3 linebackers
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0004-0000-0000-000000000006', '00000003-0000-0000-0000-000000000004', 'binary', 'A 3-4 defense has more linebackers than a 4-3 defense.', '{"correct_boolean": true}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0004-0001-0000-000000000006', '00000003-0004-0000-0000-000000000006', 1, 'A 3-4 defense has more linebackers than a 4-3 defense.', '["True", "False"]', '{"boolean": true}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- FMT2 Q7: Total players front seven
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0004-0000-0000-000000000007', '00000003-0000-0000-0000-000000000004', 'mcq', 'In both 3-4 and 4-3 defenses, how many players are typically in the "front seven"?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0004-0001-0000-000000000007', '00000003-0004-0000-0000-000000000007', 1, 'In both 3-4 and 4-3 defenses, how many players are typically in the "front seven"?', '["Five", "Six", "Seven", "Eight"]', '{"index": 2}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- FMT2 Q8: Situational defense choice
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0004-0000-0000-000000000008', '00000003-0000-0000-0000-000000000004', 'mcq', 'The offense comes out with 4 wide receivers. Which defensive package would you expect?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 3)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0004-0001-0000-000000000008', '00000003-0004-0000-0000-000000000008', 1, 'The offense comes out with 4 wide receivers. Which defensive package would you expect?', '["Goal line defense", "Base 4-3", "Nickel or dime", "Punt return team"]', '{"index": 2}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- FMT2 Q9: Nickel naming
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0004-0000-0000-000000000009', '00000003-0000-0000-0000-000000000004', 'mcq', 'The extra defensive back in nickel defense is often called the...', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0004-0001-0000-000000000009', '00000003-0004-0000-0000-000000000009', 1, 'The extra defensive back in nickel defense is often called the...', '["Free safety", "Nickelback or slot corner", "Middle linebacker", "Nose tackle"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- ============================================================================
-- LESSON 5: CLK1 (Clock Management)
-- Concepts: Two-minute drill, timeouts, clock stopping rules, spike play
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000003-0000-0000-0000-000000000005',
    '33333333-3333-3333-3333-333333333333',
    'Clock Management',
    'Learn clock strategy: two-minute drill, timeouts, spike plays, and when the clock stops.',
    5, 4, 50, true, 'CLK1', 5, 5
)
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, order_index = EXCLUDED.order_index;

-- CLK1 Q1: What is the two-minute warning?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0005-0000-0000-000000000001', '00000003-0000-0000-0000-000000000005', 'mcq', 'What is the "two-minute warning" in the NFL?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0005-0001-0000-000000000001', '00000003-0005-0000-0000-000000000001', 1, 'What is the "two-minute warning" in the NFL?', '["A warning that the game is almost over", "An automatic timeout when 2 minutes remain in each half", "A penalty for slow play", "When the coach gets a final warning"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- CLK1 Q2: How many timeouts per half?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0005-0000-0000-000000000002', '00000003-0000-0000-0000-000000000005', 'mcq', 'How many timeouts does each team get per half in the NFL?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0005-0001-0000-000000000002', '00000003-0005-0000-0000-000000000002', 1, 'How many timeouts does each team get per half in the NFL?', '["2", "3", "4", "5"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- CLK1 Q3: What stops the clock? (Multi-select)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0005-0000-0000-000000000003', '00000003-0000-0000-0000-000000000005', 'multi_select', 'Which of these stop the game clock? Select all that apply.', '{"correct_indices": [0]}', '00000000-0000-0000-0000-000000000000', 'live', 3)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0005-0001-0000-000000000003', '00000003-0005-0000-0000-000000000003', 1, 'Which of these stop the game clock? Select all that apply.', '["Incomplete pass", "Running out of bounds", "A completed pass in the middle of the field", "Timeout"]', '{"indices": [0, 1, 3]}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- CLK1 Q4: What is a spike?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0005-0000-0000-000000000004', '00000003-0000-0000-0000-000000000005', 'mcq', 'Why would a quarterback "spike" the ball?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0005-0001-0000-000000000004', '00000003-0005-0000-0000-000000000004', 1, 'Why would a quarterback "spike" the ball?', '["To celebrate a touchdown", "To stop the clock quickly by throwing the ball into the ground", "To signal a timeout", "To confuse the defense"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- CLK1 Q5: Spike result
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0005-0000-0000-000000000005', '00000003-0000-0000-0000-000000000005', 'mcq', 'What happens when the quarterback spikes the ball?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0005-0001-0000-000000000005', '00000003-0005-0000-0000-000000000005', 1, 'What happens when the quarterback spikes the ball?', '["Touchdown", "Incomplete pass (clock stops, lose a down)", "Fumble", "Delay of game penalty"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- CLK1 Q6: Two-minute drill
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0005-0000-0000-000000000006', '00000003-0000-0000-0000-000000000005', 'mcq', 'What is a "two-minute drill"?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0005-0001-0000-000000000006', '00000003-0005-0000-0000-000000000006', 1, 'What is a "two-minute drill"?', '["A defensive formation", "A hurry-up offense used to score quickly at the end of a half", "A special teams play", "A practice drill that lasts 2 minutes"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- CLK1 Q7: Kneeling the ball
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0005-0000-0000-000000000007', '00000003-0000-0000-0000-000000000005', 'mcq', 'Why would an offense "take a knee" (kneel) at the end of a game?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0005-0001-0000-000000000007', '00000003-0005-0000-0000-000000000007', 1, 'Why would an offense "take a knee" (kneel) at the end of a game?', '["To rest before the next play", "To run out the clock while protecting the ball", "To show respect to the other team", "To get a first down"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- CLK1 Q8: Running clock scenario
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0005-0000-0000-000000000008', '00000003-0000-0000-0000-000000000005', 'mcq', 'You''re losing by 3 with 30 seconds left and no timeouts. After completing a pass in the middle of the field, what should you do?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 3)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0005-0001-0000-000000000008', '00000003-0005-0000-0000-000000000008', 1, 'You''re losing by 3 with 30 seconds left and no timeouts. After completing a pass in the middle of the field, what should you do?', '["Huddle up and call the next play", "Spike the ball to stop the clock", "Take a knee", "Run another play slowly"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- CLK1 Q9: Play clock
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0005-0000-0000-000000000009', '00000003-0000-0000-0000-000000000005', 'mcq', 'How many seconds does the offense have to snap the ball in the NFL (the play clock)?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0005-0001-0000-000000000009', '00000003-0005-0000-0000-000000000009', 1, 'How many seconds does the offense have to snap the ball in the NFL (the play clock)?', '["25 seconds", "30 seconds", "40 seconds", "60 seconds"]', '{"index": 2}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- ============================================================================
-- REMAINING LESSONS (LNG1, LNG2, LG1, LG2, STR1) - Abbreviated for length
-- Full content follows same pattern
-- ============================================================================

-- LESSON 6: LNG1 (Football Lingo I)
INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES ('00000003-0000-0000-0000-000000000006', '33333333-3333-3333-3333-333333333333', 'Football Lingo I', 'Learn essential football terms: audible, blitz, sack, red zone, and more.', 6, 4, 50, true, 'LNG1', 5, 5)
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, order_index = EXCLUDED.order_index;

-- LNG1 Questions (9 items)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0006-0000-0000-000000000001', '00000003-0000-0000-0000-000000000006', 'mcq', 'What is an "audible" in football?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0006-0001-0000-000000000001', '00000003-0006-0000-0000-000000000001', 1, 'What is an "audible" in football?', '["A loud celebration", "When the QB changes the play at the line of scrimmage", "A referee''s whistle", "The stadium announcer"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0006-0000-0000-000000000002', '00000003-0000-0000-0000-000000000006', 'mcq', 'What is a "blitz"?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0006-0001-0000-000000000002', '00000003-0006-0000-0000-000000000002', 1, 'What is a "blitz"?', '["A fast run play", "When extra defenders rush the quarterback", "A type of kick", "A timeout strategy"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0006-0000-0000-000000000003', '00000003-0000-0000-0000-000000000006', 'mcq', 'What is a "sack"?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0006-0001-0000-000000000003', '00000003-0006-0000-0000-000000000003', 1, 'What is a "sack"?', '["A touchdown celebration", "Tackling the QB behind the line of scrimmage before he throws", "Catching an interception", "A type of penalty"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0006-0000-0000-000000000004', '00000003-0000-0000-0000-000000000006', 'mcq', 'What is the "red zone"?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0006-0001-0000-000000000004', '00000003-0006-0000-0000-000000000004', 1, 'What is the "red zone"?', '["The area inside the opponent''s 20-yard line", "The end zone", "The middle of the field", "Where penalties are reviewed"]', '{"index": 0}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0006-0000-0000-000000000005', '00000003-0000-0000-0000-000000000006', 'binary', 'A "pick-six" is an interception returned for a touchdown.', '{"correct_boolean": true}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0006-0001-0000-000000000005', '00000003-0006-0000-0000-000000000005', 1, 'A "pick-six" is an interception returned for a touchdown.', '["True", "False"]', '{"boolean": true}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0006-0000-0000-000000000006', '00000003-0000-0000-0000-000000000006', 'mcq', 'What does "going for it on 4th down" mean?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0006-0001-0000-000000000006', '00000003-0006-0000-0000-000000000006', 1, 'What does "going for it on 4th down" mean?', '["Punting the ball", "Attempting to get a first down instead of punting", "Calling a timeout", "Kicking a field goal"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0006-0000-0000-000000000007', '00000003-0000-0000-0000-000000000006', 'mcq', 'What is a "Hail Mary" pass?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0006-0001-0000-000000000007', '00000003-0006-0000-0000-000000000007', 1, 'What is a "Hail Mary" pass?', '["A short screen pass", "A long, desperate pass thrown as time expires", "A pass to the tight end", "A trick play"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0006-0000-0000-000000000008', '00000003-0000-0000-0000-000000000006', 'mcq', 'What is a "scramble"?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0006-0001-0000-000000000008', '00000003-0006-0000-0000-000000000008', 1, 'What is a "scramble"?', '["When defenders switch positions", "When the QB runs with the ball to avoid pressure", "A type of huddle", "Changing the play at the line"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0006-0000-0000-000000000009', '00000003-0000-0000-0000-000000000006', 'mcq', 'What does "pocket" refer to in football?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0006-0001-0000-000000000009', '00000003-0006-0000-0000-000000000009', 1, 'What does "pocket" refer to in football?', '["Where players keep their mouthguards", "The protected area behind the offensive line where the QB stands", "The end zone", "The sideline area"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- ============================================================================
-- LESSON 7: LNG2 (Football Lingo II)
-- Concepts: Play-action, screen pass, zone coverage, man coverage, checkdown
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES ('00000003-0000-0000-0000-000000000007', '33333333-3333-3333-3333-333333333333', 'Football Lingo II', 'More football terms: play-action, screen pass, zone/man coverage.', 7, 4, 50, true, 'LNG2', 5, 5)
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, order_index = EXCLUDED.order_index;

-- LNG2 Q1: What is play-action?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0007-0000-0000-000000000001', '00000003-0000-0000-0000-000000000007', 'mcq', 'What is a "play-action" pass?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0007-0001-0000-000000000001', '00000003-0007-0000-0000-000000000001', 1, 'What is a "play-action" pass?', '["A quick slant pass", "A fake handoff followed by a pass to fool the defense", "A pass thrown while running", "A screen pass to the running back"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LNG2 Q2: What is a screen pass?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0007-0000-0000-000000000002', '00000003-0000-0000-0000-000000000007', 'mcq', 'What is a "screen pass"?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0007-0001-0000-000000000002', '00000003-0007-0000-0000-000000000002', 1, 'What is a "screen pass"?', '["A deep pass down the sideline", "A short pass behind blockers designed to let defenders rush past", "A pass thrown at the TV screen", "A backwards lateral pass"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LNG2 Q3: Zone vs man coverage
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0007-0000-0000-000000000003', '00000003-0000-0000-0000-000000000007', 'mcq', 'In "zone coverage," what does each defender guard?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0007-0001-0000-000000000003', '00000003-0007-0000-0000-000000000003', 1, 'In "zone coverage," what does each defender guard?', '["A specific receiver wherever they go", "An area of the field", "The quarterback only", "The sideline"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LNG2 Q4: Man coverage
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0007-0000-0000-000000000004', '00000003-0000-0000-0000-000000000007', 'mcq', 'In "man-to-man coverage," what does each defender do?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0007-0001-0000-000000000004', '00000003-0007-0000-0000-000000000004', 1, 'In "man-to-man coverage," what does each defender do?', '["Guard an area of the field", "Follow and cover a specific receiver", "Only rush the quarterback", "Stay on the line of scrimmage"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LNG2 Q5: What is a checkdown?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0007-0000-0000-000000000005', '00000003-0000-0000-0000-000000000007', 'mcq', 'What is a "checkdown" pass?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0007-0001-0000-000000000005', '00000003-0007-0000-0000-000000000005', 1, 'What is a "checkdown" pass?', '["A pass to the referee", "A short, safe pass to a nearby receiver when deeper options are covered", "A trick play pass", "A pass thrown behind the line"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LNG2 Q6: Play-action purpose
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0007-0000-0000-000000000006', '00000003-0000-0000-0000-000000000007', 'binary', 'Play-action works best when the defense is expecting a run play.', '{"correct_boolean": true}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0007-0001-0000-000000000006', '00000003-0007-0000-0000-000000000006', 1, 'Play-action works best when the defense is expecting a run play.', '["True", "False"]', '{"boolean": true}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LNG2 Q7: What is a slant route?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0007-0000-0000-000000000007', '00000003-0000-0000-0000-000000000007', 'mcq', 'What is a "slant" route?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0007-0001-0000-000000000007', '00000003-0007-0000-0000-000000000007', 1, 'What is a "slant" route?', '["Running straight down the field", "A quick route where the receiver cuts diagonally across the middle", "Running along the sideline", "A route that goes backwards"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LNG2 Q8: Screen pass scenario
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0007-0000-0000-000000000008', '00000003-0000-0000-0000-000000000007', 'mcq', 'The defense is blitzing heavily. Which play might be effective?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 3)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0007-0001-0000-000000000008', '00000003-0007-0000-0000-000000000008', 1, 'The defense is blitzing heavily. Which play might be effective?', '["A long deep pass", "A screen pass that uses the rush against them", "A quarterback sneak", "Taking a knee"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LNG2 Q9: Coverage types (Multi-select)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0007-0000-0000-000000000009', '00000003-0000-0000-0000-000000000007', 'multi_select', 'Which are types of defensive coverage? Select all that apply.', '{"correct_indices": [0]}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0007-0001-0000-000000000009', '00000003-0007-0000-0000-000000000009', 1, 'Which are types of defensive coverage? Select all that apply.', '["Zone coverage", "Man-to-man coverage", "Screen coverage", "Press coverage"]', '{"indices": [0, 1, 3]}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- ============================================================================
-- LESSON 8: LG1 (League Structure I)
-- Concepts: AFC/NFC, divisions, 32 teams, rivalries
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES ('00000003-0000-0000-0000-000000000008', '33333333-3333-3333-3333-333333333333', 'League Structure I', 'Learn about NFL teams, conferences (AFC/NFC), and divisions.', 8, 4, 50, true, 'LG1', 5, 5)
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, order_index = EXCLUDED.order_index;

-- LG1 Q1: How many teams in the NFL?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0008-0000-0000-000000000001', '00000003-0000-0000-0000-000000000008', 'mcq', 'How many teams are in the NFL?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0008-0001-0000-000000000001', '00000003-0008-0000-0000-000000000001', 1, 'How many teams are in the NFL?', '["28", "30", "32", "36"]', '{"index": 2}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LG1 Q2: What are the two conferences?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0008-0000-0000-000000000002', '00000003-0000-0000-0000-000000000008', 'mcq', 'What are the two conferences in the NFL?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0008-0001-0000-000000000002', '00000003-0008-0000-0000-000000000002', 1, 'What are the two conferences in the NFL?', '["Eastern and Western", "AFC and NFC", "American and National", "North and South"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LG1 Q3: AFC stands for
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0008-0000-0000-000000000003', '00000003-0000-0000-0000-000000000008', 'mcq', 'What does AFC stand for?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0008-0001-0000-000000000003', '00000003-0008-0000-0000-000000000003', 1, 'What does AFC stand for?', '["All Football Conference", "American Football Conference", "Atlantic Football Conference", "Association of Football Clubs"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LG1 Q4: How many divisions per conference?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0008-0000-0000-000000000004', '00000003-0000-0000-0000-000000000008', 'mcq', 'How many divisions are in each conference?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0008-0001-0000-000000000004', '00000003-0008-0000-0000-000000000004', 1, 'How many divisions are in each conference?', '["2", "3", "4", "5"]', '{"index": 2}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LG1 Q5: Division names
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0008-0000-0000-000000000005', '00000003-0000-0000-0000-000000000008', 'multi_select', 'Which are real NFL division names? Select all that apply.', '{"correct_indices": [0]}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0008-0001-0000-000000000005', '00000003-0008-0000-0000-000000000005', 1, 'Which are real NFL division names? Select all that apply.', '["North", "South", "Central", "West"]', '{"indices": [0, 1, 3]}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LG1 Q6: Teams per division
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0008-0000-0000-000000000006', '00000003-0000-0000-0000-000000000008', 'mcq', 'How many teams are in each division?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0008-0001-0000-000000000006', '00000003-0008-0000-0000-000000000006', 1, 'How many teams are in each division?', '["3", "4", "5", "6"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LG1 Q7: Division rivalries
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0008-0000-0000-000000000007', '00000003-0000-0000-0000-000000000008', 'binary', 'Teams in the same division play each other twice per season.', '{"correct_boolean": true}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0008-0001-0000-000000000007', '00000003-0008-0000-0000-000000000007', 1, 'Teams in the same division play each other twice per season.', '["True", "False"]', '{"boolean": true}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LG1 Q8: Conference match-up
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0008-0000-0000-000000000008', '00000003-0000-0000-0000-000000000008', 'mcq', 'The Dallas Cowboys are in which conference?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0008-0001-0000-000000000008', '00000003-0008-0000-0000-000000000008', 1, 'The Dallas Cowboys are in which conference?', '["AFC", "NFC", "Both", "Neither"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LG1 Q9: Division winner importance
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0008-0000-0000-000000000009', '00000003-0000-0000-0000-000000000008', 'mcq', 'What does the division winner automatically earn?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0008-0001-0000-000000000009', '00000003-0008-0000-0000-000000000009', 1, 'What does the division winner automatically earn?', '["A bye week", "A playoff spot", "Home-field advantage all playoffs", "A first-round draft pick"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- ============================================================================
-- LESSON 9: LG2 (League Structure II)
-- Concepts: Regular season, playoffs, Super Bowl, bye weeks, wild card
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES ('00000003-0000-0000-0000-000000000009', '33333333-3333-3333-3333-333333333333', 'League Structure II', 'Understand the regular season, playoffs, Super Bowl, and bye weeks.', 9, 4, 50, true, 'LG2', 5, 5)
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, order_index = EXCLUDED.order_index;

-- LG2 Q1: Regular season games
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0009-0000-0000-000000000001', '00000003-0000-0000-0000-000000000009', 'mcq', 'How many regular season games does each NFL team play?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0009-0001-0000-000000000001', '00000003-0009-0000-0000-000000000001', 1, 'How many regular season games does each NFL team play?', '["14", "16", "17", "18"]', '{"index": 2}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LG2 Q2: What is a bye week?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0009-0000-0000-000000000002', '00000003-0000-0000-0000-000000000009', 'mcq', 'What is a "bye week"?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0009-0001-0000-000000000002', '00000003-0009-0000-0000-000000000002', 1, 'What is a "bye week"?', '["The week before the Super Bowl", "A scheduled week off during the season", "When a player retires", "The final week of the season"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LG2 Q3: Playoff teams per conference
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0009-0000-0000-000000000003', '00000003-0000-0000-0000-000000000009', 'mcq', 'How many teams from each conference make the playoffs?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0009-0001-0000-000000000003', '00000003-0009-0000-0000-000000000003', 1, 'How many teams from each conference make the playoffs?', '["4", "6", "7", "8"]', '{"index": 2}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LG2 Q4: What is a wild card team?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0009-0000-0000-000000000004', '00000003-0000-0000-0000-000000000009', 'mcq', 'What is a "wild card" team in the playoffs?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0009-0001-0000-000000000004', '00000003-0009-0000-0000-000000000004', 1, 'What is a "wild card" team in the playoffs?', '["A team that wins a coin flip to get in", "A playoff team that didn''t win their division", "The team with the best record", "A team added at the last minute"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LG2 Q5: Super Bowl participants
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0009-0000-0000-000000000005', '00000003-0000-0000-0000-000000000009', 'binary', 'The Super Bowl is played between the AFC champion and the NFC champion.', '{"correct_boolean": true}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0009-0001-0000-000000000005', '00000003-0009-0000-0000-000000000005', 1, 'The Super Bowl is played between the AFC champion and the NFC champion.', '["True", "False"]', '{"boolean": true}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LG2 Q6: Playoff seeding advantage
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0009-0000-0000-000000000006', '00000003-0000-0000-0000-000000000009', 'mcq', 'What advantage does the #1 seed in each conference get in the playoffs?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0009-0001-0000-000000000006', '00000003-0009-0000-0000-000000000006', 1, 'What advantage does the #1 seed in each conference get in the playoffs?', '["They skip the first round (bye week)", "They get extra draft picks", "They choose their opponent", "They play with extra players"]', '{"index": 0}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LG2 Q7: Conference Championship
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0009-0000-0000-000000000007', '00000003-0000-0000-0000-000000000009', 'mcq', 'What game comes right before the Super Bowl?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0009-0001-0000-000000000007', '00000003-0009-0000-0000-000000000007', 1, 'What game comes right before the Super Bowl?', '["Wild Card Round", "Divisional Round", "Conference Championship", "Pro Bowl"]', '{"index": 2}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LG2 Q8: Playoff rounds in order (Multi-select - wrong type, change to MCQ)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0009-0000-0000-000000000008', '00000003-0000-0000-0000-000000000009', 'mcq', 'What is the correct order of NFL playoff rounds?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 3)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0009-0001-0000-000000000008', '00000003-0009-0000-0000-000000000008', 1, 'What is the correct order of NFL playoff rounds?', '["Divisional, Wild Card, Championship, Super Bowl", "Wild Card, Divisional, Championship, Super Bowl", "Championship, Divisional, Wild Card, Super Bowl", "Wild Card, Championship, Divisional, Super Bowl"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- LG2 Q9: Single elimination
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0009-0000-0000-000000000009', '00000003-0000-0000-0000-000000000009', 'binary', 'NFL playoff games are single elimination - one loss and you are out.', '{"correct_boolean": true}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0009-0001-0000-000000000009', '00000003-0009-0000-0000-000000000009', 1, 'NFL playoff games are single elimination - one loss and you are out.', '["True", "False"]', '{"boolean": true}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- ============================================================================
-- LESSON 10: STR1 (Strategy Basics)
-- Concepts: Run vs pass decisions, 3rd down importance, 4th down decisions
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES ('00000003-0000-0000-0000-000000000010', '33333333-3333-3333-3333-333333333333', 'Strategy Basics', 'Learn when to run vs pass, 3rd down decisions, and 4th down gambles.', 10, 4, 50, true, 'STR1', 5, 5)
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, order_index = EXCLUDED.order_index;

-- STR1 Q1: Why run the ball?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0010-0000-0000-000000000001', '00000003-0000-0000-0000-000000000010', 'multi_select', 'Why might a team choose to run the ball? Select all that apply.', '{"correct_indices": [0]}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0010-0001-0000-000000000001', '00000003-0010-0000-0000-000000000001', 1, 'Why might a team choose to run the ball? Select all that apply.', '["To keep the clock running", "To reduce interception risk", "To score quickly when behind", "To wear down the defense"]', '{"indices": [0, 1, 3]}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- STR1 Q2: Why pass the ball?
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0010-0000-0000-000000000002', '00000003-0000-0000-0000-000000000010', 'multi_select', 'Why might a team choose to pass the ball? Select all that apply.', '{"correct_indices": [0]}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0010-0001-0000-000000000002', '00000003-0010-0000-0000-000000000002', 1, 'Why might a team choose to pass the ball? Select all that apply.', '["To gain more yards quickly", "To stop the clock on incomplete passes", "To make it safer", "To move down the field faster"]', '{"indices": [0, 1, 3]}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- STR1 Q3: 3rd down importance
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0010-0000-0000-000000000003', '00000003-0000-0000-0000-000000000010', 'mcq', 'Why is 3rd down called the "money down"?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0010-0001-0000-000000000003', '00000003-0010-0000-0000-000000000003', 1, 'Why is 3rd down called the "money down"?', '["Players get paid extra", "It''s often the last realistic chance to get a first down", "The team earns money for conversions", "It happens most often in games"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- STR1 Q4: 4th down decision
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0010-0000-0000-000000000004', '00000003-0000-0000-0000-000000000010', 'mcq', 'When should a team consider going for it on 4th down?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0010-0001-0000-000000000004', '00000003-0010-0000-0000-000000000004', 1, 'When should a team consider going for it on 4th down?', '["Always", "Only in their own end zone", "When they only need a short distance, especially late in the game", "Never - always punt"]', '{"index": 2}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- STR1 Q5: Field position importance
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0010-0000-0000-000000000005', '00000003-0000-0000-0000-000000000010', 'binary', 'Field position is important because starting closer to the opponent''s end zone makes it easier to score.', '{"correct_boolean": true}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0010-0001-0000-000000000005', '00000003-0010-0000-0000-000000000005', 1, 'Field position is important because starting closer to the opponent''s end zone makes it easier to score.', '["True", "False"]', '{"boolean": true}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- STR1 Q6: 3rd and short vs 3rd and long
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0010-0000-0000-000000000006', '00000003-0000-0000-0000-000000000010', 'mcq', 'On 3rd and 2 (3rd down, 2 yards to go), what might the offense do?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0010-0001-0000-000000000006', '00000003-0010-0000-0000-000000000006', 1, 'On 3rd and 2 (3rd down, 2 yards to go), what might the offense do?', '["Only pass - running never works on 3rd down", "Run or short pass - only need 2 yards", "Punt the ball", "Kick a field goal"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- STR1 Q7: Situational strategy
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0010-0000-0000-000000000007', '00000003-0000-0000-0000-000000000010', 'mcq', 'Your team is winning by 3 points with 2 minutes left and has the ball. What should you focus on?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 3)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0010-0001-0000-000000000007', '00000003-0010-0000-0000-000000000007', 1, 'Your team is winning by 3 points with 2 minutes left and has the ball. What should you focus on?', '["Throwing deep passes to score more", "Running the ball to keep the clock moving and protect the lead", "Going for onside kicks", "Punting immediately"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- STR1 Q8: Being behind strategy
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0010-0000-0000-000000000008', '00000003-0000-0000-0000-000000000010', 'mcq', 'Your team is losing by 10 points with 3 minutes left. What should you prioritize?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 3)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0010-0001-0000-000000000008', '00000003-0010-0000-0000-000000000008', 1, 'Your team is losing by 10 points with 3 minutes left. What should you prioritize?', '["Running the ball to control clock", "Passing to score quickly and stop the clock", "Kicking field goals", "Taking a knee"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- STR1 Q9: Red zone strategy
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000003-0010-0000-0000-000000000009', '00000003-0000-0000-0000-000000000010', 'mcq', 'Why is "red zone efficiency" an important team statistic?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000003-0010-0001-0000-000000000009', '00000003-0010-0000-0000-000000000009', 1, 'Why is "red zone efficiency" an important team statistic?', '["It measures how fast a team can run", "It shows how often a team scores when close to the goal line", "It counts total passing yards", "It measures punt distance"]', '{"index": 1}', '', true)
ON CONFLICT (item_id, version) DO UPDATE SET options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;

-- ============================================================================
-- VETERAN QUIZ (QZVET)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000003-0000-0000-0000-000000000011',
    '33333333-3333-3333-3333-333333333333',
    'Veteran Quiz',
    'Test your intermediate football knowledge! Covers penalties, formations, clock management, and lingo.',
    11, 5, 75, true, 'QZVET', 10, 1
)
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, order_index = EXCLUDED.order_index;

-- ============================================================================
-- TEST-OUT CONFIGURATION
-- ============================================================================

-- Create test-out configuration for Rookie module
INSERT INTO module_test_outs (id, module_id, passing_score, total_questions, is_active)
VALUES (
    '10000001-0000-0000-0000-000000000001',
    '11111111-1111-1111-1111-111111111111',
    20,
    25,
    true
)
ON CONFLICT (module_id) DO UPDATE SET
    passing_score = EXCLUDED.passing_score,
    total_questions = EXCLUDED.total_questions,
    is_active = EXCLUDED.is_active;

-- Create test-out configuration for Veteran module
INSERT INTO module_test_outs (id, module_id, passing_score, total_questions, is_active)
VALUES (
    '10000001-0000-0000-0000-000000000002',
    '33333333-3333-3333-3333-333333333333',
    20,
    25,
    true
)
ON CONFLICT (module_id) DO UPDATE SET
    passing_score = EXCLUDED.passing_score,
    total_questions = EXCLUDED.total_questions,
    is_active = EXCLUDED.is_active;

-- ============================================================================
-- NOTE: ROOKIE TEST-OUT ITEMS
-- ============================================================================
-- The Rookie test-out items need to be added separately once you identify
-- the correct item IDs from your existing Rookie lesson data.
-- You can query existing items with:
--   SELECT id, base_prompt FROM items WHERE lesson_id IN
--     (SELECT id FROM lessons WHERE module_id = '11111111-1111-1111-1111-111111111111')
--   LIMIT 25;
-- Then insert them like:
--   INSERT INTO test_out_items (module_id, item_id, order_index) VALUES
--   ('11111111-1111-1111-1111-111111111111', '<item_id>', 1),
--   ...
-- ============================================================================

-- Link 25 questions from Veteran lessons to the Veteran test-out
-- Drawing from all 10 lessons for comprehensive coverage
INSERT INTO test_out_items (module_id, item_id, order_index) VALUES
-- From PEN1 (3 questions)
('33333333-3333-3333-3333-333333333333', '00000003-0001-0000-0000-000000000001', 1),
('33333333-3333-3333-3333-333333333333', '00000003-0001-0000-0000-000000000003', 2),
('33333333-3333-3333-3333-333333333333', '00000003-0001-0000-0000-000000000005', 3),
-- From PEN2 (2 questions)
('33333333-3333-3333-3333-333333333333', '00000003-0002-0000-0000-000000000001', 4),
('33333333-3333-3333-3333-333333333333', '00000003-0002-0000-0000-000000000002', 5),
-- From FMT1 (3 questions)
('33333333-3333-3333-3333-333333333333', '00000003-0003-0000-0000-000000000001', 6),
('33333333-3333-3333-3333-333333333333', '00000003-0003-0000-0000-000000000004', 7),
('33333333-3333-3333-3333-333333333333', '00000003-0003-0000-0000-000000000009', 8),
-- From FMT2 (2 questions)
('33333333-3333-3333-3333-333333333333', '00000003-0004-0000-0000-000000000001', 9),
('33333333-3333-3333-3333-333333333333', '00000003-0004-0000-0000-000000000003', 10),
-- From CLK1 (3 questions)
('33333333-3333-3333-3333-333333333333', '00000003-0005-0000-0000-000000000001', 11),
('33333333-3333-3333-3333-333333333333', '00000003-0005-0000-0000-000000000004', 12),
('33333333-3333-3333-3333-333333333333', '00000003-0005-0000-0000-000000000006', 13),
-- From LNG1 (2 questions)
('33333333-3333-3333-3333-333333333333', '00000003-0006-0000-0000-000000000002', 14),
('33333333-3333-3333-3333-333333333333', '00000003-0006-0000-0000-000000000003', 15),
-- From LNG2 (2 questions)
('33333333-3333-3333-3333-333333333333', '00000003-0007-0000-0000-000000000001', 16),
('33333333-3333-3333-3333-333333333333', '00000003-0007-0000-0000-000000000003', 17),
-- From LG1 (3 questions)
('33333333-3333-3333-3333-333333333333', '00000003-0008-0000-0000-000000000001', 18),
('33333333-3333-3333-3333-333333333333', '00000003-0008-0000-0000-000000000002', 19),
('33333333-3333-3333-3333-333333333333', '00000003-0008-0000-0000-000000000004', 20),
-- From LG2 (3 questions)
('33333333-3333-3333-3333-333333333333', '00000003-0009-0000-0000-000000000002', 21),
('33333333-3333-3333-3333-333333333333', '00000003-0009-0000-0000-000000000003', 22),
('33333333-3333-3333-3333-333333333333', '00000003-0009-0000-0000-000000000005', 23),
-- From STR1 (2 questions)
('33333333-3333-3333-3333-333333333333', '00000003-0010-0000-0000-000000000003', 24),
('33333333-3333-3333-3333-333333333333', '00000003-0010-0000-0000-000000000007', 25)
ON CONFLICT (module_id, item_id) DO NOTHING;

-- ============================================================================
-- VERIFICATION
-- ============================================================================

-- Verify Veteran Module
SELECT 'Veteran Module' as entity, title, order_index FROM modules WHERE id = '33333333-3333-3333-3333-333333333333';

-- Verify Veteran Lessons (should be 11: 10 lessons + 1 quiz)
SELECT 'Veteran Lessons' as entity, COUNT(*) as count FROM lessons WHERE module_id = '33333333-3333-3333-3333-333333333333';

-- Verify Veteran Items (should be 90: 9 questions x 10 lessons)
SELECT 'Veteran Items' as entity, COUNT(*) as count FROM items WHERE lesson_id IN (
    SELECT id FROM lessons WHERE module_id = '33333333-3333-3333-3333-333333333333'
);

-- Verify Test-Out Configs (should be 2: Rookie + Veteran)
SELECT 'Test-Out Configs' as entity, COUNT(*) as count FROM module_test_outs;

-- Verify Rookie Test-Out Items (should be 25)
SELECT 'Rookie Test-Out Items' as entity, COUNT(*) as count FROM test_out_items WHERE module_id = '11111111-1111-1111-1111-111111111111';

-- Verify Veteran Test-Out Items (should be 25)
SELECT 'Veteran Test-Out Items' as entity, COUNT(*) as count FROM test_out_items WHERE module_id = '33333333-3333-3333-3333-333333333333';

-- Summary of lessons with item counts
SELECT l.code, l.title, COUNT(i.id) as item_count
FROM lessons l
LEFT JOIN items i ON i.lesson_id = l.id
WHERE l.module_id = '33333333-3333-3333-3333-333333333333'
GROUP BY l.id, l.code, l.title, l.order_index
ORDER BY l.order_index;
