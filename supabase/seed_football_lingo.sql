-- Football Lingo & Terminology Module Seed Data
-- Manually generated

-- Insert Module 4: Football Lingo & Terminology
INSERT INTO modules (id, sport_id, title, description, order_index, min_level, max_level, xp_reward, created_at, updated_at)
VALUES (
  '00000000-0000-0000-0000-000000000004',
  '0105433b-5bdd-4093-b6b1-157a0c3c515e', -- Football Sport ID
  'Football Lingo & Terminology',
  'Master the language of the game, from "going for two" to "back shoulder" throws.',
  4,
  1,
  4,
  0,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  order_index = EXCLUDED.order_index,
  min_level = EXCLUDED.min_level,
  max_level = EXCLUDED.max_level,
  xp_reward = EXCLUDED.xp_reward,
  updated_at = NOW();

-- ============================================================================
-- Lesson 1: Common Phrases
-- ============================================================================
INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, created_at, updated_at)
VALUES (
  '00000004-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000004',
  'Common Phrases',
  'Learn the most common phrases used by commentators and fans.',
  1,
  5,
  100,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  order_index = EXCLUDED.order_index,
  est_minutes = EXCLUDED.est_minutes,
  xp_award = EXCLUDED.xp_award,
  updated_at = NOW();

-- Item 1: Go for two
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
  '00000004-0001-0000-0000-000000000001',
  '00000004-0000-0000-0000-000000000001',
  'mcq',
  'Meaning of "go for two"',
  '{"type": "mcq", "options": ["Attempt a 2-point conversion after a touchdown", "Kick a field goal on second down", "Try to get 2 yards for a first down", "Play with 2 quarterbacks"], "correct": 0}'::jsonb,
  1,
  'live',
  (SELECT id FROM users LIMIT 1),
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  base_prompt = EXCLUDED.base_prompt,
  answer_schema_json = EXCLUDED.answer_schema_json,
  difficulty = EXCLUDED.difficulty,
  status = EXCLUDED.status,
  updated_at = NOW();

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
  '00000004-0001-0001-0000-000000000001',
  '00000004-0001-0000-0000-000000000001',
  1,
  'After a touchdown, the coach decides to "go for two". What does this mean?',
  '["Attempt a 2-point conversion", "Kick the extra point", "Kick off from the 20-yard line", "Challenge the ruling on the field"]',
  '{"index": 0}',
  'To "go for two" means the team will attempt one offensive play from the 2-yard line (in NFL) to score 2 points instead of kicking the standard 1-point extra point.',
  true,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  prompt_richtext = EXCLUDED.prompt_richtext,
  options_json = EXCLUDED.options_json,
  correct_answer_json = EXCLUDED.correct_answer_json,
  explanation_richtext = EXCLUDED.explanation_richtext,
  active = EXCLUDED.active,
  updated_at = NOW();

-- Item 2: Kick it deep
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
  '00000004-0001-0000-0000-000000000002',
  '00000004-0000-0000-0000-000000000001',
  'mcq',
  'Meaning of "kick it deep"',
  '{"type": "mcq", "options": ["Kick the ball as far as possible on a kickoff or punt", "Kick a long field goal", "Pass the ball deep downfield", "Punt the ball out of bounds"], "correct": 0}'::jsonb,
  1,
  'live',
  (SELECT id FROM users LIMIT 1),
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  base_prompt = EXCLUDED.base_prompt,
  answer_schema_json = EXCLUDED.answer_schema_json,
  difficulty = EXCLUDED.difficulty,
  status = EXCLUDED.status,
  updated_at = NOW();

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
  '00000004-0001-0002-0000-000000000001',
  '00000004-0001-0000-0000-000000000002',
  1,
  'The special teams coach yells "Kick it deep!" What does he want the kicker to do?',
  '["Kick the ball as far downfield as possible", "Try an onside kick", "Squib kick the ball along the ground", "Kick it out of bounds"]',
  '{"index": 0}',
  '"Kicking it deep" means kicking the ball as far as possible towards the opponent''s end zone, usually to prevent a good return or force a touchback.',
  true,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  prompt_richtext = EXCLUDED.prompt_richtext,
  options_json = EXCLUDED.options_json,
  correct_answer_json = EXCLUDED.correct_answer_json,
  explanation_richtext = EXCLUDED.explanation_richtext,
  active = EXCLUDED.active,
  updated_at = NOW();

-- Item 3: Audible
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
  '00000004-0001-0000-0000-000000000003',
  '00000004-0000-0000-0000-000000000001',
  'mcq',
  'Meaning of "audible"',
  '{"type": "mcq", "options": ["Changing the play at the line of scrimmage", "A loud cheer from the crowd", "The sound of the whistle", "Reviewing a play"], "correct": 0}'::jsonb,
  2,
  'live',
  (SELECT id FROM users LIMIT 1),
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  base_prompt = EXCLUDED.base_prompt,
  answer_schema_json = EXCLUDED.answer_schema_json,
  difficulty = EXCLUDED.difficulty,
  status = EXCLUDED.status,
  updated_at = NOW();

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
  '00000004-0001-0003-0000-000000000001',
  '00000004-0001-0000-0000-000000000003',
  1,
  'The quarterback sees the defense blitzing and calls an "audible". What is he doing?',
  '["Changing the play at the line of scrimmage", "Calling a timeout", "Asking the crowd to be quiet", "Faking the snap count"]',
  '{"index": 0}',
  'An audible is when the quarterback changes the play verbally at the line of scrimmage after seeing the defensive alignment.',
  true,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  prompt_richtext = EXCLUDED.prompt_richtext,
  options_json = EXCLUDED.options_json,
  correct_answer_json = EXCLUDED.correct_answer_json,
  explanation_richtext = EXCLUDED.explanation_richtext,
  active = EXCLUDED.active,
  updated_at = NOW();

-- Item 4: Pick 6
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
  '00000004-0001-0000-0000-000000000004',
  '00000004-0000-0000-0000-000000000001',
  'mcq',
  'Meaning of "Pick 6"',
  '{"type": "mcq", "options": ["Interception returned for a touchdown", "Drafting 6th overall", "Selecting 6 plays", "Intercepting 6 passes"], "correct": 0}'::jsonb,
  1,
  'live',
  (SELECT id FROM users LIMIT 1),
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  base_prompt = EXCLUDED.base_prompt,
  answer_schema_json = EXCLUDED.answer_schema_json,
  difficulty = EXCLUDED.difficulty,
  status = EXCLUDED.status,
  updated_at = NOW();

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
  '00000004-0001-0004-0000-000000000001',
  '00000004-0001-0000-0000-000000000004',
  1,
  'The commentator screams "Pick 6!" What just happened?',
  '["A defender intercepted a pass and ran it back for a touchdown", "The quarterback threw his 6th interception", "The defense got a turnover on the 6-yard line", "A player picked up 6 yards"]',
  '{"index": 0}',
  'A "Pick 6" is slang for an interception ("pick") that is returned for a touchdown (worth 6 points).',
  true,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  prompt_richtext = EXCLUDED.prompt_richtext,
  options_json = EXCLUDED.options_json,
  correct_answer_json = EXCLUDED.correct_answer_json,
  explanation_richtext = EXCLUDED.explanation_richtext,
  active = EXCLUDED.active,
  updated_at = NOW();

-- Item 5: Three and out
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
  '00000004-0001-0000-0000-000000000005',
  '00000004-0000-0000-0000-000000000001',
  'mcq',
  'Meaning of "Three and out"',
  '{"type": "mcq", "options": ["Offense fails to get a first down on first 3 plays", "Three players are injured", "Three timeouts taken", "Scoring 3 points"], "correct": 0}'::jsonb,
  2,
  'live',
  (SELECT id FROM users LIMIT 1),
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  base_prompt = EXCLUDED.base_prompt,
  answer_schema_json = EXCLUDED.answer_schema_json,
  difficulty = EXCLUDED.difficulty,
  status = EXCLUDED.status,
  updated_at = NOW();

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
  '00000004-0001-0005-0000-000000000001',
  '00000004-0001-0000-0000-000000000005',
  1,
  'The defense forces a "three and out". What does this mean for the offense?',
  '["They failed to gain 10 yards in 3 plays and must punt", "They scored a field goal", "They used all three timeouts", "They turned the ball over on the 3rd play"]',
  '{"index": 0}',
  'A "three and out" occurs when an offense runs three plays but fails to gain a first down (10 yards), forcing them to punt on 4th down.',
  true,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  prompt_richtext = EXCLUDED.prompt_richtext,
  options_json = EXCLUDED.options_json,
  correct_answer_json = EXCLUDED.correct_answer_json,
  explanation_richtext = EXCLUDED.explanation_richtext,
  active = EXCLUDED.active,
  updated_at = NOW();

-- Item 6: Move the chains
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
  '00000004-0001-0000-0000-000000000006',
  '00000004-0000-0000-0000-000000000001',
  'mcq',
  'Meaning of "Move the chains"',
  '{"type": "mcq", "options": ["Getting a first down", "Moving the goal posts", "Changing sides of the field", "Penalty on the defense"], "correct": 0}'::jsonb,
  1,
  'live',
  (SELECT id FROM users LIMIT 1),
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  base_prompt = EXCLUDED.base_prompt,
  answer_schema_json = EXCLUDED.answer_schema_json,
  difficulty = EXCLUDED.difficulty,
  status = EXCLUDED.status,
  updated_at = NOW();

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
  '00000004-0001-0006-0000-000000000001',
  '00000004-0001-0000-0000-000000000006',
  1,
  'The receiver catches the ball past the marker to "move the chains". What does this signify?',
  '["The offense gained a first down", "The quarter has ended", "The chain crew is taking a break", "A penalty was called"]',
  '{"index": 0}',
  '"Moving the chains" refers to the chain crew moving the 10-yard markers forward because the offense successfully gained a first down.',
  true,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  prompt_richtext = EXCLUDED.prompt_richtext,
  options_json = EXCLUDED.options_json,
  correct_answer_json = EXCLUDED.correct_answer_json,
  explanation_richtext = EXCLUDED.explanation_richtext,
  active = EXCLUDED.active,
  updated_at = NOW();

-- ============================================================================
-- Lesson 2: Field Lingo
-- ============================================================================
INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, created_at, updated_at)
VALUES (
  '00000004-0000-0000-0000-000000000002',
  '00000000-0000-0000-0000-000000000004',
  'Field Lingo',
  'Understand the terms players and coaches use on the field.',
  2,
  5,
  100,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  order_index = EXCLUDED.order_index,
  est_minutes = EXCLUDED.est_minutes,
  xp_award = EXCLUDED.xp_award,
  updated_at = NOW();

-- Item 1: Juggle
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
  '00000004-0002-0000-0000-000000000001',
  '00000004-0000-0000-0000-000000000002',
  'mcq',
  'Meaning of "juggle"',
  '{"type": "mcq", "options": ["Bobbling the ball before catching it", "Doing tricks with the ball", "Holding the ball with one hand", "Dropping the ball"], "correct": 0}'::jsonb,
  2,
  'live',
  (SELECT id FROM users LIMIT 1),
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  base_prompt = EXCLUDED.base_prompt,
  answer_schema_json = EXCLUDED.answer_schema_json,
  difficulty = EXCLUDED.difficulty,
  status = EXCLUDED.status,
  updated_at = NOW();

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
  '00000004-0002-0001-0000-000000000001',
  '00000004-0002-0000-0000-000000000001',
  1,
  'The receiver "juggled" the ball before securing it. What happened?',
  '["He bobbled the ball in the air before gaining control", "He caught it with one hand", "He dropped the pass", "He tipped it to a teammate"]',
  '{"index": 0}',
  'Juggling means the receiver did not catch the ball cleanly at first touch, but bobbled it in the air before finally securing possession.',
  true,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  prompt_richtext = EXCLUDED.prompt_richtext,
  options_json = EXCLUDED.options_json,
  correct_answer_json = EXCLUDED.correct_answer_json,
  explanation_richtext = EXCLUDED.explanation_richtext,
  active = EXCLUDED.active,
  updated_at = NOW();

-- Item 2: Arm tackle
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
  '00000004-0002-0000-0000-000000000002',
  '00000004-0000-0000-0000-000000000002',
  'mcq',
  'Meaning of "arm tackle"',
  '{"type": "mcq", "options": ["Trying to tackle using only arms, not the body", "Tackling the quarterback''s arm", "A stiff arm move", "Holding penalty"], "correct": 0}'::jsonb,
  2,
  'live',
  (SELECT id FROM users LIMIT 1),
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  base_prompt = EXCLUDED.base_prompt,
  answer_schema_json = EXCLUDED.answer_schema_json,
  difficulty = EXCLUDED.difficulty,
  status = EXCLUDED.status,
  updated_at = NOW();

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
  '00000004-0002-0002-0000-000000000001',
  '00000004-0002-0000-0000-000000000002',
  1,
  'Why do coaches dislike "arm tackles"?',
  '["They are weak tackles using only arms, which runners can break through", "They are illegal and cause penalties", "They risk injury to the tackler''s arm", "They are too aggressive"]',
  '{"index": 0}',
  'An arm tackle is when a defender tries to stop a runner by grabbing them with their arms instead of driving their shoulder and body into them. Strong runners can easily break these tackles.',
  true,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  prompt_richtext = EXCLUDED.prompt_richtext,
  options_json = EXCLUDED.options_json,
  correct_answer_json = EXCLUDED.correct_answer_json,
  explanation_richtext = EXCLUDED.explanation_richtext,
  active = EXCLUDED.active,
  updated_at = NOW();

-- Item 3: Laid out
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
  '00000004-0002-0000-0000-000000000003',
  '00000004-0000-0000-0000-000000000002',
  'mcq',
  'Meaning of "laid out"',
  '{"type": "mcq", "options": ["Fully extending the body to make a catch or tackle", "Getting knocked unconscious", "Lying on the ground injured", "Setting up the field"], "correct": 0}'::jsonb,
  2,
  'live',
  (SELECT id FROM users LIMIT 1),
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  base_prompt = EXCLUDED.base_prompt,
  answer_schema_json = EXCLUDED.answer_schema_json,
  difficulty = EXCLUDED.difficulty,
  status = EXCLUDED.status,
  updated_at = NOW();

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
  '00000004-0002-0003-0000-000000000001',
  '00000004-0002-0000-0000-000000000003',
  1,
  'The receiver "laid out" for the pass. What did he do?',
  '["Dove horizontally in the air, fully extending his body to reach the ball", "Sat down in the zone", "Blocked a defender", "Ran out of bounds"]',
  '{"index": 0}',
  'To "lay out" means to dive through the air, fully extending your body parallel to the ground, usually to make a difficult catch.',
  true,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  prompt_richtext = EXCLUDED.prompt_richtext,
  options_json = EXCLUDED.options_json,
  correct_answer_json = EXCLUDED.correct_answer_json,
  explanation_richtext = EXCLUDED.explanation_richtext,
  active = EXCLUDED.active,
  updated_at = NOW();

-- Item 4: Back shoulder
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
  '00000004-0002-0000-0000-000000000004',
  '00000004-0000-0000-0000-000000000002',
  'mcq',
  'Meaning of "back shoulder"',
  '{"type": "mcq", "options": ["Throwing behind the receiver away from the defender", "Hitting the receiver in the back", "Throwing over the shoulder", "A type of injury"], "correct": 0}'::jsonb,
  3,
  'live',
  (SELECT id FROM users LIMIT 1),
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  base_prompt = EXCLUDED.base_prompt,
  answer_schema_json = EXCLUDED.answer_schema_json,
  difficulty = EXCLUDED.difficulty,
  status = EXCLUDED.status,
  updated_at = NOW();

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
  '00000004-0002-0004-0000-000000000001',
  '00000004-0002-0000-0000-000000000004',
  1,
  'The QB threw a "back shoulder" fade. Why?',
  '["To place the ball where only the receiver can get it, away from the defender''s momentum", "Because he underthrew the ball by mistake", "To hit the receiver in the numbers", "To lead the receiver into the endzone"]',
  '{"index": 0}',
  'A back shoulder throw is intentional. When a defender is running fast to cover a deep route, the QB throws it slightly behind the receiver so they can turn around and catch it while the defender runs past.',
  true,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  prompt_richtext = EXCLUDED.prompt_richtext,
  options_json = EXCLUDED.options_json,
  correct_answer_json = EXCLUDED.correct_answer_json,
  explanation_richtext = EXCLUDED.explanation_richtext,
  active = EXCLUDED.active,
  updated_at = NOW();

-- Item 5: Pylon
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
  '00000004-0002-0000-0000-000000000005',
  '00000004-0000-0000-0000-000000000002',
  'mcq',
  'Meaning of "pylon"',
  '{"type": "mcq", "options": ["Orange markers at the corners of the end zone", "The goal posts", "The yard markers", "The coach''s headset"], "correct": 0}'::jsonb,
  2,
  'live',
  (SELECT id FROM users LIMIT 1),
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  base_prompt = EXCLUDED.base_prompt,
  answer_schema_json = EXCLUDED.answer_schema_json,
  difficulty = EXCLUDED.difficulty,
  status = EXCLUDED.status,
  updated_at = NOW();

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
  '00000004-0002-0005-0000-000000000001',
  '00000004-0002-0000-0000-000000000005',
  1,
  'The runner dove for the "pylon". What is he trying to do?',
  '["Touch the orange marker at the corner of the end zone to score a touchdown", "Run out of bounds", "Avoid a tackle", "Signal for a timeout"]',
  '{"index": 0}',
  'The pylons are the orange rectangular markers at the four corners of the end zone. If the ball touches the pylon while in a player''s possession, it counts as a touchdown.',
  true,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  prompt_richtext = EXCLUDED.prompt_richtext,
  options_json = EXCLUDED.options_json,
  correct_answer_json = EXCLUDED.correct_answer_json,
  explanation_richtext = EXCLUDED.explanation_richtext,
  active = EXCLUDED.active,
  updated_at = NOW();

-- Item 6: QB Sneak
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
  '00000004-0002-0000-0000-000000000006',
  '00000004-0000-0000-0000-000000000002',
  'mcq',
  'Meaning of "QB Sneak"',
  '{"type": "mcq", "options": ["QB runs directly forward behind the center", "QB hides from the defense", "QB runs a trick play", "QB passes to a lineman"], "correct": 0}'::jsonb,
  1,
  'live',
  (SELECT id FROM users LIMIT 1),
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  base_prompt = EXCLUDED.base_prompt,
  answer_schema_json = EXCLUDED.answer_schema_json,
  difficulty = EXCLUDED.difficulty,
  status = EXCLUDED.status,
  updated_at = NOW();

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
  '00000004-0002-0006-0000-000000000001',
  '00000004-0002-0000-0000-000000000006',
  1,
  'It''s 4th and inches. The team calls a "QB Sneak". What happens?',
  '["The QB takes the snap and immediately dives forward behind the center", "The QB fakes a handoff and runs outside", "The QB throws a quick pass", "The QB punts the ball"]',
  '{"index": 0}',
  'A QB Sneak is a short-yardage play where the quarterback takes the snap and immediately pushes forward behind his center to gain a small amount of yardage.',
  true,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  prompt_richtext = EXCLUDED.prompt_richtext,
  options_json = EXCLUDED.options_json,
  correct_answer_json = EXCLUDED.correct_answer_json,
  explanation_richtext = EXCLUDED.explanation_richtext,
  active = EXCLUDED.active,
  updated_at = NOW();

-- Item 7: Pitch vs Lateral (Multi-select)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
  '00000004-0002-0000-0000-000000000007',
  '00000004-0000-0000-0000-000000000002',
  'multi_select',
  'Pitch vs Lateral',
  '{"type": "multi_select", "options": ["A pitch is usually an underhand toss to a running back", "A lateral can be thrown overhand or underhand", "A lateral must go backwards or sideways", "A pitch must go forward"], "correct": [0, 1, 2]}'::jsonb,
  3,
  'live',
  (SELECT id FROM users LIMIT 1),
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  base_prompt = EXCLUDED.base_prompt,
  answer_schema_json = EXCLUDED.answer_schema_json,
  difficulty = EXCLUDED.difficulty,
  status = EXCLUDED.status,
  updated_at = NOW();

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
  '00000004-0002-0007-0000-000000000001',
  '00000004-0002-0000-0000-000000000007',
  1,
  'Which of the following are TRUE about pitches and laterals? (Select all that apply)',
  '["A pitch is usually an underhand toss from QB to RB", "A lateral is any pass that does not go forward", "A lateral can be thrown anywhere on the field", "A forward pass can be thrown after a lateral (if behind line of scrimmage)"]',
  '{"indices": [0, 1, 2, 3]}',
  'All are true! A pitch is a specific type of lateral (usually underhand). A lateral is any backward pass. You can lateral anywhere, and if you are behind the line of scrimmage, you can even throw a forward pass after receiving a lateral.',
  true,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  prompt_richtext = EXCLUDED.prompt_richtext,
  options_json = EXCLUDED.options_json,
  correct_answer_json = EXCLUDED.correct_answer_json,
  explanation_richtext = EXCLUDED.explanation_richtext,
  active = EXCLUDED.active,
  updated_at = NOW();

-- ============================================================================
-- Lesson 3: The Details
-- ============================================================================
INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, created_at, updated_at)
VALUES (
  '00000004-0000-0000-0000-000000000003',
  '00000000-0000-0000-0000-000000000004',
  'The Details',
  'Learn about the finer details: from the laces to the long snapper.',
  3,
  5,
  100,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  order_index = EXCLUDED.order_index,
  est_minutes = EXCLUDED.est_minutes,
  xp_award = EXCLUDED.xp_award,
  updated_at = NOW();

-- Item 1: Long Snapper
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
  '00000004-0003-0000-0000-000000000001',
  '00000004-0000-0000-0000-000000000003',
  'mcq',
  'Role of Long Snapper',
  '{"type": "mcq", "options": ["Punts and Field Goals", "Kickoffs", "Hail Marys", "QB Sneaks"], "correct": 0}'::jsonb,
  2,
  'live',
  (SELECT id FROM users LIMIT 1),
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  base_prompt = EXCLUDED.base_prompt,
  answer_schema_json = EXCLUDED.answer_schema_json,
  difficulty = EXCLUDED.difficulty,
  status = EXCLUDED.status,
  updated_at = NOW();

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
  '00000004-0003-0001-0000-000000000001',
  '00000004-0003-0000-0000-000000000001',
  1,
  'On which plays is the Long Snapper (LS) on the field?',
  '["Punts and Field Goals", "Kickoffs and Onside Kicks", "Every offensive play", "Only on defense"]',
  '{"index": 0}',
  'The Long Snapper is a specialist who snaps the ball a long distance (7-15 yards) for Punts and Field Goals/Extra Points. They are not used on regular offensive plays.',
  true,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  prompt_richtext = EXCLUDED.prompt_richtext,
  options_json = EXCLUDED.options_json,
  correct_answer_json = EXCLUDED.correct_answer_json,
  explanation_richtext = EXCLUDED.explanation_richtext,
  active = EXCLUDED.active,
  updated_at = NOW();

-- Item 2: Laces out
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
  '00000004-0003-0000-0000-000000000002',
  '00000004-0000-0000-0000-000000000003',
  'mcq',
  'Laces out meaning',
  '{"type": "mcq", "options": ["Spinning the ball so laces face away from the kicker", "Removing the laces", "Tying shoes tight", "Throwing a spiral"], "correct": 0}'::jsonb,
  2,
  'live',
  (SELECT id FROM users LIMIT 1),
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  base_prompt = EXCLUDED.base_prompt,
  answer_schema_json = EXCLUDED.answer_schema_json,
  difficulty = EXCLUDED.difficulty,
  status = EXCLUDED.status,
  updated_at = NOW();

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
  '00000004-0003-0002-0000-000000000001',
  '00000004-0003-0000-0000-000000000002',
  1,
  'Why does the holder spin the ball to put the "laces out" for a field goal?',
  '["To provide a smooth surface for the kicker''s foot", "To make the ball look better", "To help the referee see the ball", "It''s a superstition"]',
  '{"index": 0}',
  'The holder spins the ball so the laces face the goal posts ("laces out"). If the kicker kicks the laces, the ball''s flight can be unpredictable and inaccurate.',
  true,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  prompt_richtext = EXCLUDED.prompt_richtext,
  options_json = EXCLUDED.options_json,
  correct_answer_json = EXCLUDED.correct_answer_json,
  explanation_richtext = EXCLUDED.explanation_richtext,
  active = EXCLUDED.active,
  updated_at = NOW();

-- Item 3: Hash marks
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
  '00000004-0003-0000-0000-000000000003',
  '00000004-0000-0000-0000-000000000003',
  'mcq',
  'Hash marks function',
  '{"type": "mcq", "options": ["Determine lateral placement of the ball", "Mark the 50 yard line", "Show where coaches can stand", "Indicate timeouts remaining"], "correct": 0}'::jsonb,
  2,
  'live',
  (SELECT id FROM users LIMIT 1),
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  base_prompt = EXCLUDED.base_prompt,
  answer_schema_json = EXCLUDED.answer_schema_json,
  difficulty = EXCLUDED.difficulty,
  status = EXCLUDED.status,
  updated_at = NOW();

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
  '00000004-0003-0003-0000-000000000001',
  '00000004-0003-0000-0000-000000000003',
  1,
  'A play ends near the sideline. Where is the ball placed for the next snap?',
  '["On the nearest hash mark", "Exactly where the player was tackled", "In the center of the field", "On the sideline"]',
  '{"index": 0}',
  'If a play ends outside the hash marks (near the sideline), the ball is brought in and placed on the nearest hash mark. This ensures the offense always has some room to work with on both sides.',
  true,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  prompt_richtext = EXCLUDED.prompt_richtext,
  options_json = EXCLUDED.options_json,
  correct_answer_json = EXCLUDED.correct_answer_json,
  explanation_richtext = EXCLUDED.explanation_richtext,
  active = EXCLUDED.active,
  updated_at = NOW();

-- Item 4: Cadence
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
  '00000004-0003-0000-0000-000000000004',
  '00000004-0000-0000-0000-000000000003',
  'mcq',
  'Meaning of cadence',
  '{"type": "mcq", "options": ["The rhythm and words the QB uses to call the snap", "The speed of the runner", "The referee''s whistle", "The band''s music"], "correct": 0}'::jsonb,
  2,
  'live',
  (SELECT id FROM users LIMIT 1),
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  base_prompt = EXCLUDED.base_prompt,
  answer_schema_json = EXCLUDED.answer_schema_json,
  difficulty = EXCLUDED.difficulty,
  status = EXCLUDED.status,
  updated_at = NOW();

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
  '00000004-0003-0004-0000-000000000001',
  '00000004-0003-0000-0000-000000000004',
  1,
  'The QB uses a "hard count" in his cadence. What is he trying to do?',
  '["Trick the defense into jumping offside", "Snap the ball quickly", "Call a timeout", "Yell at his teammates"]',
  '{"index": 0}',
  'Cadence is the QB''s vocal signals ("Down, Set, Hut!"). A "hard count" changes the rhythm or volume to try and make eager defenders jump across the line before the ball is snapped.',
  true,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  prompt_richtext = EXCLUDED.prompt_richtext,
  options_json = EXCLUDED.options_json,
  correct_answer_json = EXCLUDED.correct_answer_json,
  explanation_richtext = EXCLUDED.explanation_richtext,
  active = EXCLUDED.active,
  updated_at = NOW();

-- Item 5: Spiral
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
  '00000004-0003-0000-0000-000000000005',
  '00000004-0000-0000-0000-000000000003',
  'mcq',
  'Importance of spiral',
  '{"type": "mcq", "options": ["Aerodynamics and accuracy", "It looks cool", "It hurts the receiver''s hands", "It makes the ball heavier"], "correct": 0}'::jsonb,
  1,
  'live',
  (SELECT id FROM users LIMIT 1),
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  base_prompt = EXCLUDED.base_prompt,
  answer_schema_json = EXCLUDED.answer_schema_json,
  difficulty = EXCLUDED.difficulty,
  status = EXCLUDED.status,
  updated_at = NOW();

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
  '00000004-0003-0005-0000-000000000001',
  '00000004-0003-0000-0000-000000000005',
  1,
  'Why do quarterbacks want to throw a "tight spiral"?',
  '["It cuts through the wind and is more accurate", "It is harder to catch", "It moves slower", "It is easier to intercept"]',
  '{"index": 0}',
  'A tight spiral (spinning on its axis) is aerodynamic, allowing the ball to travel farther, faster, and more accurately, especially in windy conditions.',
  true,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  prompt_richtext = EXCLUDED.prompt_richtext,
  options_json = EXCLUDED.options_json,
  correct_answer_json = EXCLUDED.correct_answer_json,
  explanation_richtext = EXCLUDED.explanation_richtext,
  active = EXCLUDED.active,
  updated_at = NOW();

-- Item 6: Pocket
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
  '00000004-0003-0000-0000-000000000006',
  '00000004-0000-0000-0000-000000000003',
  'mcq',
  'Meaning of pocket',
  '{"type": "mcq", "options": ["Protected area formed by blockers for the QB", "Where the QB keeps his plays", "The area on the sideline", "The end zone"], "correct": 0}'::jsonb,
  2,
  'live',
  (SELECT id FROM users LIMIT 1),
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  base_prompt = EXCLUDED.base_prompt,
  answer_schema_json = EXCLUDED.answer_schema_json,
  difficulty = EXCLUDED.difficulty,
  status = EXCLUDED.status,
  updated_at = NOW();

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
  '00000004-0003-0006-0000-000000000001',
  '00000004-0003-0000-0000-000000000006',
  1,
  'The commentator says the QB "stepped up in the pocket". What did he do?',
  '["Moved forward inside the protection of his offensive line", "Ran out of bounds", "Ran backwards", "Threw the ball away"]',
  '{"index": 0}',
  'The "pocket" is the U-shaped protective shell formed by the offensive line. Stepping up means moving forward into this safe area to avoid defenders coming from the outside edges.',
  true,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  prompt_richtext = EXCLUDED.prompt_richtext,
  options_json = EXCLUDED.options_json,
  correct_answer_json = EXCLUDED.correct_answer_json,
  explanation_richtext = EXCLUDED.explanation_richtext,
  active = EXCLUDED.active,
  updated_at = NOW();
