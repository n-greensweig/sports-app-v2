-- Generated Seed Script for Module 1 (10 lessons)
-- Run this in Supabase SQL Editor

-- 1. Ensure Football Sport exists
INSERT INTO sports (id, slug, name, is_active, order_index, created_at, updated_at)
VALUES ('0105433b-5bdd-4093-b6b1-157a0c3c515e', 'football', 'Football', true, 1, now(), now())
ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name;

-- 2. Ensure Football Basics Module exists
INSERT INTO modules (id, sport_id, title, description, order_index, min_level, max_level, xp_reward, created_at, updated_at)
VALUES ('11111111-1111-1111-1111-111111111111', '0105433b-5bdd-4093-b6b1-157a0c3c515e', 'Football Basics', 'Master the fundamentals of football', 1, 1, 2, 0, now(), now())
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description;

-- 3. Insert Lessons and Items
-- Lesson 1: Runs vs Passes
INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, created_at, updated_at)
VALUES ('00000001-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111', 'Runs vs Passes', 'Learn to identify the two main types of offensive plays', 1, 4, 80, false, now(), now())
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, est_minutes = EXCLUDED.est_minutes;
  -- Item 1
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000001-0000-0000-0000-000000000001', '00000001-0000-0000-0000-000000000001', 'mcq', 'Identify play type', '{"type": "mcq", "options": ["Run", "Pass"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000001-0000-0000-0000-000000000001', '10000001-0000-0000-0000-000000000001', 1, 'The quarterback hands the ball to a running back who runs forward. What type of play is this?', '["Run", "Pass"]'::jsonb, '{"index": 0}'::jsonb, 'This is a run play. When the ball is handed off or the QB runs with it, it''s a running play. A pass is when the QB throws the ball through the air.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 2
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000001-0000-0000-0000-000000000002', '00000001-0000-0000-0000-000000000001', 'mcq', 'Identify play type', '{"type": "mcq", "options": ["Run", "Pass"], "correct": 1}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000001-0000-0000-0000-000000000002', '10000001-0000-0000-0000-000000000002', 1, 'The quarterback throws the ball to a receiver downfield. What type of play is this?', '["Run", "Pass"]'::jsonb, '{"index": 1}'::jsonb, 'This is a pass play. When the QB throws the ball through the air to a teammate, it''s a passing play.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 3
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000001-0000-0000-0000-000000000003', '00000001-0000-0000-0000-000000000001', 'mcq', 'Identify play type', '{"type": "mcq", "options": ["Run", "Pass", "Kick"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000001-0000-0000-0000-000000000003', '10000001-0000-0000-0000-000000000003', 1, 'The quarterback keeps the ball and runs forward himself. What type of play is this?', '["Run", "Pass", "Kick"]'::jsonb, '{"index": 0}'::jsonb, 'This is a run play. Even though the QB is running (not a running back), any play where someone carries the ball is a run.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 4
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000001-0000-0000-0000-000000000004', '00000001-0000-0000-0000-000000000001', 'mcq', 'Identify incomplete pass', '{"type": "mcq", "options": ["The other team gets the ball", "The play is over and they try again", "Automatic touchdown"], "correct": 1}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000001-0000-0000-0000-000000000004', '10000001-0000-0000-0000-000000000004', 1, 'The quarterback throws the ball but no one catches it. What happens next?', '["The other team gets the ball", "The play is over and they try again", "Automatic touchdown"]'::jsonb, '{"index": 1}'::jsonb, 'When a pass isn''t caught (incomplete pass), the play is over and the offense tries again from the same spot.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 5
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000001-0000-0000-0000-000000000005', '00000001-0000-0000-0000-000000000001', 'mcq', 'Understand incomplete pass result', '{"type": "mcq", "options": ["It increases by one (e.g., 1st to 2nd down)", "It stays the same", "It resets to 1st down"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000001-0000-0000-0000-000000000005', '10000001-0000-0000-0000-000000000005', 1, 'What happens to the down count after an incomplete pass?', '["It increases by one (e.g., 1st to 2nd down)", "It stays the same", "It resets to 1st down"]'::jsonb, '{"index": 0}'::jsonb, 'Even though no yards were gained, an incomplete pass uses up a down. The offense has one less chance to get a first down.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 6
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000001-0000-0000-0000-000000000006', '00000001-0000-0000-0000-000000000001', 'mcq', 'Understand handoff', '{"type": "mcq", "options": ["Handoff", "Pass", "Snap", "Tackle"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000001-0000-0000-0000-000000000006', '10000001-0000-0000-0000-000000000006', 1, 'What is it called when the QB gives the ball to a running back?', '["Handoff", "Pass", "Snap", "Tackle"]'::jsonb, '{"index": 0}'::jsonb, 'A handoff is when the QB hands the ball directly to another player, usually a running back. This starts most running plays.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 7
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000001-0000-0000-0000-000000000007', '00000001-0000-0000-0000-000000000001', 'mcq', 'Identify receiver', '{"type": "mcq", "options": ["Receivers", "Offensive linemen", "Referees"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000001-0000-0000-0000-000000000007', '10000001-0000-0000-0000-000000000007', 1, 'Who catches passes from the quarterback?', '["Receivers", "Offensive linemen", "Referees"]'::jsonb, '{"index": 0}'::jsonb, 'Receivers (also called wide receivers or tight ends) are the players who catch passes. They run routes to get open for the QB to throw to them.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 8
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000001-0000-0000-0000-000000000008', '00000001-0000-0000-0000-000000000001', 'mcq', 'Understand interception', '{"type": "mcq", "options": ["Interception", "Fumble", "Sack", "Touchdown"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000001-0000-0000-0000-000000000008', '10000001-0000-0000-0000-000000000008', 1, 'A defensive player catches a pass intended for the offense. What is this called?', '["Interception", "Fumble", "Sack", "Touchdown"]'::jsonb, '{"index": 0}'::jsonb, 'An interception occurs when a defensive player catches a pass meant for an offensive player. This gives possession to the defense, who becomes the offense.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 9
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000001-0000-0000-0000-000000000009', '00000001-0000-0000-0000-000000000001', 'mcq', 'Understand sack', '{"type": "mcq", "options": ["Sack", "Interception", "Fumble", "Incomplete pass"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000001-0000-0000-0000-000000000009', '10000001-0000-0000-0000-000000000009', 1, 'The defense tackles the quarterback before he can throw the ball. What is this called?', '["Sack", "Interception", "Fumble", "Incomplete pass"]'::jsonb, '{"index": 0}'::jsonb, 'A sack is when the QB is tackled behind the line of scrimmage before throwing the ball.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 10
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000001-0000-0000-0000-000000000010', '00000001-0000-0000-0000-000000000001', 'mcq', 'Understand sack consequence', '{"type": "mcq", "options": ["Loss of yards", "Gain of yards", "Automatic turnover"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000001-0000-0000-0000-000000000010', '10000001-0000-0000-0000-000000000010', 1, 'What is the result of a sack for the offense?', '["Loss of yards", "Gain of yards", "Automatic turnover"]'::jsonb, '{"index": 0}'::jsonb, 'A sack results in a loss of yards because the play ends behind where it started. It puts the offense in a difficult ''long yardage'' situation.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;

-- Lesson 2: Understanding Downs
INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, created_at, updated_at)
VALUES ('00000001-0000-0000-0000-000000000002', '11111111-1111-1111-1111-111111111111', 'Understanding Downs', 'Learn how the down system works and why it matters', 2, 5, 80, true, now(), now())
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, est_minutes = EXCLUDED.est_minutes;
  -- Item 1
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000002-0000-0000-0000-000000000001', '00000001-0000-0000-0000-000000000002', 'mcq', 'Understand downs', '{"type": "mcq", "options": ["2", "3", "4", "5"], "correct": 2}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000002-0000-0000-0000-000000000001', '10000002-0000-0000-0000-000000000001', 1, 'How many chances (downs) does the offense get to move 10 yards?', '["2", "3", "4", "5"]'::jsonb, '{"index": 2}'::jsonb, 'The offense gets 4 downs (chances) to move the ball 10 yards. If they succeed, they get a new set of 4 downs (called a ''first down'').', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 2
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000002-0000-0000-0000-000000000002', '00000001-0000-0000-0000-000000000002', 'mcq', 'Understand first down', '{"type": "mcq", "options": ["They score points", "They get 4 new downs", "The other team gets the ball"], "correct": 1}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000002-0000-0000-0000-000000000002', '10000002-0000-0000-0000-000000000002', 1, 'What happens when the offense gains 10 or more yards?', '["They score points", "They get 4 new downs", "The other team gets the ball"]'::jsonb, '{"index": 1}'::jsonb, 'When the offense gains 10+ yards, they earn a ''first down'' - a new set of 4 downs.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 3
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000002-0000-0000-0000-000000000003', '00000001-0000-0000-0000-000000000002', 'mcq', 'Understand first down goal', '{"type": "mcq", "options": ["Gain 10 yards to get a new first down", "Score a touchdown on every play", "Kick a field goal"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000002-0000-0000-0000-000000000003', '10000002-0000-0000-0000-000000000003', 1, 'What is the primary goal of the offense on every set of downs?', '["Gain 10 yards to get a new first down", "Score a touchdown on every play", "Kick a field goal"]'::jsonb, '{"index": 0}'::jsonb, 'While scoring is the ultimate goal, the immediate goal is to gain 10 yards. This keeps the drive alive and moves the team closer to the end zone.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 4
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000002-0000-0000-0000-000000000004', '00000001-0000-0000-0000-000000000002', 'mcq', 'Understand 4th down', '{"type": "mcq", "options": ["Punt the ball", "Go for it", "Both A and B are common"], "correct": 2}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000002-0000-0000-0000-000000000004', '10000002-0000-0000-0000-000000000004', 1, 'It''s 4th down and the offense hasn''t gained 10 yards yet. What do teams usually do?', '["Punt the ball", "Go for it", "Both A and B are common"]'::jsonb, '{"index": 2}'::jsonb, 'On 4th down, teams usually punt (kick the ball away) to give the other team worse field position.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 5
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000002-0000-0000-0000-000000000005', '00000001-0000-0000-0000-000000000002', 'mcq', 'Understand 4th down risk', '{"type": "mcq", "options": ["If you fail, the other team gets the ball right there", "It''s a penalty", "You lose points"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000002-0000-0000-0000-000000000005', '10000002-0000-0000-0000-000000000005', 1, 'Why is ''going for it'' on 4th down risky?', '["If you fail, the other team gets the ball right there", "It''s a penalty", "You lose points"]'::jsonb, '{"index": 0}'::jsonb, 'If the offense fails to get the first down, the other team takes over possession at that spot. This often gives them great field position to score.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 6
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000002-0000-0000-0000-000000000006', '00000001-0000-0000-0000-000000000002', 'mcq', 'Read down and distance', '{"type": "mcq", "options": ["It''s the 2nd down and they need 7 yards for a first down", "It''s the 7th down and they need 2 yards", "The score is 2-7"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000002-0000-0000-0000-000000000006', '10000002-0000-0000-0000-000000000006', 1, 'You see ''2nd & 7'' on the screen. What does this mean?', '["It''s the 2nd down and they need 7 yards for a first down", "It''s the 7th down and they need 2 yards", "The score is 2-7"]'::jsonb, '{"index": 0}'::jsonb, '''2nd & 7'' means it''s 2nd down and the offense needs 7 more yards to get a first down. The first number is the down, the second is yards needed.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 7
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000002-0000-0000-0000-000000000007', '00000001-0000-0000-0000-000000000002', 'mcq', 'Understand 3rd down importance', '{"type": "mcq", "options": ["It''s worth more points", "It''s the last chance to get a first down before likely punting", "The QB must throw on 3rd down"], "correct": 1}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000002-0000-0000-0000-000000000007', '10000002-0000-0000-0000-000000000007', 1, 'Why is 3rd down considered the most important down?', '["It''s worth more points", "It''s the last chance to get a first down before likely punting", "The QB must throw on 3rd down"]'::jsonb, '{"index": 1}'::jsonb, '3rd down is crucial because it''s usually the last chance to get a first down before having to punt.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 8
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000002-0000-0000-0000-000000000008', '00000001-0000-0000-0000-000000000002', 'mcq', 'Understand 3rd down strategy', '{"type": "mcq", "options": ["Focus on preventing a long pass", "Blitz everyone", "Let them score"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000002-0000-0000-0000-000000000008', '10000002-0000-0000-0000-000000000008', 1, 'What does the defense typically do on ''3rd and long''?', '["Focus on preventing a long pass", "Blitz everyone", "Let them score"]'::jsonb, '{"index": 0}'::jsonb, 'On 3rd and long, the defense plays conservatively to ensure no receiver catches the ball past the first down marker. They want to force a punt.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 9
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000002-0000-0000-0000-000000000009', '00000001-0000-0000-0000-000000000002', 'mcq', 'Understand punt', '{"type": "mcq", "options": ["A type of pass", "Kicking the ball to the other team", "A running play"], "correct": 1}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000002-0000-0000-0000-000000000009', '10000002-0000-0000-0000-000000000009', 1, 'What is a punt?', '["A type of pass", "Kicking the ball to the other team", "A running play"]'::jsonb, '{"index": 1}'::jsonb, 'A punt is when a team kicks the ball to the other team, usually on 4th down. The goal is to make the opponent start far from the end zone.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 10
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000002-0000-0000-0000-000000000010', '00000001-0000-0000-0000-000000000002', 'mcq', 'Understand turnover on downs', '{"type": "mcq", "options": ["They punt", "The other team gets the ball at that spot", "They get one more chance"], "correct": 1}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000002-0000-0000-0000-000000000010', '10000002-0000-0000-0000-000000000010', 1, 'The offense tries to get a first down on 4th down but fails. What happens?', '["They punt", "The other team gets the ball at that spot", "They get one more chance"]'::jsonb, '{"index": 1}'::jsonb, 'If the offense fails to get a first down on 4th down, it''s called a ''turnover on downs'' and the other team gets the ball right there. This is risky!', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 11
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000002-0000-0000-0000-000000000011', '00000001-0000-0000-0000-000000000002', 'mcq', 'Understand 1st & 10', '{"type": "mcq", "options": ["1st down, need 10 yards", "10th down, need 1 yard", "Score is 1-10"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000002-0000-0000-0000-000000000011', '10000002-0000-0000-0000-000000000011', 1, 'What does ''1st & 10'' mean?', '["1st down, need 10 yards", "10th down, need 1 yard", "Score is 1-10"]'::jsonb, '{"index": 0}'::jsonb, '''1st & 10'' means it''s 1st down and the offense needs to gain 10 yards for a new first down. This is the most common down and distance.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;

-- Lesson 3: Scoring Points
INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, created_at, updated_at)
VALUES ('00000001-0000-0000-0000-000000000003', '11111111-1111-1111-1111-111111111111', 'Scoring Points', 'Learn all the ways teams can score in football', 3, 4, 80, true, now(), now())
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, est_minutes = EXCLUDED.est_minutes;
  -- Item 1
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000003-0000-0000-0000-000000000001', '00000001-0000-0000-0000-000000000003', 'mcq', 'Touchdown value', '{"type": "mcq", "options": ["3", "6", "7"], "correct": 1}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000003-0000-0000-0000-000000000001', '10000003-0000-0000-0000-000000000001', 1, 'How many points is a touchdown worth?', '["3", "6", "7"]'::jsonb, '{"index": 1}'::jsonb, 'A touchdown is worth 6 points. It is the most valuable scoring play in football.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 2
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000003-0000-0000-0000-000000000002', '00000001-0000-0000-0000-000000000003', 'mcq', 'Understand post-touchdown', '{"type": "mcq", "options": ["They attempt an extra point or 2-point conversion", "They kick off immediately", "The game ends"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000003-0000-0000-0000-000000000002', '10000003-0000-0000-0000-000000000002', 1, 'What happens immediately after a team scores a touchdown?', '["They attempt an extra point or 2-point conversion", "They kick off immediately", "The game ends"]'::jsonb, '{"index": 0}'::jsonb, 'After the 6 points for a touchdown, the team gets a bonus chance to score 1 point (kick) or 2 points (run/pass) from the 2-yard line.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 3
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000003-0000-0000-0000-000000000003', '00000001-0000-0000-0000-000000000003', 'mcq', 'Field goal value', '{"type": "mcq", "options": ["1", "2", "3", "6"], "correct": 2}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000003-0000-0000-0000-000000000003', '10000003-0000-0000-0000-000000000003', 1, 'How many points is a field goal worth?', '["1", "2", "3", "6"]'::jsonb, '{"index": 2}'::jsonb, 'A field goal is worth 3 points. It''s kicked through the uprights (goal posts) and is often attempted when a team can''t score a touchdown.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 4
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000003-0000-0000-0000-000000000004', '00000001-0000-0000-0000-000000000003', 'mcq', 'Extra point value', '{"type": "mcq", "options": ["1", "2", "3"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000003-0000-0000-0000-000000000004', '10000003-0000-0000-0000-000000000004', 1, 'After a touchdown, how many points is a successful extra point kick worth?', '["1", "2", "3"]'::jsonb, '{"index": 0}'::jsonb, 'An extra point (also called PAT - Point After Touchdown) is worth 1 point. It''s a short kick through the uprights after a touchdown.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 5
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000003-0000-0000-0000-000000000005', '00000001-0000-0000-0000-000000000003', 'mcq', '2-point conversion', '{"type": "mcq", "options": ["Kick a longer field goal", "Run or pass the ball into the end zone", "Nothing - you can''t get 2 points"], "correct": 1}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000003-0000-0000-0000-000000000005', '10000003-0000-0000-0000-000000000005', 1, 'Instead of kicking an extra point, what can a team do for 2 points?', '["Kick a longer field goal", "Run or pass the ball into the end zone", "Nothing - you can''t get 2 points"]'::jsonb, '{"index": 1}'::jsonb, 'After a touchdown, a team can attempt a 2-point conversion by running or passing the ball into the end zone from the 2-yard line. It''s riskier but worth 2 points instead of 1.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 6
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000003-0000-0000-0000-000000000006', '00000001-0000-0000-0000-000000000003', 'mcq', 'Safety value', '{"type": "mcq", "options": ["1", "2", "3", "6"], "correct": 1}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000003-0000-0000-0000-000000000006', '10000003-0000-0000-0000-000000000006', 1, 'How many points does the defense score for a safety?', '["1", "2", "3", "6"]'::jsonb, '{"index": 1}'::jsonb, 'A safety is worth 2 points for the defense. It happens when the offense is tackled in their own end zone.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 7
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000003-0000-0000-0000-000000000007', '00000001-0000-0000-0000-000000000003', 'mcq', 'Understand safety result', '{"type": "mcq", "options": ["The team that scored the safety (defense)", "The team that was tackled (offense)", "The referees"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000003-0000-0000-0000-000000000007', '10000003-0000-0000-0000-000000000007', 1, 'Who gets the ball after a safety?', '["The team that scored the safety (defense)", "The team that was tackled (offense)", "The referees"]'::jsonb, '{"index": 0}'::jsonb, 'A safety is a disaster for the offense! Not only do they give up 2 points, but they also have to kick the ball to the defense, losing possession.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 8
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000003-0000-0000-0000-000000000008', '00000001-0000-0000-0000-000000000003', 'mcq', 'Understand touchdown', '{"type": "mcq", "options": ["The ball must cross the goal line", "The player must be tackled", "The ball must be kicked"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000003-0000-0000-0000-000000000008', '10000003-0000-0000-0000-000000000008', 1, 'What must happen for a touchdown to be scored?', '["The ball must cross the goal line", "The player must be tackled", "The ball must be kicked"]'::jsonb, '{"index": 0}'::jsonb, 'For a touchdown, the ball must cross the plane of the goal line while in possession of a player. Even if just the tip of the ball crosses, it''s a touchdown!', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 9
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000003-0000-0000-0000-000000000009', '00000001-0000-0000-0000-000000000003', 'mcq', 'Most common score', '{"type": "mcq", "options": ["Touchdowns", "Field goals", "Safeties"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000003-0000-0000-0000-000000000009', '10000003-0000-0000-0000-000000000009', 1, 'What''s the most common way teams score points?', '["Touchdowns", "Field goals", "Safeties"]'::jsonb, '{"index": 0}'::jsonb, 'Touchdowns (6 points + extra point = 7 total) are the most common and valuable way to score. Teams always try to score touchdowns first.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 10
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000003-0000-0000-0000-000000000010', '00000001-0000-0000-0000-000000000003', 'mcq', 'Understand end zone', '{"type": "mcq", "options": ["End zone", "Goal line", "Touchdown zone"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000003-0000-0000-0000-000000000010', '10000003-0000-0000-0000-000000000010', 1, 'What is the area at each end of the field where touchdowns are scored called?', '["End zone", "Goal line", "Touchdown zone"]'::jsonb, '{"index": 0}'::jsonb, 'The end zone is the 10-yard area at each end of the field. Getting the ball into the opponent''s end zone scores a touchdown.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;

-- Lesson 4: Basic Positions - Offense
INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, created_at, updated_at)
VALUES ('00000001-0000-0000-0000-000000000004', '11111111-1111-1111-1111-111111111111', 'Basic Positions - Offense', 'Learn the key offensive positions and their roles', 4, 5, 80, true, now(), now())
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, est_minutes = EXCLUDED.est_minutes;
  -- Item 1
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000004-0000-0000-0000-000000000001', '00000001-0000-0000-0000-000000000004', 'mcq', 'Identify QB', '{"type": "mcq", "options": ["Quarterback", "Running back", "Wide receiver"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000004-0000-0000-0000-000000000001', '10000004-0000-0000-0000-000000000001', 1, 'Who throws most of the passes on offense?', '["Quarterback", "Running back", "Wide receiver"]'::jsonb, '{"index": 0}'::jsonb, 'The quarterback (QB) is the leader of the offense and throws most passes.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 2
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000004-0000-0000-0000-000000000002', '00000001-0000-0000-0000-000000000004', 'mcq', 'Understand QB role', '{"type": "mcq", "options": ["Communicating the play to the rest of the offense", "Blocking for the running back", "Kicking field goals"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000004-0000-0000-0000-000000000002', '10000004-0000-0000-0000-000000000002', 1, 'Besides throwing, what is a key responsibility of the Quarterback?', '["Communicating the play to the rest of the offense", "Blocking for the running back", "Kicking field goals"]'::jsonb, '{"index": 0}'::jsonb, 'The QB is the ''field general''. They receive the play from the coach and communicate it to the other 10 players in the huddle.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 3
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000004-0000-0000-0000-000000000003', '00000001-0000-0000-0000-000000000004', 'mcq', 'Identify RB', '{"type": "mcq", "options": ["Quarterback", "Running back", "Offensive lineman"], "correct": 1}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000004-0000-0000-0000-000000000003', '10000004-0000-0000-0000-000000000003', 1, 'Which position primarily carries the ball on running plays?', '["Quarterback", "Running back", "Offensive lineman"]'::jsonb, '{"index": 1}'::jsonb, 'Running backs (RB) are the main ball carriers on run plays. They take handoffs from the QB and try to gain yards. They can also catch passes.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 4
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000004-0000-0000-0000-000000000004', '00000001-0000-0000-0000-000000000004', 'mcq', 'Identify WR', '{"type": "mcq", "options": ["Wide receivers", "Offensive linemen", "Running backs"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000004-0000-0000-0000-000000000004', '10000004-0000-0000-0000-000000000004', 1, 'Which players line up wide and catch passes?', '["Wide receivers", "Offensive linemen", "Running backs"]'::jsonb, '{"index": 0}'::jsonb, 'Wide receivers (WR) line up near the sidelines and run routes to catch passes from the QB. They''re usually the fastest players on offense.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 5
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000004-0000-0000-0000-000000000005', '00000001-0000-0000-0000-000000000004', 'mcq', 'Understand O-line', '{"type": "mcq", "options": ["Catch passes", "Protect the QB and create running lanes", "Tackle defenders"], "correct": 1}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000004-0000-0000-0000-000000000005', '10000004-0000-0000-0000-000000000005', 1, 'What is the main job of the offensive line?', '["Catch passes", "Protect the QB and create running lanes", "Tackle defenders"]'::jsonb, '{"index": 1}'::jsonb, 'The offensive line (5 big players) protects the QB from being tackled and blocks defenders to create running lanes for the running back.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 6
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000004-0000-0000-0000-000000000006', '00000001-0000-0000-0000-000000000004', 'mcq', 'Identify center', '{"type": "mcq", "options": ["Center", "Guard", "Tackle"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000004-0000-0000-0000-000000000006', '10000004-0000-0000-0000-000000000006', 1, 'Which offensive lineman snaps the ball to the quarterback?', '["Center", "Guard", "Tackle"]'::jsonb, '{"index": 0}'::jsonb, 'The center is the middle offensive lineman who snaps (hikes) the ball to the QB to start each play.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 7
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000004-0000-0000-0000-000000000007', '00000001-0000-0000-0000-000000000004', 'mcq', 'Understand center responsibility', '{"type": "mcq", "options": ["Identify the defensive alignment and make blocking calls", "Run a route", "Talk to the coach"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000004-0000-0000-0000-000000000007', '10000004-0000-0000-0000-000000000007', 1, 'What must the center do before snapping the ball?', '["Identify the defensive alignment and make blocking calls", "Run a route", "Talk to the coach"]'::jsonb, '{"index": 0}'::jsonb, 'The center is often the ''brain'' of the offensive line. They point out the middle linebacker and adjust the blocking scheme based on the defense.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 8
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000004-0000-0000-0000-000000000008', '00000001-0000-0000-0000-000000000004', 'mcq', 'Identify TE', '{"type": "mcq", "options": ["Tight end", "Running back", "Quarterback"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000004-0000-0000-0000-000000000008', '10000004-0000-0000-0000-000000000008', 1, 'Which position can both block like a lineman and catch passes like a receiver?', '["Tight end", "Running back", "Quarterback"]'::jsonb, '{"index": 0}'::jsonb, 'The tight end (TE) is a hybrid position - they line up next to the offensive line.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 9
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000004-0000-0000-0000-000000000009', '00000001-0000-0000-0000-000000000004', 'mcq', 'Understand TE versatility', '{"type": "mcq", "options": ["They can both block like a lineman and catch like a receiver", "They play both offense and defense", "They can throw the ball"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000004-0000-0000-0000-000000000009', '10000004-0000-0000-0000-000000000009', 1, 'Why is the Tight End considered a ''hybrid'' position?', '["They can both block like a lineman and catch like a receiver", "They play both offense and defense", "They can throw the ball"]'::jsonb, '{"index": 0}'::jsonb, 'Tight Ends are unique because they must be strong enough to block defensive ends but fast enough to run routes and catch passes.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 10
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000004-0000-0000-0000-000000000010', '00000001-0000-0000-0000-000000000004', 'mcq', 'Count offensive players', '{"type": "mcq", "options": ["10", "11", "12"], "correct": 1}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000004-0000-0000-0000-000000000010', '10000004-0000-0000-0000-000000000010', 1, 'How many offensive players are on the field at once?', '["10", "11", "12"]'::jsonb, '{"index": 1}'::jsonb, 'There are always 11 players on offense (and 11 on defense). Having too many or too few players on the field results in a penalty.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 11
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000004-0000-0000-0000-000000000011', '00000001-0000-0000-0000-000000000004', 'mcq', 'Understand snap', '{"type": "mcq", "options": ["Snap", "Handoff", "Pass"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000004-0000-0000-0000-000000000011', '10000004-0000-0000-0000-000000000011', 1, 'What is it called when the center gives the ball to the QB to start a play?', '["Snap", "Handoff", "Pass"]'::jsonb, '{"index": 0}'::jsonb, 'The snap is when the center hikes the ball between his legs to the QB. This starts every offensive play. The QB usually yells signals before the snap.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;

-- Lesson 5: Basic Positions - Defense
INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, created_at, updated_at)
VALUES ('00000001-0000-0000-0000-000000000005', '11111111-1111-1111-1111-111111111111', 'Basic Positions - Defense', 'Learn the key defensive positions and their roles', 5, 5, 80, true, now(), now())
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, est_minutes = EXCLUDED.est_minutes;
  -- Item 1
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000005-0000-0000-0000-000000000001', '00000001-0000-0000-0000-000000000005', 'mcq', 'Understand defense goal', '{"type": "mcq", "options": ["Score touchdowns", "Stop the offense from scoring", "Kick field goals"], "correct": 1}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000005-0000-0000-0000-000000000001', '10000005-0000-0000-0000-000000000001', 1, 'What is the main goal of the defense?', '["Score touchdowns", "Stop the offense from scoring", "Kick field goals"]'::jsonb, '{"index": 1}'::jsonb, 'The defense tries to stop the offense from scoring and gaining yards.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 2
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000005-0000-0000-0000-000000000002', '00000001-0000-0000-0000-000000000005', 'mcq', 'Understand defensive scoring', '{"type": "mcq", "options": ["By returning an interception or fumble for a touchdown", "By tackling the QB", "By forcing a punt"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000005-0000-0000-0000-000000000002', '10000005-0000-0000-0000-000000000002', 1, 'How can the defense score points directly?', '["By returning an interception or fumble for a touchdown", "By tackling the QB", "By forcing a punt"]'::jsonb, '{"index": 0}'::jsonb, 'While their main job is stopping the offense, the defense can score 6 points if they steal the ball (turnover) and run it into the opponent''s end zone.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 3
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000005-0000-0000-0000-000000000003', '00000001-0000-0000-0000-000000000005', 'mcq', 'Identify DL', '{"type": "mcq", "options": ["Defensive linemen", "Linebackers", "Safeties"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000005-0000-0000-0000-000000000003', '10000005-0000-0000-0000-000000000003', 1, 'Which defensive players line up right across from the offensive line?', '["Defensive linemen", "Linebackers", "Safeties"]'::jsonb, '{"index": 0}'::jsonb, 'Defensive linemen (DL) line up on the line of scrimmage across from offensive linemen. They try to tackle the QB or running back and stop runs.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 4
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000005-0000-0000-0000-000000000004', '00000001-0000-0000-0000-000000000005', 'mcq', 'Identify LB', '{"type": "mcq", "options": ["Linebackers", "Cornerbacks", "Safeties"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000005-0000-0000-0000-000000000004', '10000005-0000-0000-0000-000000000004', 1, 'Which defenders play behind the defensive line and can both rush the QB and cover receivers?', '["Linebackers", "Cornerbacks", "Safeties"]'::jsonb, '{"index": 0}'::jsonb, 'Linebackers (LB) are versatile defenders who play behind the D-line.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 5
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000005-0000-0000-0000-000000000005', '00000001-0000-0000-0000-000000000005', 'mcq', 'Understand LB versatility', '{"type": "mcq", "options": ["They defend both the run and the pass", "They play offense too", "They kick the ball"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000005-0000-0000-0000-000000000005', '10000005-0000-0000-0000-000000000005', 1, 'What makes Linebackers ''versatile''?', '["They defend both the run and the pass", "They play offense too", "They kick the ball"]'::jsonb, '{"index": 0}'::jsonb, 'Linebackers must be able to plug holes to stop running backs, but also drop back to cover tight ends and receivers in the passing game.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 6
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000005-0000-0000-0000-000000000006', '00000001-0000-0000-0000-000000000005', 'mcq', 'Identify CB', '{"type": "mcq", "options": ["Cornerbacks", "Linebackers", "Defensive linemen"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000005-0000-0000-0000-000000000006', '10000005-0000-0000-0000-000000000006', 1, 'Which defenders primarily cover wide receivers?', '["Cornerbacks", "Linebackers", "Defensive linemen"]'::jsonb, '{"index": 0}'::jsonb, 'Cornerbacks (CB) are fast defenders who line up across from wide receivers. Their main job is to prevent receivers from catching passes.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 7
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000005-0000-0000-0000-000000000007', '00000001-0000-0000-0000-000000000005', 'mcq', 'Identify safety', '{"type": "mcq", "options": ["Safeties", "Cornerbacks", "Linebackers"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000005-0000-0000-0000-000000000007', '10000005-0000-0000-0000-000000000007', 1, 'Which defenders play deepest in the secondary and are the ''last line of defense''?', '["Safeties", "Cornerbacks", "Linebackers"]'::jsonb, '{"index": 0}'::jsonb, 'Safeties (S) play deep in the secondary (defensive backfield).', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 8
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000005-0000-0000-0000-000000000008', '00000001-0000-0000-0000-000000000005', 'mcq', 'Understand safety role', '{"type": "mcq", "options": ["If a ball carrier gets past them, it''s likely a touchdown", "They are the slowest players", "They line up on the sideline"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000005-0000-0000-0000-000000000008', '10000005-0000-0000-0000-000000000008', 1, 'Why are safeties called the ''last line of defense''?', '["If a ball carrier gets past them, it''s likely a touchdown", "They are the slowest players", "They line up on the sideline"]'::jsonb, '{"index": 0}'::jsonb, 'Safeties play the deepest. If an offensive player gets past the defensive line and linebackers, the safety is the only one left to stop a touchdown.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 9
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000005-0000-0000-0000-000000000009', '00000001-0000-0000-0000-000000000005', 'mcq', 'Understand tackle', '{"type": "mcq", "options": ["Tackle the ball carrier", "Catch the ball", "Block the offensive line"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000005-0000-0000-0000-000000000009', '10000005-0000-0000-0000-000000000009', 1, 'What must the defense do to stop an offensive play?', '["Tackle the ball carrier", "Catch the ball", "Block the offensive line"]'::jsonb, '{"index": 0}'::jsonb, 'To stop a play, the defense must tackle (bring down) the player carrying the ball. The play ends when the ball carrier is tackled or goes out of bounds.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 10
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000005-0000-0000-0000-000000000010', '00000001-0000-0000-0000-000000000005', 'mcq', 'Count defensive players', '{"type": "mcq", "options": ["10", "11", "12"], "correct": 1}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000005-0000-0000-0000-000000000010', '10000005-0000-0000-0000-000000000010', 1, 'How many defensive players are on the field at once?', '["10", "11", "12"]'::jsonb, '{"index": 1}'::jsonb, 'There are always 11 defensive players on the field, matching the 11 offensive players. Both teams must have exactly 11 players.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 11
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000005-0000-0000-0000-000000000011', '00000001-0000-0000-0000-000000000005', 'mcq', 'Understand secondary', '{"type": "mcq", "options": ["The offensive line", "The defensive backs (CBs and safeties)", "The backup players"], "correct": 1}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000005-0000-0000-0000-000000000011', '10000005-0000-0000-0000-000000000011', 1, 'What is the ''secondary'' in football?', '["The offensive line", "The defensive backs (CBs and safeties)", "The backup players"]'::jsonb, '{"index": 1}'::jsonb, 'The secondary refers to the defensive backs - cornerbacks and safeties. They''re called the secondary because they''re the second level of defense behind the line and linebackers.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;

-- Lesson 6: The Field & Yard Lines
INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, created_at, updated_at)
VALUES ('00000001-0000-0000-0000-000000000006', '11111111-1111-1111-1111-111111111111', 'The Field & Yard Lines', 'Understand the football field layout and how to read yard lines', 6, 4, 80, true, now(), now())
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, est_minutes = EXCLUDED.est_minutes;
  -- Item 1
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000006-0000-0000-0000-000000000001', '00000001-0000-0000-0000-000000000006', 'mcq', 'Field length', '{"type": "mcq", "options": ["100 yards", "120 yards", "50 yards"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000006-0000-0000-0000-000000000001', '10000006-0000-0000-0000-000000000001', 1, 'How long is a football field from end zone to end zone?', '["100 yards", "120 yards", "50 yards"]'::jsonb, '{"index": 0}'::jsonb, 'The playing field is 100 yards long (not counting the end zones).', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 2
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000006-0000-0000-0000-000000000002', '00000001-0000-0000-0000-000000000006', 'mcq', 'Understand total field length', '{"type": "mcq", "options": ["120 yards", "100 yards", "110 yards"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000006-0000-0000-0000-000000000002', '10000006-0000-0000-0000-000000000002', 1, 'Including the two 10-yard end zones, what is the total length of the field?', '["120 yards", "100 yards", "110 yards"]'::jsonb, '{"index": 0}'::jsonb, 'The 100-yard playing field plus two 10-yard end zones equals a total length of 120 yards.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 3
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000006-0000-0000-0000-000000000003', '00000001-0000-0000-0000-000000000006', 'mcq', 'Understand 50-yard line', '{"type": "mcq", "options": ["It''s where teams score", "It''s the middle of the field", "It''s where the game starts"], "correct": 1}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000006-0000-0000-0000-000000000003', '10000006-0000-0000-0000-000000000003', 1, 'What is special about the 50-yard line?', '["It''s where teams score", "It''s the middle of the field", "It''s where the game starts"]'::jsonb, '{"index": 1}'::jsonb, 'The 50-yard line is exactly in the middle of the field, 50 yards from each end zone. It''s also called midfield.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 4
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000006-0000-0000-0000-000000000004', '00000001-0000-0000-0000-000000000006', 'mcq', 'Read yard lines', '{"type": "mcq", "options": ["25 yards", "75 yards", "50 yards"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000006-0000-0000-0000-000000000004', '10000006-0000-0000-0000-000000000004', 1, 'The ball is at the 25-yard line. How far is it from the nearest end zone?', '["25 yards", "75 yards", "50 yards"]'::jsonb, '{"index": 0}'::jsonb, 'Yard lines show the distance to the nearest end zone. At the 25-yard line, the ball is 25 yards away from scoring a touchdown.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 5
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000006-0000-0000-0000-000000000005', '00000001-0000-0000-0000-000000000006', 'mcq', 'Understand goal line', '{"type": "mcq", "options": ["Goal line", "End line", "Touchdown line"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000006-0000-0000-0000-000000000005', '10000006-0000-0000-0000-000000000005', 1, 'What is the line that separates the field from the end zone called?', '["Goal line", "End line", "Touchdown line"]'::jsonb, '{"index": 0}'::jsonb, 'The goal line is the line at the front of each end zone. When the ball crosses this line, it''s a touchdown!', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 6
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000006-0000-0000-0000-000000000006', '00000001-0000-0000-0000-000000000006', 'mcq', 'Understand line of scrimmage', '{"type": "mcq", "options": ["Line of scrimmage", "Goal line", "First down line"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000006-0000-0000-0000-000000000006', '10000006-0000-0000-0000-000000000006', 1, 'What is the imaginary line where the ball is placed before each play called?', '["Line of scrimmage", "Goal line", "First down line"]'::jsonb, '{"index": 0}'::jsonb, 'The line of scrimmage is where the ball is spotted. Both teams line up on either side of it, and the play starts when the ball is snapped.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 7
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000006-0000-0000-0000-000000000007', '00000001-0000-0000-0000-000000000006', 'mcq', 'Understand hash marks', '{"type": "mcq", "options": ["Hash marks", "Goal lines", "Sidelines"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000006-0000-0000-0000-000000000007', '10000006-0000-0000-0000-000000000007', 1, 'What are the short lines running down the field between the yard lines?', '["Hash marks", "Goal lines", "Sidelines"]'::jsonb, '{"index": 0}'::jsonb, 'Hash marks are the small lines that run down the field. The ball is always placed on or between the hash marks, never too close to the sidelines.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 8
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000006-0000-0000-0000-000000000008', '00000001-0000-0000-0000-000000000006', 'mcq', 'Understand red zone', '{"type": "mcq", "options": ["Red zone", "End zone", "Danger zone"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000006-0000-0000-0000-000000000008', '10000006-0000-0000-0000-000000000008', 1, 'What is the area inside the opponent''s 20-yard line called?', '["Red zone", "End zone", "Danger zone"]'::jsonb, '{"index": 0}'::jsonb, 'The red zone is the area from the 20-yard line to the goal line.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 9
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000006-0000-0000-0000-000000000009', '00000001-0000-0000-0000-000000000006', 'mcq', 'Understand red zone difficulty', '{"type": "mcq", "options": ["There is less vertical space, so the defense is more condensed", "The offense gets tired", "The ball gets slippery"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000006-0000-0000-0000-000000000009', '10000006-0000-0000-0000-000000000009', 1, 'Why does it get harder to pass the ball in the Red Zone?', '["There is less vertical space, so the defense is more condensed", "The offense gets tired", "The ball gets slippery"]'::jsonb, '{"index": 0}'::jsonb, 'As the offense gets closer to the end zone, the field ''shrinks''. The defense doesn''t have to defend deep passes, so they can pack players closer together.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 10
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000006-0000-0000-0000-000000000010', '00000001-0000-0000-0000-000000000006', 'mcq', 'Understand sidelines', '{"type": "mcq", "options": ["The play continues", "The play is over and the clock stops", "It''s a penalty"], "correct": 1}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000006-0000-0000-0000-000000000010', '10000006-0000-0000-0000-000000000010', 1, 'What happens when a player with the ball steps on or crosses the sideline?', '["The play continues", "The play is over and the clock stops", "It''s a penalty"]'::jsonb, '{"index": 1}'::jsonb, 'When a player goes out of bounds (crosses the sideline), the play ends immediately and the clock stops. The ball is placed where they went out.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;

-- Lesson 7: Game Clock & Quarters
INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, created_at, updated_at)
VALUES ('00000001-0000-0000-0000-000000000007', '11111111-1111-1111-1111-111111111111', 'Game Clock & Quarters', 'Learn how time works in football games', 7, 4, 80, true, now(), now())
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, est_minutes = EXCLUDED.est_minutes;
  -- Item 1
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000007-0000-0000-0000-000000000001', '00000001-0000-0000-0000-000000000007', 'mcq', 'Number of quarters', '{"type": "mcq", "options": ["2", "3", "4"], "correct": 2}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000007-0000-0000-0000-000000000001', '10000007-0000-0000-0000-000000000001', 1, 'How many quarters are in a football game?', '["2", "3", "4"]'::jsonb, '{"index": 2}'::jsonb, 'A football game has 4 quarters. Each quarter is 15 minutes long.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 2
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000007-0000-0000-0000-000000000002', '00000001-0000-0000-0000-000000000007', 'mcq', 'Understand total game time', '{"type": "mcq", "options": ["60 minutes", "90 minutes", "45 minutes"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000007-0000-0000-0000-000000000002', '10000007-0000-0000-0000-000000000002', 1, 'What is the total game time (excluding halftime and stoppages)?', '["60 minutes", "90 minutes", "45 minutes"]'::jsonb, '{"index": 0}'::jsonb, 'With four 15-minute quarters, the total regulation game time is 60 minutes.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 3
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000007-0000-0000-0000-000000000003', '00000001-0000-0000-0000-000000000007', 'mcq', 'Quarter length', '{"type": "mcq", "options": ["10 minutes", "12 minutes", "15 minutes"], "correct": 2}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000007-0000-0000-0000-000000000003', '10000007-0000-0000-0000-000000000003', 1, 'How long is each quarter in an NFL game?', '["10 minutes", "12 minutes", "15 minutes"]'::jsonb, '{"index": 2}'::jsonb, 'Each quarter is 15 minutes long in the NFL. College and high school games may have different quarter lengths.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 4
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000007-0000-0000-0000-000000000004', '00000001-0000-0000-0000-000000000007', 'mcq', 'Understand halftime', '{"type": "mcq", "options": ["The game ends", "Halftime break", "Overtime"], "correct": 1}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000007-0000-0000-0000-000000000004', '10000007-0000-0000-0000-000000000004', 1, 'What happens between the 2nd and 3rd quarters?', '["The game ends", "Halftime break", "Overtime"]'::jsonb, '{"index": 1}'::jsonb, 'Halftime is a break between the 2nd and 3rd quarters.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 5
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000007-0000-0000-0000-000000000005', '00000001-0000-0000-0000-000000000007', 'mcq', 'Understand halftime strategy', '{"type": "mcq", "options": ["Rest and adjust their game plan", "Practice on the field", "Go home"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000007-0000-0000-0000-000000000005', '10000007-0000-0000-0000-000000000005', 1, 'What do teams typically do during halftime?', '["Rest and adjust their game plan", "Practice on the field", "Go home"]'::jsonb, '{"index": 0}'::jsonb, 'Halftime is crucial for coaches to make adjustments based on what happened in the first half. Players also rest and hydrate.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 6
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000007-0000-0000-0000-000000000006', '00000001-0000-0000-0000-000000000007', 'mcq', 'Clock stops', '{"type": "mcq", "options": ["After every play", "When a player goes out of bounds or a pass is incomplete", "Never"], "correct": 1}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000007-0000-0000-0000-000000000006', '10000007-0000-0000-0000-000000000006', 1, 'When does the game clock stop?', '["After every play", "When a player goes out of bounds or a pass is incomplete", "Never"]'::jsonb, '{"index": 1}'::jsonb, 'The clock stops when a player goes out of bounds, a pass is incomplete, there''s a penalty, or a timeout is called.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 7
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000007-0000-0000-0000-000000000007', '00000001-0000-0000-0000-000000000007', 'mcq', 'Understand running clock', '{"type": "mcq", "options": ["No, it keeps running", "Yes, always", "Only in the 4th quarter"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000007-0000-0000-0000-000000000007', '10000007-0000-0000-0000-000000000007', 1, 'Does the clock stop after a player is tackled in bounds?', '["No, it keeps running", "Yes, always", "Only in the 4th quarter"]'::jsonb, '{"index": 0}'::jsonb, 'If a player is tackled in bounds, the clock keeps running (except for some specific situations near the end of the game). The offense must hurry to the line.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 8
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000007-0000-0000-0000-000000000008', '00000001-0000-0000-0000-000000000007', 'mcq', 'Understand timeout', '{"type": "mcq", "options": ["Timeout", "Halftime", "Quarter break"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000007-0000-0000-0000-000000000008', '10000007-0000-0000-0000-000000000008', 1, 'What can teams call to stop the clock and discuss strategy?', '["Timeout", "Halftime", "Quarter break"]'::jsonb, '{"index": 0}'::jsonb, 'Teams can call timeouts to stop the clock and discuss plays. Each team gets 3 timeouts per half.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 9
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000007-0000-0000-0000-000000000009', '00000001-0000-0000-0000-000000000007', 'mcq', 'Understand two-minute warning', '{"type": "mcq", "options": ["A penalty", "An automatic timeout when 2 minutes remain in each half", "A warning about bad weather"], "correct": 1}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000007-0000-0000-0000-000000000009', '10000007-0000-0000-0000-000000000009', 1, 'What is the ''two-minute warning''?', '["A penalty", "An automatic timeout when 2 minutes remain in each half", "A warning about bad weather"]'::jsonb, '{"index": 1}'::jsonb, 'The two-minute warning is an automatic timeout that occurs when 2 minutes remain in the 2nd and 4th quarters.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 10
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000007-0000-0000-0000-000000000010', '00000001-0000-0000-0000-000000000007', 'mcq', 'Understand two-minute warning timing', '{"type": "mcq", "options": ["At the end of the 2nd and 4th quarters", "At the end of every quarter", "Only at the end of the game"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000007-0000-0000-0000-000000000010', '10000007-0000-0000-0000-000000000010', 1, 'When does the two-minute warning happen?', '["At the end of the 2nd and 4th quarters", "At the end of every quarter", "Only at the end of the game"]'::jsonb, '{"index": 0}'::jsonb, 'It happens twice a game: with 2 minutes left in the first half (2nd quarter) and 2 minutes left in the game (4th quarter).', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 11
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000007-0000-0000-0000-000000000011', '00000001-0000-0000-0000-000000000007', 'mcq', 'Understand overtime', '{"type": "mcq", "options": ["The game ends in a tie", "Overtime period", "They replay the 4th quarter"], "correct": 1}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000007-0000-0000-0000-000000000011', '10000007-0000-0000-0000-000000000011', 1, 'What happens if the score is tied at the end of the 4th quarter?', '["The game ends in a tie", "Overtime period", "They replay the 4th quarter"]'::jsonb, '{"index": 1}'::jsonb, 'If the score is tied, the game goes to overtime. In the NFL, overtime is sudden death (first team to score wins) with some special rules.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 12
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000007-0000-0000-0000-000000000012', '00000001-0000-0000-0000-000000000007', 'mcq', 'Play clock', '{"type": "mcq", "options": ["25 seconds", "40 seconds", "60 seconds"], "correct": 1}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000007-0000-0000-0000-000000000012', '10000007-0000-0000-0000-000000000012', 1, 'How long does the offense have to snap the ball after the previous play ends?', '["25 seconds", "40 seconds", "60 seconds"]'::jsonb, '{"index": 1}'::jsonb, 'The play clock gives the offense 40 seconds (sometimes 25) to snap the ball. If they don''t snap in time, it''s a delay of game penalty.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;

-- Lesson 8: Common Penalties
INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, created_at, updated_at)
VALUES ('00000001-0000-0000-0000-000000000008', '11111111-1111-1111-1111-111111111111', 'Common Penalties', 'Learn the most common penalties and what they mean', 8, 5, 80, true, now(), now())
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, est_minutes = EXCLUDED.est_minutes;
  -- Item 1
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000008-0000-0000-0000-000000000001', '00000001-0000-0000-0000-000000000008', 'mcq', 'Understand penalty', '{"type": "mcq", "options": ["They lose points", "They lose yards", "The game ends"], "correct": 1}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000008-0000-0000-0000-000000000001', '10000008-0000-0000-0000-000000000001', 1, 'What happens when a team commits a penalty?', '["They lose points", "They lose yards", "The game ends"]'::jsonb, '{"index": 1}'::jsonb, 'When a team commits a penalty, they usually lose yards.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 2
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000008-0000-0000-0000-000000000002', '00000001-0000-0000-0000-000000000008', 'mcq', 'Understand penalty result', '{"type": "mcq", "options": ["The offending team moves back a certain number of yards", "The offending team loses a point", "The player is ejected"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000008-0000-0000-0000-000000000002', '10000008-0000-0000-0000-000000000002', 1, 'What is the most common result of a penalty?', '["The offending team moves back a certain number of yards", "The offending team loses a point", "The player is ejected"]'::jsonb, '{"index": 0}'::jsonb, 'Most penalties result in a 5, 10, or 15-yard loss for the team that committed the foul.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 3
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000008-0000-0000-0000-000000000003', '00000001-0000-0000-0000-000000000008', 'mcq', 'False start', '{"type": "mcq", "options": ["Offsides", "False start", "Holding"], "correct": 1}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000008-0000-0000-0000-000000000003', '10000008-0000-0000-0000-000000000003', 1, 'What is it called when an offensive player moves before the snap?', '["Offsides", "False start", "Holding"]'::jsonb, '{"index": 1}'::jsonb, 'A false start is when an offensive player (except the QB) moves before the snap.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 4
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000008-0000-0000-0000-000000000004', '00000001-0000-0000-0000-000000000008', 'mcq', 'Understand false start penalty', '{"type": "mcq", "options": ["5 yards", "10 yards", "15 yards"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000008-0000-0000-0000-000000000004', '10000008-0000-0000-0000-000000000004', 1, 'How many yards is the penalty for a false start?', '["5 yards", "10 yards", "15 yards"]'::jsonb, '{"index": 0}'::jsonb, 'A false start costs the offense 5 yards. It''s a ''dead ball'' foul, meaning the play is blown dead immediately.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 5
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000008-0000-0000-0000-000000000005', '00000001-0000-0000-0000-000000000008', 'mcq', 'Offsides', '{"type": "mcq", "options": ["False start", "Offsides", "Holding"], "correct": 1}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000008-0000-0000-0000-000000000005', '10000008-0000-0000-0000-000000000005', 1, 'What is it called when a defensive player crosses the line of scrimmage before the snap?', '["False start", "Offsides", "Holding"]'::jsonb, '{"index": 1}'::jsonb, 'Offsides is when a defensive player is on the wrong side of the line of scrimmage when the ball is snapped. It''s a 5-yard penalty for the defense.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 6
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000008-0000-0000-0000-000000000006', '00000001-0000-0000-0000-000000000008', 'mcq', 'Holding penalty', '{"type": "mcq", "options": ["Catching the ball", "Illegally grabbing or restraining an opponent", "Keeping possession of the ball"], "correct": 1}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000008-0000-0000-0000-000000000006', '10000008-0000-0000-0000-000000000006', 1, 'What is holding?', '["Catching the ball", "Illegally grabbing or restraining an opponent", "Keeping possession of the ball"]'::jsonb, '{"index": 1}'::jsonb, 'Holding is when a player illegally grabs, hooks, or tackles an opponent who doesn''t have the ball. It''s a 10-yard penalty.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 7
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000008-0000-0000-0000-000000000007', '00000001-0000-0000-0000-000000000008', 'mcq', 'Pass interference', '{"type": "mcq", "options": ["Holding", "Pass interference", "Offsides"], "correct": 1}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000008-0000-0000-0000-000000000007', '10000008-0000-0000-0000-000000000007', 1, 'What is it called when a defender illegally prevents a receiver from catching a pass?', '["Holding", "Pass interference", "Offsides"]'::jsonb, '{"index": 1}'::jsonb, 'Pass interference is when a defender makes illegal contact with a receiver trying to catch a pass.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 8
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000008-0000-0000-0000-000000000008', '00000001-0000-0000-0000-000000000008', 'mcq', 'Understand PI penalty', '{"type": "mcq", "options": ["The offense gets the ball at the spot of the foul", "15 yards", "5 yards"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000008-0000-0000-0000-000000000008', '10000008-0000-0000-0000-000000000008', 1, 'What is the penalty for defensive pass interference in the NFL?', '["The offense gets the ball at the spot of the foul", "15 yards", "5 yards"]'::jsonb, '{"index": 0}'::jsonb, 'In the NFL, defensive PI is a ''spot foul''. The offense gets the ball right where the foul happened, which can be a huge gain!', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 9
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000008-0000-0000-0000-000000000009', '00000001-0000-0000-0000-000000000008', 'mcq', 'Understand yellow flag', '{"type": "mcq", "options": ["Touchdown", "Penalty", "Timeout"], "correct": 1}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000008-0000-0000-0000-000000000009', '10000008-0000-0000-0000-000000000009', 1, 'What does it mean when a referee throws a yellow flag?', '["Touchdown", "Penalty", "Timeout"]'::jsonb, '{"index": 1}'::jsonb, 'A yellow flag thrown by a referee indicates a penalty. The referee will announce what the penalty is and which team committed it.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 10
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000008-0000-0000-0000-000000000010', '00000001-0000-0000-0000-000000000008', 'mcq', 'Delay of game', '{"type": "mcq", "options": ["False start", "Delay of game", "Offsides"], "correct": 1}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000008-0000-0000-0000-000000000010', '10000008-0000-0000-0000-000000000010', 1, 'What penalty occurs when the offense doesn''t snap the ball before the play clock expires?', '["False start", "Delay of game", "Offsides"]'::jsonb, '{"index": 1}'::jsonb, 'Delay of game is a 5-yard penalty when the offense doesn''t snap the ball in time.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 11
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000008-0000-0000-0000-000000000011', '00000001-0000-0000-0000-000000000008', 'mcq', 'Understand delay of game trigger', '{"type": "mcq", "options": ["Delay of game penalty", "The play starts automatically", "Timeout is called automatically"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000008-0000-0000-0000-000000000011', '10000008-0000-0000-0000-000000000011', 1, 'What happens if the play clock hits zero before the snap?', '["Delay of game penalty", "The play starts automatically", "Timeout is called automatically"]'::jsonb, '{"index": 0}'::jsonb, 'If the play clock expires, the referee blows the whistle and calls a delay of game penalty on the offense.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 12
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000008-0000-0000-0000-000000000012', '00000001-0000-0000-0000-000000000008', 'mcq', 'Penalty acceptance', '{"type": "mcq", "options": ["The referees", "The team that didn''t commit the penalty", "Both teams vote"], "correct": 1}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000008-0000-0000-0000-000000000012', '10000008-0000-0000-0000-000000000012', 1, 'After a penalty, who decides whether to accept or decline it?', '["The referees", "The team that didn''t commit the penalty", "Both teams vote"]'::jsonb, '{"index": 1}'::jsonb, 'The team that didn''t commit the penalty can choose to accept it (take the yards) or decline it (let the play stand). They choose whichever helps them more.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;

-- Lesson 9: Kickoffs & Returns
INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, created_at, updated_at)
VALUES ('00000001-0000-0000-0000-000000000009', '11111111-1111-1111-1111-111111111111', 'Kickoffs & Returns', 'Learn how games and halves start with kickoffs', 9, 4, 80, true, now(), now())
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, est_minutes = EXCLUDED.est_minutes;
  -- Item 1
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000009-0000-0000-0000-000000000001', '00000001-0000-0000-0000-000000000009', 'mcq', 'Understand kickoff', '{"type": "mcq", "options": ["With a kickoff", "With a coin toss", "With a touchdown"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000009-0000-0000-0000-000000000001', '10000009-0000-0000-0000-000000000001', 1, 'How does a football game start?', '["With a kickoff", "With a coin toss", "With a touchdown"]'::jsonb, '{"index": 0}'::jsonb, 'The game starts with a kickoff. One team kicks the ball to the other team, who tries to catch it and run it back up the field.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 2
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000009-0000-0000-0000-000000000002', '00000001-0000-0000-0000-000000000009', 'mcq', 'Coin toss', '{"type": "mcq", "options": ["Coin toss", "The home team always kicks", "The visiting team always kicks"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000009-0000-0000-0000-000000000002', '10000009-0000-0000-0000-000000000002', 1, 'What determines which team kicks off first?', '["Coin toss", "The home team always kicks", "The visiting team always kicks"]'::jsonb, '{"index": 0}'::jsonb, 'Before the game, there''s a coin toss. The team that wins can choose to kick off, receive the kickoff, or pick which end zone to defend.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 3
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000009-0000-0000-0000-000000000003', '00000001-0000-0000-0000-000000000009', 'mcq', 'Kickoff return', '{"type": "mcq", "options": ["Run it back toward the opponent''s end zone", "Kick it back", "Throw it"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000009-0000-0000-0000-000000000003', '10000009-0000-0000-0000-000000000003', 1, 'What should the receiving team do after catching a kickoff?', '["Run it back toward the opponent''s end zone", "Kick it back", "Throw it"]'::jsonb, '{"index": 0}'::jsonb, 'After catching a kickoff, the receiving team''s returner runs toward the opponent''s end zone to gain as many yards as possible before being tackled.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 4
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000009-0000-0000-0000-000000000004', '00000001-0000-0000-0000-000000000009', 'mcq', 'Touchback', '{"type": "mcq", "options": ["When the ball goes into the end zone and isn''t returned", "When the kicker scores", "When there''s a penalty"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000009-0000-0000-0000-000000000004', '10000009-0000-0000-0000-000000000004', 1, 'What is a touchback on a kickoff?', '["When the ball goes into the end zone and isn''t returned", "When the kicker scores", "When there''s a penalty"]'::jsonb, '{"index": 0}'::jsonb, 'A touchback occurs when the kickoff goes into the end zone and the returner kneels or doesn''t return it.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 5
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000009-0000-0000-0000-000000000005', '00000001-0000-0000-0000-000000000009', 'mcq', 'Understand touchback placement', '{"type": "mcq", "options": ["25-yard line", "20-yard line", "Goal line"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000009-0000-0000-0000-000000000005', '10000009-0000-0000-0000-000000000005', 1, 'Where does the offense start after a touchback on a kickoff?', '["25-yard line", "20-yard line", "Goal line"]'::jsonb, '{"index": 0}'::jsonb, 'After a touchback on a kickoff, the ball is placed at the 25-yard line. This is a safe starting point for the offense.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 6
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000009-0000-0000-0000-000000000006', '00000001-0000-0000-0000-000000000009', 'mcq', 'When kickoffs happen', '{"type": "mcq", "options": ["Only at the start", "At the start of each half and after scores", "After every play"], "correct": 1}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000009-0000-0000-0000-000000000006', '10000009-0000-0000-0000-000000000006', 1, 'When do kickoffs occur during a game?', '["Only at the start", "At the start of each half and after scores", "After every play"]'::jsonb, '{"index": 1}'::jsonb, 'Kickoffs happen at the start of each half and after every scoring play (touchdown or field goal). The scoring team kicks off to the other team.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 7
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000009-0000-0000-0000-000000000007', '00000001-0000-0000-0000-000000000009', 'mcq', 'Onside kick', '{"type": "mcq", "options": ["A very long kick", "A short kick where the kicking team tries to recover the ball", "A kick that goes out of bounds"], "correct": 1}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000009-0000-0000-0000-000000000007', '10000009-0000-0000-0000-000000000007', 1, 'What is an onside kick?', '["A very long kick", "A short kick where the kicking team tries to recover the ball", "A kick that goes out of bounds"]'::jsonb, '{"index": 1}'::jsonb, 'An onside kick is a short, intentional kick where the kicking team tries to recover the ball themselves.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 8
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000009-0000-0000-0000-000000000008', '00000001-0000-0000-0000-000000000009', 'mcq', 'Understand onside kick risk', '{"type": "mcq", "options": ["If it fails, the other team gets the ball with great field position", "It''s illegal in the first half", "The kicker might get hurt"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000009-0000-0000-0000-000000000008', '10000009-0000-0000-0000-000000000008', 1, 'Why is an onside kick risky?', '["If it fails, the other team gets the ball with great field position", "It''s illegal in the first half", "The kicker might get hurt"]'::jsonb, '{"index": 0}'::jsonb, 'Because the kick must be short (10 yards), if the kicking team doesn''t recover it, the receiving team gets the ball very close to the end zone.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 9
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000009-0000-0000-0000-000000000009', '00000001-0000-0000-0000-000000000009', 'mcq', 'Fair catch', '{"type": "mcq", "options": ["They''re calling for a timeout", "They''re signaling a fair catch - they can''t be tackled", "They''re waving to the crowd"], "correct": 1}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000009-0000-0000-0000-000000000009', '10000009-0000-0000-0000-000000000009', 1, 'What does it mean when a returner waves their arm before catching a kickoff or punt?', '["They''re calling for a timeout", "They''re signaling a fair catch - they can''t be tackled", "They''re waving to the crowd"]'::jsonb, '{"index": 1}'::jsonb, 'A fair catch signal (waving arm) means the returner won''t be tackled, but they also can''t run with the ball. The play starts where they catch it.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 10
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000009-0000-0000-0000-000000000010', '00000001-0000-0000-0000-000000000009', 'mcq', 'Kickoff out of bounds', '{"type": "mcq", "options": ["The kicking team gets a penalty", "The receiving team gets the ball at the 40-yard line", "Both A and B"], "correct": 2}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000009-0000-0000-0000-000000000010', '10000009-0000-0000-0000-000000000010', 1, 'What happens if a kickoff goes out of bounds without being touched?', '["The kicking team gets a penalty", "The receiving team gets the ball at the 40-yard line", "Both A and B"]'::jsonb, '{"index": 2}'::jsonb, 'If a kickoff goes out of bounds untouched, it''s a penalty. The receiving team usually gets the ball at their own 40-yard line, giving them good field position.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;

-- Lesson 10: Fumbles & Turnovers
INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, created_at, updated_at)
VALUES ('00000001-0000-0000-0000-000000000010', '11111111-1111-1111-1111-111111111111', 'Fumbles & Turnovers', 'Learn how possession can change during a play', 10, 4, 80, true, now(), now())
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, est_minutes = EXCLUDED.est_minutes;
  -- Item 1
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000010-0000-0000-0000-000000000001', '00000001-0000-0000-0000-000000000010', 'mcq', 'Understand fumble', '{"type": "mcq", "options": ["A bad pass", "When a player drops or loses the ball", "A type of penalty"], "correct": 1}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000010-0000-0000-0000-000000000001', '10000010-0000-0000-0000-000000000001', 1, 'What is a fumble?', '["A bad pass", "When a player drops or loses the ball", "A type of penalty"]'::jsonb, '{"index": 1}'::jsonb, 'A fumble is when a player who has possession of the ball drops it or has it knocked out before being tackled. The ball is live and either team can recover it.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 2
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000010-0000-0000-0000-000000000002', '00000001-0000-0000-0000-000000000010', 'mcq', 'Fumble recovery', '{"type": "mcq", "options": ["The play is over", "The defense gets possession", "It''s a penalty"], "correct": 1}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000010-0000-0000-0000-000000000002', '10000010-0000-0000-0000-000000000002', 1, 'What happens if the defense recovers a fumble?', '["The play is over", "The defense gets possession", "It''s a penalty"]'::jsonb, '{"index": 1}'::jsonb, 'If the defense recovers a fumble, they get possession of the ball! They can even run it back for a touchdown. This is called a turnover.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 3
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000010-0000-0000-0000-000000000003', '00000001-0000-0000-0000-000000000010', 'mcq', 'Understand turnover', '{"type": "mcq", "options": ["When possession changes from one team to the other", "When a player turns around", "A type of penalty"], "correct": 0}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000010-0000-0000-0000-000000000003', '10000010-0000-0000-0000-000000000003', 1, 'What is a turnover?', '["When possession changes from one team to the other", "When a player turns around", "A type of penalty"]'::jsonb, '{"index": 0}'::jsonb, 'A turnover is when possession changes from one team to the other during a play. Fumbles and interceptions are the two main types of turnovers.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 4
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000010-0000-0000-0000-000000000004', '00000001-0000-0000-0000-000000000010', 'mcq', 'Interception return', '{"type": "mcq", "options": ["No, the play is immediately over", "Yes, they can run it back for a touchdown", "Only if they''re a linebacker"], "correct": 1}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000010-0000-0000-0000-000000000004', '10000010-0000-0000-0000-000000000004', 1, 'Can a defensive player who intercepts a pass run with the ball?', '["No, the play is immediately over", "Yes, they can run it back for a touchdown", "Only if they''re a linebacker"]'::jsonb, '{"index": 1}'::jsonb, 'Yes! After an interception, the defensive player can run with the ball toward the opponent''s end zone.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 5
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000010-0000-0000-0000-000000000005', '00000001-0000-0000-0000-000000000010', 'mcq', 'Understand pick-six', '{"type": "mcq", "options": ["An interception returned for a touchdown", "Intercepting 6 passes in a game", "A 6-yard interception return"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000010-0000-0000-0000-000000000005', '10000010-0000-0000-0000-000000000005', 1, 'What is a ''pick-six''?', '["An interception returned for a touchdown", "Intercepting 6 passes in a game", "A 6-yard interception return"]'::jsonb, '{"index": 0}'::jsonb, 'A ''pick-six'' is slang for an interception (''pick'') that is returned for a touchdown (6 points).', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 6
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000010-0000-0000-0000-000000000006', '00000001-0000-0000-0000-000000000010', 'mcq', 'Fumble out of bounds', '{"type": "mcq", "options": ["The defense gets it", "The team that last touched it keeps possession", "It''s a penalty"], "correct": 1}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000010-0000-0000-0000-000000000006', '10000010-0000-0000-0000-000000000006', 1, 'What happens if a fumbled ball goes out of bounds?', '["The defense gets it", "The team that last touched it keeps possession", "It''s a penalty"]'::jsonb, '{"index": 1}'::jsonb, 'If a fumble goes out of bounds, the team that last had possession before it went out keeps the ball. It''s spotted where it went out of bounds.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 7
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000010-0000-0000-0000-000000000007', '00000001-0000-0000-0000-000000000010', 'mcq', 'Forced fumble', '{"type": "mcq", "options": ["Forced fumble", "Strip sack", "Tackle"], "correct": 0}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000010-0000-0000-0000-000000000007', '10000010-0000-0000-0000-000000000007', 1, 'What is it called when a defensive player causes an offensive player to fumble?', '["Forced fumble", "Strip sack", "Tackle"]'::jsonb, '{"index": 0}'::jsonb, 'A forced fumble is when a defender knocks or strips the ball out of an offensive player''s hands. It''s a great defensive play that can lead to a turnover.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 8
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000010-0000-0000-0000-000000000008', '00000001-0000-0000-0000-000000000010', 'mcq', 'Fumble vs incomplete pass', '{"type": "mcq", "options": ["Always a fumble", "Always incomplete", "It depends on if his arm was moving forward"], "correct": 2}'::jsonb, 2, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000010-0000-0000-0000-000000000008', '10000010-0000-0000-0000-000000000008', 1, 'If a QB drops the ball while trying to throw, is it a fumble or incomplete pass?', '["Always a fumble", "Always incomplete", "It depends on if his arm was moving forward"]'::jsonb, '{"index": 2}'::jsonb, 'If the QB''s arm was moving forward when he lost the ball, it''s an incomplete pass. If his arm wasn''t moving forward, it''s a fumble.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 9
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000010-0000-0000-0000-000000000009', '00000001-0000-0000-0000-000000000010', 'mcq', 'Understand tuck rule concept', '{"type": "mcq", "options": ["Forward arm motion", "Where the ball lands", "If the receiver was open"], "correct": 0}'::jsonb, 3, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000010-0000-0000-0000-000000000009', '10000010-0000-0000-0000-000000000009', 1, 'What determines if a dropped ball during a throw is a fumble or incomplete pass?', '["Forward arm motion", "Where the ball lands", "If the receiver was open"]'::jsonb, '{"index": 0}'::jsonb, 'The key is whether the QB''s arm was moving forward in a passing motion. Even if he loses grip, forward motion makes it an incomplete pass, not a fumble.', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;
  -- Item 10
  INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
  VALUES ('10000010-0000-0000-0000-000000000010', '00000001-0000-0000-0000-000000000010', 'mcq', 'Turnover importance', '{"type": "mcq", "options": ["They''re worth extra points", "They give the other team possession and momentum", "They stop the clock"], "correct": 1}'::jsonb, 1, 'live', (SELECT id FROM users LIMIT 1), now(), now())
  ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt, answer_schema_json = EXCLUDED.answer_schema_json, difficulty = EXCLUDED.difficulty, status = EXCLUDED.status;
  INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
  VALUES ('20000010-0000-0000-0000-000000000010', '10000010-0000-0000-0000-000000000010', 1, 'Why are turnovers important in football?', '["They''re worth extra points", "They give the other team possession and momentum", "They stop the clock"]'::jsonb, '{"index": 1}'::jsonb, 'Turnovers are huge because they give possession to the other team, often in good field position. They can completely change the momentum of a game!', true, now(), now())
  ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, explanation_richtext = EXCLUDED.explanation_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json, active = EXCLUDED.active;

