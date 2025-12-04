-- ============================================================================
-- Rookie Final Test - Seed Data
-- ============================================================================
-- This test comes at the END of the Rookie section
-- Contains 20 questions covering ALL Rookie lessons (GB1-ST2)
-- Comprehensive review of everything learned
--
-- ORDER: 27 (final item in Rookie section)
-- Type: Test (end of section)
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
-- STEP 4: Create Rookie Final Test (ORDER: 27)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000001-0000-0000-0000-000000000027',
    '11111111-1111-1111-1111-111111111111',
    'Rookie Final Test',
    'Prove your mastery of football basics! This comprehensive test covers everything you''ve learned.',
    27,
    10,
    150,
    true,
    'TEST1',
    20,
    1
)
ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    code = EXCLUDED.code,
    order_index = EXCLUDED.order_index,
    items_per_session = EXCLUDED.items_per_session,
    required_completions = EXCLUDED.required_completions;


-- ============================================================================
-- STEP 5: Create Test Items (20 questions from all Rookie lessons)
-- ============================================================================

-- Q1: Basic objective (GB1)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000001',
    '00000001-0000-0000-0000-000000000027',
    'mcq',
    'What is the main objective of the offense in football?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000001',
    '00000027-0001-0000-0000-000000000001',
    1,
    'What is the main objective of the offense in football?',
    '["To stop the other team from scoring", "To move the ball into the opponent''s end zone and score", "To kick the ball as far as possible", "To defend their own end zone"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q2: Field dimensions (TF1)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000002',
    '00000001-0000-0000-0000-000000000027',
    'mcq',
    'What is in the middle of the football field?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000002',
    '00000027-0001-0000-0000-000000000002',
    1,
    'What is in the middle of the football field?',
    '["The 50-yard line", "The end zone", "The goal post", "The sideline"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q3: Touchdown points (SC1)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000003',
    '00000001-0000-0000-0000-000000000027',
    'mcq',
    'How many points is a touchdown worth?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000003',
    '00000027-0001-0000-0000-000000000003',
    1,
    'How many points is a touchdown worth?',
    '["3 points", "5 points", "6 points", "7 points"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q4: Downs system (DS1)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000004',
    '00000001-0000-0000-0000-000000000027',
    'mcq',
    'How many yards must the offense gain to get a new set of downs?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000004',
    '00000027-0001-0000-0000-000000000004',
    1,
    'How many yards must the offense gain to get a new set of downs?',
    '["5 yards", "10 yards", "15 yards", "20 yards"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q5: Field goal points (SC2)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000005',
    '00000001-0000-0000-0000-000000000027',
    'mcq',
    'How many points is a field goal worth?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000005',
    '00000027-0001-0000-0000-000000000005',
    1,
    'How many points is a field goal worth?',
    '["1 point", "3 points", "6 points", "7 points"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q6: Quarterback role (OP1)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000006',
    '00000001-0000-0000-0000-000000000027',
    'mcq',
    'What position throws passes and hands off the ball to start plays?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000006',
    '00000027-0001-0000-0000-000000000006',
    1,
    'What position throws passes and hands off the ball to start plays?',
    '["Quarterback", "Running Back", "Wide Receiver", "Linebacker"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q7: Wide receiver role (OP2)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000007',
    '00000001-0000-0000-0000-000000000027',
    'mcq',
    'What position runs routes down the field to catch passes?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000007',
    '00000027-0001-0000-0000-000000000007',
    1,
    'What position runs routes down the field to catch passes?',
    '["Quarterback", "Running Back", "Wide Receiver", "Defensive Lineman"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q8: Cornerback role (DP2)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000008',
    '00000001-0000-0000-0000-000000000027',
    'mcq',
    'What defensive position covers wide receivers?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000008',
    '00000027-0001-0000-0000-000000000008',
    1,
    'What defensive position covers wide receivers?',
    '["Linebacker", "Cornerback", "Defensive Lineman", "Running Back"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q9: Interception (TO1)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000009',
    '00000001-0000-0000-0000-000000000027',
    'mcq',
    'What is it called when a defender catches a pass meant for the offense?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000009',
    '00000027-0001-0000-0000-000000000009',
    1,
    'What is it called when a defender catches a pass meant for the offense?',
    '["Interception", "Fumble", "Touchdown", "First down"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q10: Pick-six (TO2)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000010',
    '00000001-0000-0000-0000-000000000027',
    'mcq',
    'What is a pick-six?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000010',
    '00000027-0001-0000-0000-000000000010',
    1,
    'What is a pick-six?',
    '["A fumble recovered for a touchdown", "Six interceptions in a game", "An interception returned for a touchdown", "Six field goals"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q11: False start (CP1)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000011',
    '00000001-0000-0000-0000-000000000027',
    'mcq',
    'Who commits a false start penalty?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000011',
    '00000027-0001-0000-0000-000000000011',
    1,
    'Who commits a false start penalty?',
    '["The offense (moving before the snap)", "The defense", "The kicker", "The referee"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q12: Pass interference (CP2)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000012',
    '00000001-0000-0000-0000-000000000027',
    'mcq',
    'What is pass interference?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000012',
    '00000027-0001-0000-0000-000000000012',
    1,
    'What is pass interference?',
    '["Throwing the ball too far", "Illegally preventing a player from catching a pass", "Catching the ball out of bounds", "A type of scoring play"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q13: Quarters (GS1)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000013',
    '00000001-0000-0000-0000-000000000027',
    'mcq',
    'How many quarters are in a regulation football game?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000013',
    '00000027-0001-0000-0000-000000000013',
    1,
    'How many quarters are in a regulation football game?',
    '["2", "3", "4", "5"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q14: Overtime (GS2)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000014',
    '00000001-0000-0000-0000-000000000027',
    'binary',
    'A football game goes to overtime when the score is tied at the end of the 4th quarter.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000014',
    '00000027-0001-0000-0000-000000000014',
    1,
    'A football game goes to overtime when the score is tied at the end of the 4th quarter.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q15: Kickoff (ST1)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000015',
    '00000001-0000-0000-0000-000000000027',
    'mcq',
    'When does a kickoff happen?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000015',
    '00000027-0001-0000-0000-000000000015',
    1,
    'When does a kickoff happen?',
    '["Only at halftime", "After every play", "At the start of each half and after scoring plays", "Only at the end of the game"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q16: Fair catch (ST2)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000016',
    '00000001-0000-0000-0000-000000000027',
    'binary',
    'A player who signals for a fair catch cannot be tackled after catching the ball.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000016',
    '00000027-0001-0000-0000-000000000016',
    1,
    'A player who signals for a fair catch cannot be tackled after catching the ball.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q17: Situational - scoring calculation
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000017',
    '00000001-0000-0000-0000-000000000027',
    'mcq',
    'A team scores 2 touchdowns with successful extra points and 1 field goal. How many total points?',
    '{"correct_index": 2}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000017',
    '00000027-0001-0000-0000-000000000017',
    1,
    'A team scores 2 touchdowns with successful extra points and 1 field goal. How many total points?',
    '["14 points", "15 points", "17 points", "20 points"]',
    '{"index": 2}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q18: Situational - down progression
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000018',
    '00000001-0000-0000-0000-000000000027',
    'mcq',
    'The team is on 2nd and 8. They run the ball for 3 yards. What is the new down and distance?',
    '{"correct_index": 1}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000018',
    '00000027-0001-0000-0000-000000000018',
    1,
    'The team is on 2nd and 8. They run the ball for 3 yards. What is the new down and distance?',
    '["2nd and 5", "3rd and 5", "1st and 10", "4th and 5"]',
    '{"index": 1}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q19: Line of scrimmage (TF3)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000019',
    '00000001-0000-0000-0000-000000000027',
    'binary',
    'The line of scrimmage is where the ball is placed before each play begins.',
    '{"correct_boolean": true}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000019',
    '00000027-0001-0000-0000-000000000019',
    1,
    'The line of scrimmage is where the ball is placed before each play begins.',
    '["True", "False"]',
    '{"boolean": true}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- Q20: Comprehensive situational
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
VALUES (
    '00000027-0001-0000-0000-000000000020',
    '00000001-0000-0000-0000-000000000027',
    'mcq',
    'The Pittsburgh Steelers are on 4th and 2 at their opponent''s 35-yard line. They decide not to go for the first down. What are their two options?',
    '{"correct_index": 0}',
    '00000000-0000-0000-0000-000000000000',
    'live',
    1
)
ON CONFLICT (id) DO UPDATE SET base_prompt = EXCLUDED.base_prompt;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active)
VALUES (
    '00000027-0001-0001-0000-000000000020',
    '00000027-0001-0000-0000-000000000020',
    1,
    'The Pittsburgh Steelers are on 4th and 2 at their opponent''s 35-yard line. They decide not to go for the first down. What are their two options?',
    '["Punt the ball or attempt a field goal", "Call a timeout or score a touchdown", "Throw an interception or fumble", "Start overtime or end the game"]',
    '{"index": 0}',
    '',
    true
)
ON CONFLICT (item_id, version) DO UPDATE SET prompt_richtext = EXCLUDED.prompt_richtext, options_json = EXCLUDED.options_json, correct_answer_json = EXCLUDED.correct_answer_json;


-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'Rookie Final Test' as entity,
    COUNT(*) as count
FROM lessons
WHERE id = '00000001-0000-0000-0000-000000000027'

UNION ALL

SELECT
    'Test Items' as entity,
    COUNT(*) as count
FROM items
WHERE lesson_id = '00000001-0000-0000-0000-000000000027';
