-- ============================================================================
-- BASEBALL RESET AND SEED - Complete Script
-- ============================================================================
-- This script DELETES all existing baseball data and re-seeds everything fresh.
-- Run this in Supabase SQL Editor as a single transaction.
-- ============================================================================

-- ============================================================================
-- STEP 1: Delete existing baseball data (in correct order for foreign keys)
-- ============================================================================

-- First, delete any user-related data that references baseball items/lessons
-- (These tables may have foreign key constraints)
-- Using DO blocks to handle cases where tables might not exist

DO $$
BEGIN
    -- Delete SRS reviews for baseball items (must come before srs_cards)
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'srs_reviews') THEN
        DELETE FROM srs_reviews WHERE card_id IN (
            SELECT sc.id FROM srs_cards sc
            JOIN items i ON sc.item_id = i.id
            JOIN lessons l ON i.lesson_id = l.id
            WHERE l.module_id = '22222222-2222-2222-2222-222222222222'
        );
    END IF;

    -- Delete SRS cards for baseball items
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'srs_cards') THEN
        DELETE FROM srs_cards WHERE item_id IN (
            SELECT i.id FROM items i
            JOIN lessons l ON i.lesson_id = l.id
            WHERE l.module_id = '22222222-2222-2222-2222-222222222222'
        );
    END IF;

    -- Delete user item stats for baseball items
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'user_item_stats') THEN
        DELETE FROM user_item_stats WHERE item_id IN (
            SELECT i.id FROM items i
            JOIN lessons l ON i.lesson_id = l.id
            WHERE l.module_id = '22222222-2222-2222-2222-222222222222'
        );
    END IF;

    -- Delete user lesson completions for baseball lessons
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'user_lesson_completions') THEN
        DELETE FROM user_lesson_completions WHERE lesson_id IN (
            SELECT id FROM lessons WHERE module_id = '22222222-2222-2222-2222-222222222222'
        );
    END IF;

    -- Delete submission_judgments first (references submissions)
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'submission_judgments') THEN
        DELETE FROM submission_judgments WHERE submission_id IN (
            SELECT s.id FROM submissions s
            JOIN item_variants iv ON s.item_variant_id = iv.id
            JOIN items i ON iv.item_id = i.id
            JOIN lessons l ON i.lesson_id = l.id
            WHERE l.module_id = '22222222-2222-2222-2222-222222222222'
        );
    END IF;

    -- Delete submissions for baseball item variants
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'submissions') THEN
        DELETE FROM submissions WHERE item_variant_id IN (
            SELECT iv.id FROM item_variants iv
            JOIN items i ON iv.item_id = i.id
            JOIN lessons l ON i.lesson_id = l.id
            WHERE l.module_id = '22222222-2222-2222-2222-222222222222'
        );
    END IF;

    -- Delete item_assets for baseball item variants
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'item_assets') THEN
        DELETE FROM item_assets WHERE variant_id IN (
            SELECT iv.id FROM item_variants iv
            JOIN items i ON iv.item_id = i.id
            JOIN lessons l ON i.lesson_id = l.id
            WHERE l.module_id = '22222222-2222-2222-2222-222222222222'
        );
    END IF;

    -- Delete user progress for baseball sport
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'user_progress') THEN
        DELETE FROM user_progress WHERE sport_id = '02ba5eba-1100-0000-0000-000000000000';
    END IF;
END $$;

-- Now delete the content tables

-- DIRECT DELETION by ID patterns (catches orphaned records from failed runs)
-- Baseball items use IDs: 00000021-* through 00000031-* (GB1 through Quiz)

-- Delete item_variants by ID pattern (baseball item variants)
DELETE FROM item_variants WHERE id::text LIKE '00000021-%';
DELETE FROM item_variants WHERE id::text LIKE '00000022-%';
DELETE FROM item_variants WHERE id::text LIKE '00000023-%';
DELETE FROM item_variants WHERE id::text LIKE '00000024-%';
DELETE FROM item_variants WHERE id::text LIKE '00000025-%';
DELETE FROM item_variants WHERE id::text LIKE '00000026-%';
DELETE FROM item_variants WHERE id::text LIKE '00000027-%';
DELETE FROM item_variants WHERE id::text LIKE '00000028-%';
DELETE FROM item_variants WHERE id::text LIKE '00000029-%';
DELETE FROM item_variants WHERE id::text LIKE '0000002a-%';
DELETE FROM item_variants WHERE id::text LIKE '00000031-%';

-- Delete items by ID pattern (baseball items)
DELETE FROM items WHERE id::text LIKE '00000021-%';
DELETE FROM items WHERE id::text LIKE '00000022-%';
DELETE FROM items WHERE id::text LIKE '00000023-%';
DELETE FROM items WHERE id::text LIKE '00000024-%';
DELETE FROM items WHERE id::text LIKE '00000025-%';
DELETE FROM items WHERE id::text LIKE '00000026-%';
DELETE FROM items WHERE id::text LIKE '00000027-%';
DELETE FROM items WHERE id::text LIKE '00000028-%';
DELETE FROM items WHERE id::text LIKE '00000029-%';
DELETE FROM items WHERE id::text LIKE '0000002a-%';
DELETE FROM items WHERE id::text LIKE '00000031-%';

-- Also try JOIN-based deletion (for any that might have different ID patterns)

-- Delete item_variants for baseball lessons (by sport_id)
DELETE FROM item_variants WHERE item_id IN (
    SELECT i.id FROM items i
    JOIN lessons l ON i.lesson_id = l.id
    JOIN modules m ON l.module_id = m.id
    WHERE m.sport_id = '02ba5eba-1100-0000-0000-000000000000'
);

-- Delete item_variants for baseball lessons (by module_id)
DELETE FROM item_variants WHERE item_id IN (
    SELECT i.id FROM items i
    JOIN lessons l ON i.lesson_id = l.id
    WHERE l.module_id = '22222222-2222-2222-2222-222222222222'
);

-- Delete items for baseball lessons (by sport_id)
DELETE FROM items WHERE lesson_id IN (
    SELECT l.id FROM lessons l
    JOIN modules m ON l.module_id = m.id
    WHERE m.sport_id = '02ba5eba-1100-0000-0000-000000000000'
);

-- Delete items for baseball lessons (by module_id)
DELETE FROM items WHERE lesson_id IN (
    SELECT l.id FROM lessons l
    WHERE l.module_id = '22222222-2222-2222-2222-222222222222'
);

-- Delete baseball lessons by ID pattern (catches orphaned lessons)
-- Baseball lessons use IDs: 00000002-0000-0000-0000-000000000001 through 00000002-0000-0000-0000-000000000011
DELETE FROM lessons WHERE id::text LIKE '00000002-0000-0000-0000-0000000000%';

-- Delete baseball lessons (by sport_id)
DELETE FROM lessons WHERE module_id IN (
    SELECT id FROM modules WHERE sport_id = '02ba5eba-1100-0000-0000-000000000000'
);

-- Delete baseball lessons (by module_id)
DELETE FROM lessons WHERE module_id = '22222222-2222-2222-2222-222222222222';

-- Delete baseball modules by sport_id
DELETE FROM modules WHERE sport_id = '02ba5eba-1100-0000-0000-000000000000';

-- Also delete module by ID in case sport_id is different
DELETE FROM modules WHERE id = '22222222-2222-2222-2222-222222222222';

-- Delete baseball sport by ID
DELETE FROM sports WHERE id = '02ba5eba-1100-0000-0000-000000000000';

-- Also delete by slug in case ID is different
DELETE FROM sports WHERE slug = 'baseball';

-- ============================================================================
-- STEP 2: Create Baseball Sport
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
);

-- ============================================================================
-- STEP 3: Create Rookie Module
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
);

-- ============================================================================
-- STEP 4: Ensure System User exists
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
-- LESSON 1: GB1 - Game Basics 1 (ORDER: 1)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-000000000001',
    '22222222-2222-2222-2222-222222222222',
    'Game Basics 1',
    'What is baseball? Learn the basic objective and how two teams compete.',
    1, 4, 50, false, 'GB1', 5, 5
);

-- GB1 Items
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000021-0001-0000-0000-000000000001', '00000002-0000-0000-0000-000000000001', 'mcq', 'How many teams play in a baseball game?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000021-0001-0000-0000-000000000002', '00000002-0000-0000-0000-000000000001', 'mcq', 'One team bats while the other team plays in the field. What is the batting team trying to do?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000021-0001-0000-0000-000000000003', '00000002-0000-0000-0000-000000000001', 'mcq', 'The fielding team spreads out across the field. What are they trying to do?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000021-0001-0000-0000-000000000004', '00000002-0000-0000-0000-000000000001', 'mcq', 'A baseball game is divided into sections called "innings." How many innings are in a standard professional baseball game?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000021-0001-0000-0000-000000000005', '00000002-0000-0000-0000-000000000001', 'binary', 'In baseball, the two teams take turns batting and fielding during each inning.', '{"correct_boolean": true}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000021-0001-0000-0000-000000000006', '00000002-0000-0000-0000-000000000001', 'mcq', 'How does a team win a baseball game?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000021-0001-0000-0000-000000000007', '00000002-0000-0000-0000-000000000001', 'mcq', 'In baseball, a "run" is a point. How does a player score a run?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000021-0001-0000-0000-000000000008', '00000002-0000-0000-0000-000000000001', 'mcq', 'Each team bats until they get a certain number of "outs." How many outs does a team get before they switch to fielding?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000021-0001-0000-0000-000000000009', '00000002-0000-0000-0000-000000000001', 'mcq', 'Each inning has two halves: the "top" and the "bottom." What happens during each half?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1);

-- GB1 Item Variants
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000021-0001-0001-0000-000000000001', '00000021-0001-0000-0000-000000000001', 1, 'How many teams play in a baseball game?', '["1 team", "2 teams", "3 teams", "4 teams"]', '{"index": 1}', '', true),
('00000021-0001-0001-0000-000000000002', '00000021-0001-0000-0000-000000000002', 1, 'One team bats while the other team plays in the field. What is the batting team trying to do?', '["Catch the ball", "Strike out the other players", "Hit the ball and score runs", "Throw the ball as far as possible"]', '{"index": 2}', '', true),
('00000021-0001-0001-0000-000000000003', '00000021-0001-0000-0000-000000000003', 1, 'The fielding team spreads out across the field. What are they trying to do?', '["Get the batting team''s players out and prevent runs", "Score more runs than the batting team", "Hit the ball back to the batters", "Run around the bases"]', '{"index": 0}', '', true),
('00000021-0001-0001-0000-000000000004', '00000021-0001-0000-0000-000000000004', 1, 'A baseball game is divided into sections called "innings." How many innings are in a standard professional baseball game?', '["4 innings", "7 innings", "9 innings", "12 innings"]', '{"index": 2}', '', true),
('00000021-0001-0001-0000-000000000005', '00000021-0001-0000-0000-000000000005', 1, 'In baseball, the two teams take turns batting and fielding during each inning.', '["True", "False"]', '{"boolean": true}', '', true),
('00000021-0001-0001-0000-000000000006', '00000021-0001-0000-0000-000000000006', 1, 'How does a team win a baseball game?', '["By hitting the most home runs", "By scoring more runs than the other team", "By getting the most hits", "By playing the most innings"]', '{"index": 1}', '', true),
('00000021-0001-0001-0000-000000000007', '00000021-0001-0000-0000-000000000007', 1, 'In baseball, a "run" is a point. How does a player score a run?', '["By hitting the ball", "By catching the ball", "By running around all the bases and touching home plate", "By throwing the ball to a teammate"]', '{"index": 2}', '', true),
('00000021-0001-0001-0000-000000000008', '00000021-0001-0000-0000-000000000008', 1, 'Each team bats until they get a certain number of "outs." How many outs does a team get before they switch to fielding?', '["1 out", "2 outs", "3 outs", "4 outs"]', '{"index": 2}', '', true),
('00000021-0001-0001-0000-000000000009', '00000021-0001-0000-0000-000000000009', 1, 'Each inning has two halves: the "top" and the "bottom." What happens during each half?', '["Both teams bat at the same time", "One team bats while the other fields, then they switch", "The teams take a break", "The game clock runs down"]', '{"index": 1}', '', true);

-- ============================================================================
-- LESSON 2: TF1 - The Field 1 (ORDER: 2)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-000000000002',
    '22222222-2222-2222-2222-222222222222',
    'The Field 1',
    'Learn the layout of a baseball field - the diamond, bases, and key areas.',
    2, 4, 50, true, 'TF1', 5, 5
);

-- TF1 Items
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000022-0001-0000-0000-000000000001', '00000002-0000-0000-0000-000000000002', 'mcq', 'The inner part of a baseball field is called the "infield." What shape is the infield?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000022-0001-0000-0000-000000000002', '00000002-0000-0000-0000-000000000002', 'mcq', 'How many bases are there on a baseball field?', '{"correct_index": 3}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000022-0001-0000-0000-000000000003', '00000002-0000-0000-0000-000000000002', 'mcq', 'What is "home plate" in baseball?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000022-0001-0000-0000-000000000004', '00000002-0000-0000-0000-000000000002', 'mcq', 'A runner starts at home plate. In what order do they run around the bases?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000022-0001-0000-0000-000000000005', '00000002-0000-0000-0000-000000000002', 'binary', 'Runners move around the bases in a counterclockwise direction (turning left from home plate).', '{"correct_boolean": true}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000022-0001-0000-0000-000000000006', '00000002-0000-0000-0000-000000000002', 'mcq', 'The "outfield" is the large grassy area beyond the infield. Where is it located?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000022-0001-0000-0000-000000000007', '00000002-0000-0000-0000-000000000002', 'mcq', 'In professional baseball, how far apart are the bases?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000022-0001-0000-0000-000000000008', '00000002-0000-0000-0000-000000000002', 'mcq', 'The four corners of the baseball diamond are marked by:', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000022-0001-0000-0000-000000000009', '00000002-0000-0000-0000-000000000002', 'mcq', 'What surface is the infield typically made of in professional baseball?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1);

-- TF1 Item Variants
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000022-0001-0001-0000-000000000001', '00000022-0001-0000-0000-000000000001', 1, 'The inner part of a baseball field is called the "infield." What shape is the infield?', '["A circle", "A diamond (square tilted on its corner)", "A rectangle", "A triangle"]', '{"index": 1}', '', true),
('00000022-0001-0001-0000-000000000002', '00000022-0001-0000-0000-000000000002', 1, 'How many bases are there on a baseball field?', '["2 bases", "3 bases", "5 bases", "4 bases (including home plate)"]', '{"index": 3}', '', true),
('00000022-0001-0001-0000-000000000003', '00000022-0001-0000-0000-000000000003', 1, 'What is "home plate" in baseball?', '["Where the pitcher stands", "A place to eat during the game", "Where the batter stands and where runners finish to score", "The center of the outfield"]', '{"index": 2}', '', true),
('00000022-0001-0001-0000-000000000004', '00000022-0001-0000-0000-000000000004', 1, 'A runner starts at home plate. In what order do they run around the bases?', '["First base → Second base → Third base → Home plate", "Third base → Second base → First base → Home plate", "Second base → First base → Third base → Home plate", "Home plate → Third base → First base → Second base"]', '{"index": 0}', '', true),
('00000022-0001-0001-0000-000000000005', '00000022-0001-0000-0000-000000000005', 1, 'Runners move around the bases in a counterclockwise direction (turning left from home plate).', '["True", "False"]', '{"boolean": true}', '', true),
('00000022-0001-0001-0000-000000000006', '00000022-0001-0000-0000-000000000006', 1, 'The "outfield" is the large grassy area beyond the infield. Where is it located?', '["Between home plate and first base", "Beyond the bases, stretching to the outfield wall", "Behind home plate", "Inside the diamond"]', '{"index": 1}', '', true),
('00000022-0001-0001-0000-000000000007', '00000022-0001-0000-0000-000000000007', 1, 'In professional baseball, how far apart are the bases?', '["45 feet", "60 feet", "90 feet", "120 feet"]', '{"index": 2}', '', true),
('00000022-0001-0001-0000-000000000008', '00000022-0001-0000-0000-000000000008', 1, 'The four corners of the baseball diamond are marked by:', '["Home plate, first base, second base, and third base", "Four flags", "Four pitching mounds", "Four dugouts"]', '{"index": 0}', '', true),
('00000022-0001-0001-0000-000000000009', '00000022-0001-0000-0000-000000000009', 1, 'What surface is the infield typically made of in professional baseball?', '["Only grass", "Mostly dirt with some grass", "Concrete", "Rubber turf"]', '{"index": 1}', '', true);

-- ============================================================================
-- LESSON 3: TF2 - The Field 2 (ORDER: 3)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-000000000003',
    '22222222-2222-2222-2222-222222222222',
    'The Field 2',
    'Learn about foul lines, the pitcher''s mound, and other key field features.',
    3, 4, 50, true, 'TF2', 5, 5
);

-- TF2 Items
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000023-0001-0000-0000-000000000001', '00000002-0000-0000-0000-000000000003', 'mcq', 'Two white lines extend from home plate down the first and third base sides. What are these lines called?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000023-0001-0000-0000-000000000002', '00000002-0000-0000-0000-000000000003', 'mcq', 'The area between the two foul lines (where the bases are) is called "fair territory." What is the area outside the foul lines called?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000023-0001-0000-0000-000000000003', '00000002-0000-0000-0000-000000000003', 'mcq', 'The pitcher throws from a raised dirt area called the "pitcher''s mound." Where is it located?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000023-0001-0000-0000-000000000004', '00000002-0000-0000-0000-000000000003', 'binary', 'The pitcher''s mound is raised higher than the rest of the field.', '{"correct_boolean": true}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000023-0001-0000-0000-000000000005', '00000002-0000-0000-0000-000000000003', 'mcq', 'On each side of home plate, there is a rectangle drawn in the dirt called the "batter''s box." What is it for?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000023-0001-0000-0000-000000000006', '00000002-0000-0000-0000-000000000003', 'mcq', 'The "dugout" is a sheltered area along each baseline. Who sits there?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000023-0001-0000-0000-000000000007', '00000002-0000-0000-0000-000000000003', 'mcq', 'How far is the pitcher''s mound from home plate in professional baseball?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000023-0001-0000-0000-000000000008', '00000002-0000-0000-0000-000000000003', 'mcq', 'If a batted ball lands in foul territory (outside the foul lines), what happens?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000023-0001-0000-0000-000000000009', '00000002-0000-0000-0000-000000000003', 'mcq', 'The "on-deck circle" is a marked area near the dugout. What is it used for?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1);

-- TF2 Item Variants
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000023-0001-0001-0000-000000000001', '00000023-0001-0000-0000-000000000001', 1, 'Two white lines extend from home plate down the first and third base sides. What are these lines called?', '["Base lines", "Boundary lines", "Foul lines", "Fair lines"]', '{"index": 2}', '', true),
('00000023-0001-0001-0000-000000000002', '00000023-0001-0000-0000-000000000002', 1, 'The area between the two foul lines (where the bases are) is called "fair territory." What is the area outside the foul lines called?', '["Out territory", "Foul territory", "Dead territory", "Side territory"]', '{"index": 1}', '', true),
('00000023-0001-0001-0000-000000000003', '00000023-0001-0000-0000-000000000003', 1, 'The pitcher throws from a raised dirt area called the "pitcher''s mound." Where is it located?', '["In the center of the diamond, between home plate and second base", "Behind home plate", "Next to first base", "In the outfield"]', '{"index": 0}', '', true),
('00000023-0001-0001-0000-000000000004', '00000023-0001-0000-0000-000000000004', 1, 'The pitcher''s mound is raised higher than the rest of the field.', '["True", "False"]', '{"boolean": true}', '', true),
('00000023-0001-0001-0000-000000000005', '00000023-0001-0000-0000-000000000005', 1, 'On each side of home plate, there is a rectangle drawn in the dirt called the "batter''s box." What is it for?', '["Where the catcher sits", "Where the umpire stands", "Where the batter must stand while batting", "Where runners wait"]', '{"index": 2}', '', true),
('00000023-0001-0001-0000-000000000006', '00000023-0001-0000-0000-000000000006', 1, 'The "dugout" is a sheltered area along each baseline. Who sits there?', '["Fans who have special tickets", "Players and coaches who are not currently on the field", "The umpires", "Security guards"]', '{"index": 1}', '', true),
('00000023-0001-0001-0000-000000000007', '00000023-0001-0000-0000-000000000007', 1, 'How far is the pitcher''s mound from home plate in professional baseball?', '["45 feet", "60 feet, 6 inches", "75 feet", "90 feet"]', '{"index": 1}', '', true),
('00000023-0001-0001-0000-000000000008', '00000023-0001-0000-0000-000000000008', 1, 'If a batted ball lands in foul territory (outside the foul lines), what happens?', '["It is called a foul ball and typically counts as a strike", "The batter is automatically out", "It counts as a hit", "The batter gets to run to first base"]', '{"index": 0}', '', true),
('00000023-0001-0001-0000-000000000009', '00000023-0001-0000-0000-000000000009', 1, 'The "on-deck circle" is a marked area near the dugout. What is it used for?', '["Where pitchers warm up", "Where coaches give signals", "Where the next batter waits and warms up", "Where injured players recover"]', '{"index": 2}', '', true);

-- ============================================================================
-- LESSON 4: SC1 - Scoring 1 (ORDER: 4)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-000000000004',
    '22222222-2222-2222-2222-222222222222',
    'Scoring 1',
    'Learn how runs are scored, what home runs are, and basic scoring concepts.',
    4, 4, 50, true, 'SC1', 5, 5
);

-- SC1 Items
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000024-0001-0000-0000-000000000001', '00000002-0000-0000-0000-000000000004', 'mcq', 'How does a player score a run in baseball?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000024-0001-0000-0000-000000000002', '00000002-0000-0000-0000-000000000004', 'mcq', 'In baseball, how much is each run worth?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000024-0001-0000-0000-000000000003', '00000002-0000-0000-0000-000000000004', 'mcq', 'What is a "home run"?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000024-0001-0000-0000-000000000004', '00000002-0000-0000-0000-000000000004', 'binary', 'When a batter hits a home run, they must still run around all the bases to score.', '{"correct_boolean": true}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000024-0001-0000-0000-000000000005', '00000002-0000-0000-0000-000000000004', 'mcq', 'RBI stands for "Run Batted In." What does it mean when a batter gets an RBI?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000024-0001-0000-0000-000000000006', '00000002-0000-0000-0000-000000000004', 'mcq', 'A "grand slam" is a special type of home run. What makes it a grand slam?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000024-0001-0000-0000-000000000007', '00000002-0000-0000-0000-000000000004', 'mcq', 'What is the maximum number of runs that can score on a single play?', '{"correct_index": 3}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000024-0001-0000-0000-000000000008', '00000002-0000-0000-0000-000000000004', 'mcq', 'If there is a runner on third base and the batter hits a single, what usually happens?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000024-0001-0000-0000-000000000009', '00000002-0000-0000-0000-000000000004', 'binary', 'A runner MUST physically touch home plate for the run to count.', '{"correct_boolean": true}', '00000000-0000-0000-0000-000000000000', 'live', 1);

-- SC1 Item Variants
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000024-0001-0001-0000-000000000001', '00000024-0001-0000-0000-000000000001', 1, 'How does a player score a run in baseball?', '["By hitting the ball", "By touching all the bases and returning to home plate safely", "By catching a fly ball", "By throwing out a runner"]', '{"index": 1}', '', true),
('00000024-0001-0001-0000-000000000002', '00000024-0001-0000-0000-000000000002', 1, 'In baseball, how much is each run worth?', '["1 point - all runs are worth the same", "2 points", "It depends on how the run was scored", "3 points for a home run, 1 for regular runs"]', '{"index": 0}', '', true),
('00000024-0001-0001-0000-000000000003', '00000024-0001-0000-0000-000000000003', 1, 'What is a "home run"?', '["Running from third base to home plate", "A ball caught by the home team", "A hit that goes over the outfield wall in fair territory, allowing the batter to run all the bases and score", "The first run of the game"]', '{"index": 2}', '', true),
('00000024-0001-0001-0000-000000000004', '00000024-0001-0000-0000-000000000004', 1, 'When a batter hits a home run, they must still run around all the bases to score.', '["True", "False"]', '{"boolean": true}', '', true),
('00000024-0001-0001-0000-000000000005', '00000024-0001-0000-0000-000000000005', 1, 'RBI stands for "Run Batted In." What does it mean when a batter gets an RBI?', '["The batter scored a run", "The batter''s hit helped a teammate score", "The batter hit a home run", "The batter struck out"]', '{"index": 1}', '', true),
('00000024-0001-0001-0000-000000000006', '00000024-0001-0000-0000-000000000006', 1, 'A "grand slam" is a special type of home run. What makes it a grand slam?', '["The ball goes extra far", "It''s hit in the final inning", "There are runners on all three bases when the home run is hit, so 4 runs score", "It bounces off the wall"]', '{"index": 2}', '', true),
('00000024-0001-0001-0000-000000000007', '00000024-0001-0000-0000-000000000007', 1, 'What is the maximum number of runs that can score on a single play?', '["1 run", "2 runs", "3 runs", "4 runs (a grand slam)"]', '{"index": 3}', '', true),
('00000024-0001-0001-0000-000000000008', '00000024-0001-0000-0000-000000000008', 1, 'If there is a runner on third base and the batter hits a single, what usually happens?', '["The runner on third scores a run", "The runner on third stays at third", "Both runners are out", "The inning ends"]', '{"index": 0}', '', true),
('00000024-0001-0001-0000-000000000009', '00000024-0001-0000-0000-000000000009', 1, 'A runner MUST physically touch home plate for the run to count.', '["True", "False"]', '{"boolean": true}', '', true);

-- ============================================================================
-- LESSON 5: AB1 - At Bats 1 (ORDER: 5)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-000000000005',
    '22222222-2222-2222-2222-222222222222',
    'At Bats 1',
    'Learn about strikes, balls, and what happens during an at bat.',
    5, 4, 50, true, 'AB1', 5, 5
);

-- AB1 Items
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000025-0001-0000-0000-000000000001', '00000002-0000-0000-0000-000000000005', 'mcq', 'What is a "strike" in baseball?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000025-0001-0000-0000-000000000002', '00000002-0000-0000-0000-000000000005', 'mcq', 'What is a "ball" (as in balls and strikes)?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000025-0001-0000-0000-000000000003', '00000002-0000-0000-0000-000000000005', 'mcq', 'How many strikes does it take to strike out a batter?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000025-0001-0000-0000-000000000004', '00000002-0000-0000-0000-000000000005', 'mcq', 'If a pitcher throws too many balls, the batter gets to walk to first base. How many balls equal a "walk"?', '{"correct_index": 3}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000025-0001-0000-0000-000000000005', '00000002-0000-0000-0000-000000000005', 'mcq', 'The "count" tells you how many balls and strikes there are. If the count is "2-1," what does that mean?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000025-0001-0000-0000-000000000006', '00000002-0000-0000-0000-000000000005', 'mcq', 'A "full count" is when the batter has the maximum balls and strikes without being out or walking. What is a full count?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000025-0001-0000-0000-000000000007', '00000002-0000-0000-0000-000000000005', 'binary', 'When a batter strikes out, it counts as one of the team''s three outs.', '{"correct_boolean": true}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000025-0001-0000-0000-000000000008', '00000002-0000-0000-0000-000000000005', 'mcq', 'The "strike zone" is an imaginary box over home plate. Where is it located vertically?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000025-0001-0000-0000-000000000009', '00000002-0000-0000-0000-000000000005', 'mcq', 'If a batter hits a foul ball, what happens to the count?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1);

-- AB1 Item Variants
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000025-0001-0001-0000-000000000001', '00000025-0001-0000-0000-000000000001', 1, 'What is a "strike" in baseball?', '["When a batter hits the ball", "A pitch in the strike zone that the batter doesn''t hit, or any pitch the batter swings at and misses", "When a runner is safe at a base", "When the pitcher drops the ball"]', '{"index": 1}', '', true),
('00000025-0001-0001-0000-000000000002', '00000025-0001-0000-0000-000000000002', 1, 'What is a "ball" (as in balls and strikes)?', '["A pitch that is outside the strike zone and the batter doesn''t swing at", "Any pitch that the batter hits", "A pitch that the catcher drops", "The baseball itself"]', '{"index": 0}', '', true),
('00000025-0001-0001-0000-000000000003', '00000025-0001-0000-0000-000000000003', 1, 'How many strikes does it take to strike out a batter?', '["1 strike", "2 strikes", "3 strikes", "4 strikes"]', '{"index": 2}', '', true),
('00000025-0001-0001-0000-000000000004', '00000025-0001-0000-0000-000000000004', 1, 'If a pitcher throws too many balls, the batter gets to walk to first base. How many balls equal a "walk"?', '["2 balls", "3 balls", "5 balls", "4 balls"]', '{"index": 3}', '', true),
('00000025-0001-0001-0000-000000000005', '00000025-0001-0000-0000-000000000005', 1, 'The "count" tells you how many balls and strikes there are. If the count is "2-1," what does that mean?', '["2 balls, 1 strike", "2 strikes, 1 ball", "2 outs, 1 run", "2 innings, 1 out"]', '{"index": 0}', '', true),
('00000025-0001-0001-0000-000000000006', '00000025-0001-0000-0000-000000000006', 1, 'A "full count" is when the batter has the maximum balls and strikes without being out or walking. What is a full count?', '["2 balls, 2 strikes", "4 balls, 3 strikes", "3 balls, 2 strikes", "2 balls, 3 strikes"]', '{"index": 2}', '', true),
('00000025-0001-0001-0000-000000000007', '00000025-0001-0000-0000-000000000007', 1, 'When a batter strikes out, it counts as one of the team''s three outs.', '["True", "False"]', '{"boolean": true}', '', true),
('00000025-0001-0001-0000-000000000008', '00000025-0001-0000-0000-000000000008', 1, 'The "strike zone" is an imaginary box over home plate. Where is it located vertically?', '["From the ground to the batter''s head", "Roughly from the batter''s knees to the middle of their torso", "From the batter''s waist to their shoulders only", "It''s the same for all batters regardless of height"]', '{"index": 1}', '', true),
('00000025-0001-0001-0000-000000000009', '00000025-0001-0000-0000-000000000009', 1, 'If a batter hits a foul ball, what happens to the count?', '["It always counts as a ball", "It counts as a strikeout", "It counts as a strike, but you cannot strike out on a foul ball (unless it''s caught)", "Nothing - the count stays the same"]', '{"index": 2}', '', true);

-- ============================================================================
-- LESSON 6: AB2 - At Bats 2 (ORDER: 6)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-000000000006',
    '22222222-2222-2222-2222-222222222222',
    'At Bats 2',
    'Learn about different types of hits and how the batting order works.',
    6, 4, 50, true, 'AB2', 5, 5
);

-- AB2 Items
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000026-0001-0000-0000-000000000001', '00000002-0000-0000-0000-000000000006', 'mcq', 'What is a "single" in baseball?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000026-0001-0000-0000-000000000002', '00000002-0000-0000-0000-000000000006', 'mcq', 'What is a "double" in baseball?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000026-0001-0000-0000-000000000003', '00000002-0000-0000-0000-000000000006', 'mcq', 'What is a "triple" in baseball?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000026-0001-0000-0000-000000000004', '00000002-0000-0000-0000-000000000006', 'mcq', 'How many batters are in a team''s batting order (lineup)?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000026-0001-0000-0000-000000000005', '00000002-0000-0000-0000-000000000006', 'binary', 'After the 9th batter hits, the batting order starts over with the 1st batter.', '{"correct_boolean": true}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000026-0001-0000-0000-000000000006', '00000002-0000-0000-0000-000000000006', 'mcq', 'When does a batter get credit for a "hit"?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000026-0001-0000-0000-000000000007', '00000002-0000-0000-0000-000000000006', 'mcq', 'The "leadoff hitter" is the player who bats in which position in the lineup?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000026-0001-0000-0000-000000000008', '00000002-0000-0000-0000-000000000006', 'mcq', 'The "cleanup hitter" traditionally bats in which position?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000026-0001-0000-0000-000000000009', '00000002-0000-0000-0000-000000000006', 'mcq', 'A walk does NOT count as an official "at bat" for the batter. Why might this matter?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1);

-- AB2 Item Variants
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000026-0001-0001-0000-000000000001', '00000026-0001-0000-0000-000000000001', 1, 'What is a "single" in baseball?', '["A hit where the batter reaches first base safely", "A hit where the batter reaches second base", "When only one player is on base", "A pitch that results in one strike"]', '{"index": 0}', '', true),
('00000026-0001-0001-0000-000000000002', '00000026-0001-0000-0000-000000000002', 1, 'What is a "double" in baseball?', '["When two players are on base", "A hit where the batter reaches second base safely", "Two outs in an inning", "A ball hit twice"]', '{"index": 1}', '', true),
('00000026-0001-0001-0000-000000000003', '00000026-0001-0000-0000-000000000003', 1, 'What is a "triple" in baseball?', '["Three strikes", "Three balls", "A hit where the batter reaches third base safely", "When three runners are on base"]', '{"index": 2}', '', true),
('00000026-0001-0001-0000-000000000004', '00000026-0001-0000-0000-000000000004', 1, 'How many batters are in a team''s batting order (lineup)?', '["5 batters", "7 batters", "9 batters", "11 batters"]', '{"index": 2}', '', true),
('00000026-0001-0001-0000-000000000005', '00000026-0001-0000-0000-000000000005', 1, 'After the 9th batter hits, the batting order starts over with the 1st batter.', '["True", "False"]', '{"boolean": true}', '', true),
('00000026-0001-0001-0000-000000000006', '00000026-0001-0000-0000-000000000006', 1, 'When does a batter get credit for a "hit"?', '["Any time they swing the bat", "When they hit the ball into fair territory and reach base safely without an error", "When they hit a foul ball", "When they get walked"]', '{"index": 1}', '', true),
('00000026-0001-0001-0000-000000000007', '00000026-0001-0000-0000-000000000007', 1, 'The "leadoff hitter" is the player who bats in which position in the lineup?', '["1st", "4th", "9th", "5th"]', '{"index": 0}', '', true),
('00000026-0001-0001-0000-000000000008', '00000026-0001-0000-0000-000000000008', 1, 'The "cleanup hitter" traditionally bats in which position?', '["1st", "4th", "9th", "3rd"]', '{"index": 1}', '', true),
('00000026-0001-0001-0000-000000000009', '00000026-0001-0000-0000-000000000009', 1, 'A walk does NOT count as an official "at bat" for the batter. Why might this matter?', '["It affects how runs are counted", "It changes the batting order", "It affects the batter''s batting average (hits divided by at bats)", "It doesn''t matter at all"]', '{"index": 2}', '', true);

-- ============================================================================
-- LESSON 7: PO1 - Positions 1 (ORDER: 7)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-000000000007',
    '22222222-2222-2222-2222-222222222222',
    'Positions 1',
    'Learn about the pitcher, catcher, and infield positions.',
    7, 4, 50, true, 'PO1', 5, 5
);

-- PO1 Items
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000027-0001-0000-0000-000000000001', '00000002-0000-0000-0000-000000000007', 'mcq', 'What is the pitcher''s main job?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000027-0001-0000-0000-000000000002', '00000002-0000-0000-0000-000000000007', 'mcq', 'The catcher wears special protective gear. Where do they position themselves?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000027-0001-0000-0000-000000000003', '00000002-0000-0000-0000-000000000007', 'mcq', 'The pitcher and catcher together are called the "battery." Why are they called this?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000027-0001-0000-0000-000000000004', '00000002-0000-0000-0000-000000000007', 'mcq', 'Where does the first baseman typically stand?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000027-0001-0000-0000-000000000005', '00000002-0000-0000-0000-000000000007', 'mcq', 'The shortstop plays between which two bases?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000027-0001-0000-0000-000000000006', '00000002-0000-0000-0000-000000000007', 'mcq', 'Not counting the pitcher and catcher, how many infielders are there?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000027-0001-0000-0000-000000000007', '00000002-0000-0000-0000-000000000007', 'mcq', 'The second baseman plays between which two bases?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000027-0001-0000-0000-000000000008', '00000002-0000-0000-0000-000000000007', 'mcq', 'Third base is often called the "hot corner." Why?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000027-0001-0000-0000-000000000009', '00000002-0000-0000-0000-000000000007', 'binary', 'There are 9 defensive players on the field at one time.', '{"correct_boolean": true}', '00000000-0000-0000-0000-000000000000', 'live', 1);

-- PO1 Item Variants
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000027-0001-0001-0000-000000000001', '00000027-0001-0000-0000-000000000001', 1, 'What is the pitcher''s main job?', '["To hit the ball", "To throw the ball to the batter and try to get them out", "To catch fly balls in the outfield", "To run the bases"]', '{"index": 1}', '', true),
('00000027-0001-0001-0000-000000000002', '00000027-0001-0000-0000-000000000002', 1, 'The catcher wears special protective gear. Where do they position themselves?', '["Behind home plate, facing the pitcher", "On the pitcher''s mound", "In the outfield", "On first base"]', '{"index": 0}', '', true),
('00000027-0001-0001-0000-000000000003', '00000027-0001-0000-0000-000000000003', 1, 'The pitcher and catcher together are called the "battery." Why are they called this?', '["They wear the most equipment", "They score the most runs", "They work together as a team within the team, communicating on every pitch", "They hit the hardest"]', '{"index": 2}', '', true),
('00000027-0001-0001-0000-000000000004', '00000027-0001-0000-0000-000000000004', 1, 'Where does the first baseman typically stand?', '["Behind second base", "Near first base", "Behind home plate", "In center field"]', '{"index": 1}', '', true),
('00000027-0001-0001-0000-000000000005', '00000027-0001-0000-0000-000000000005', 1, 'The shortstop plays between which two bases?', '["Second base and third base", "First base and second base", "Home plate and first base", "Third base and home plate"]', '{"index": 0}', '', true),
('00000027-0001-0001-0000-000000000006', '00000027-0001-0000-0000-000000000006', 1, 'Not counting the pitcher and catcher, how many infielders are there?', '["2 (first and third baseman)", "3 (three basemen)", "4 (first baseman, second baseman, shortstop, third baseman)", "5 (four basemen plus shortstop)"]', '{"index": 2}', '', true),
('00000027-0001-0001-0000-000000000007', '00000027-0001-0000-0000-000000000007', 1, 'The second baseman plays between which two bases?', '["Second base and third base", "First base and second base", "Home plate and first base", "Third base and home plate"]', '{"index": 1}', '', true),
('00000027-0001-0001-0000-000000000008', '00000027-0001-0000-0000-000000000008', 1, 'Third base is often called the "hot corner." Why?', '["The sun shines there most", "It''s closest to the dugout", "Hard-hit balls come at the third baseman very fast", "It''s the hottest spot temperature-wise"]', '{"index": 2}', '', true),
('00000027-0001-0001-0000-000000000009', '00000027-0001-0000-0000-000000000009', 1, 'There are 9 defensive players on the field at one time.', '["True", "False"]', '{"boolean": true}', '', true);

-- ============================================================================
-- LESSON 8: PO2 - Positions 2 (ORDER: 8)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-000000000008',
    '22222222-2222-2222-2222-222222222222',
    'Positions 2',
    'Learn about the outfield positions and the designated hitter.',
    8, 4, 50, true, 'PO2', 5, 5
);

-- PO2 Items
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000028-0001-0000-0000-000000000001', '00000002-0000-0000-0000-000000000008', 'mcq', 'How many outfielders are on the field?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000028-0001-0000-0000-000000000002', '00000002-0000-0000-0000-000000000008', 'mcq', 'What are the three outfield positions called?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000028-0001-0000-0000-000000000003', '00000002-0000-0000-0000-000000000008', 'mcq', 'The center fielder typically covers the largest area. Why is this position important?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000028-0001-0000-0000-000000000004', '00000002-0000-0000-0000-000000000008', 'mcq', 'Left field and right field are named from whose perspective?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000028-0001-0000-0000-000000000005', '00000002-0000-0000-0000-000000000008', 'mcq', 'What is a "designated hitter" (DH)?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000028-0001-0000-0000-000000000006', '00000002-0000-0000-0000-000000000008', 'binary', 'The designated hitter (DH) plays a defensive position in the field.', '{"correct_boolean": false}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000028-0001-0000-0000-000000000007', '00000002-0000-0000-0000-000000000008', 'mcq', 'What is the main job of an outfielder?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000028-0001-0000-0000-000000000008', '00000002-0000-0000-0000-000000000008', 'mcq', 'Right fielders often need strong throwing arms. Why?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000028-0001-0000-0000-000000000009', '00000002-0000-0000-0000-000000000008', 'mcq', 'Including all positions (pitcher, catcher, infielders, outfielders), how many defensive positions are there?', '{"correct_index": 3}', '00000000-0000-0000-0000-000000000000', 'live', 1);

-- PO2 Item Variants
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000028-0001-0001-0000-000000000001', '00000028-0001-0000-0000-000000000001', 1, 'How many outfielders are on the field?', '["1", "2", "3", "4"]', '{"index": 2}', '', true),
('00000028-0001-0001-0000-000000000002', '00000028-0001-0000-0000-000000000002', 1, 'What are the three outfield positions called?', '["Left fielder, center fielder, right fielder", "Front fielder, back fielder, side fielder", "Near fielder, far fielder, middle fielder", "First fielder, second fielder, third fielder"]', '{"index": 0}', '', true),
('00000028-0001-0001-0000-000000000003', '00000028-0001-0000-0000-000000000003', 1, 'The center fielder typically covers the largest area. Why is this position important?', '["They hit the most home runs", "They need speed and good judgment to cover lots of ground and catch fly balls", "They throw the most pitches", "They are closest to the dugout"]', '{"index": 1}', '', true),
('00000028-0001-0001-0000-000000000004', '00000028-0001-0000-0000-000000000004', 1, 'Left field and right field are named from whose perspective?', '["From the pitcher''s view", "From the fans'' view", "From the batter''s or catcher''s view (looking out at the field)", "From the outfielder''s view"]', '{"index": 2}', '', true),
('00000028-0001-0001-0000-000000000005', '00000028-0001-0000-0000-000000000005', 1, 'What is a "designated hitter" (DH)?', '["A player who only plays defense", "A player who bats in place of the pitcher but doesn''t play defense", "The team''s best hitter who bats first", "A backup player"]', '{"index": 1}', '', true),
('00000028-0001-0001-0000-000000000006', '00000028-0001-0000-0000-000000000006', 1, 'The designated hitter (DH) plays a defensive position in the field.', '["True", "False"]', '{"boolean": false}', '', true),
('00000028-0001-0001-0000-000000000007', '00000028-0001-0000-0000-000000000007', 1, 'What is the main job of an outfielder?', '["Catch fly balls and field hits that get past the infield", "Pitch to the batters", "Call the plays", "Guard the bases"]', '{"index": 0}', '', true),
('00000028-0001-0001-0000-000000000008', '00000028-0001-0000-0000-000000000008', 1, 'Right fielders often need strong throwing arms. Why?', '["They throw the most pitches", "They are farthest from home plate", "They have the longest throw to third base to prevent runners from advancing", "They need to throw to the pitcher"]', '{"index": 2}', '', true),
('00000028-0001-0001-0000-000000000009', '00000028-0001-0000-0000-000000000009', 1, 'Including all positions (pitcher, catcher, infielders, outfielders), how many defensive positions are there?', '["6", "7", "8", "9"]', '{"index": 3}', '', true);

-- ============================================================================
-- LESSON 9: PL1 - Plays 1 (ORDER: 9)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-000000000009',
    '22222222-2222-2222-2222-222222222222',
    'Plays 1',
    'Learn the different ways to get batters and runners out.',
    9, 4, 50, true, 'PL1', 5, 5
);

-- PL1 Items
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('00000029-0001-0000-0000-000000000001', '00000002-0000-0000-0000-000000000009', 'mcq', 'What is a "fly out"?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000029-0001-0000-0000-000000000002', '00000002-0000-0000-0000-000000000009', 'mcq', 'What is a "ground out"?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000029-0001-0000-0000-000000000003', '00000002-0000-0000-0000-000000000009', 'mcq', 'What is a "force out"?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000029-0001-0000-0000-000000000004', '00000002-0000-0000-0000-000000000009', 'mcq', 'A runner is "forced" to run to the next base when:', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000029-0001-0000-0000-000000000005', '00000002-0000-0000-0000-000000000009', 'mcq', 'What is a "tag out"?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000029-0001-0000-0000-000000000006', '00000002-0000-0000-0000-000000000009', 'binary', 'After hitting a fair ball, the batter is always "forced" to run to first base.', '{"correct_boolean": true}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000029-0001-0000-0000-000000000007', '00000002-0000-0000-0000-000000000009', 'mcq', 'A "pop fly" is a ball hit:', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000029-0001-0000-0000-000000000008', '00000002-0000-0000-0000-000000000009', 'mcq', 'A "line drive" is a ball hit:', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('00000029-0001-0000-0000-000000000009', '00000002-0000-0000-0000-000000000009', 'mcq', 'If a fly ball is caught, what happens to runners already on base?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1);

-- PL1 Item Variants
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('00000029-0001-0001-0000-000000000001', '00000029-0001-0000-0000-000000000001', 1, 'What is a "fly out"?', '["When a runner is tagged out", "When a fielder catches a hit ball in the air before it touches the ground", "When a batter strikes out", "When a ball goes over the fence"]', '{"index": 1}', '', true),
('00000029-0001-0001-0000-000000000002', '00000029-0001-0000-0000-000000000002', 1, 'What is a "ground out"?', '["When a batter hits the ball on the ground and is thrown out at first base", "When the ball hits the ground in foul territory", "When a runner falls down", "When the pitcher throws the ball into the dirt"]', '{"index": 0}', '', true),
('00000029-0001-0001-0000-000000000003', '00000029-0001-0000-0000-000000000003', 1, 'What is a "force out"?', '["When a fielder pushes a runner", "When the batter is forced to swing", "When a fielder touches the base before a runner who must advance reaches it", "When the pitcher throws very hard"]', '{"index": 2}', '', true),
('00000029-0001-0001-0000-000000000004', '00000029-0001-0000-0000-000000000004', 1, 'A runner is "forced" to run to the next base when:', '["They want to score", "Another runner or the batter is coming to their base, so they must advance", "The coach tells them to", "They see a fly ball"]', '{"index": 1}', '', true),
('00000029-0001-0001-0000-000000000005', '00000029-0001-0000-0000-000000000005', 1, 'What is a "tag out"?', '["When a fielder touches a runner with the ball (or glove holding the ball) while the runner is not on a base", "When a fielder calls out the runner''s name", "When the umpire tags the runner", "When a runner touches a base"]', '{"index": 0}', '', true),
('00000029-0001-0001-0000-000000000006', '00000029-0001-0000-0000-000000000006', 1, 'After hitting a fair ball, the batter is always "forced" to run to first base.', '["True", "False"]', '{"boolean": true}', '', true),
('00000029-0001-0001-0000-000000000007', '00000029-0001-0000-0000-000000000007', 1, 'A "pop fly" is a ball hit:', '["Along the ground", "High in the air, usually in the infield", "Over the outfield fence", "Into the dugout"]', '{"index": 1}', '', true),
('00000029-0001-0001-0000-000000000008', '00000029-0001-0000-0000-000000000008', 1, 'A "line drive" is a ball hit:', '["Along the ground slowly", "High in the air", "Hard and straight through the air, roughly parallel to the ground", "Backwards behind home plate"]', '{"index": 2}', '', true),
('00000029-0001-0001-0000-000000000009', '00000029-0001-0000-0000-000000000009', 1, 'If a fly ball is caught, what happens to runners already on base?', '["They are automatically out", "They must return to their base (or ''tag up'') before trying to advance", "They can run freely to the next base", "The inning ends immediately"]', '{"index": 1}', '', true);

-- ============================================================================
-- LESSON 10: PL2 - Plays 2 (ORDER: 10)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-00000000000a',
    '22222222-2222-2222-2222-222222222222',
    'Plays 2',
    'Learn about double plays, stolen bases, and strategic plays.',
    10, 4, 50, true, 'PL2', 5, 5
);

-- PL2 Items
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('0000002a-0001-0000-0000-000000000001', '00000002-0000-0000-0000-00000000000a', 'mcq', 'What is a "double play"?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('0000002a-0001-0000-0000-000000000002', '00000002-0000-0000-0000-00000000000a', 'mcq', 'The most common double play starts with a ground ball. If there''s a runner on first, what typically happens?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('0000002a-0001-0000-0000-000000000003', '00000002-0000-0000-0000-00000000000a', 'mcq', 'What is a "stolen base"?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('0000002a-0001-0000-0000-000000000004', '00000002-0000-0000-0000-00000000000a', 'mcq', 'What does "caught stealing" mean?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('0000002a-0001-0000-0000-000000000005', '00000002-0000-0000-0000-00000000000a', 'mcq', 'What is a "pickoff"?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('0000002a-0001-0000-0000-000000000006', '00000002-0000-0000-0000-00000000000a', 'mcq', 'What does it mean to "tag up"?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('0000002a-0001-0000-0000-000000000007', '00000002-0000-0000-0000-00000000000a', 'mcq', 'A "triple play" is very rare. What is it?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('0000002a-0001-0000-0000-000000000008', '00000002-0000-0000-0000-00000000000a', 'binary', 'Runners can attempt to steal a base as soon as the pitcher begins their motion to throw.', '{"correct_boolean": true}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('0000002a-0001-0000-0000-000000000009', '00000002-0000-0000-0000-00000000000a', 'mcq', 'There''s a runner on third base with less than 2 outs. The batter hits a deep fly ball that is caught. What can the runner on third do?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1);

-- PL2 Item Variants
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('0000002a-0001-0001-0000-000000000001', '0000002a-0001-0000-0000-000000000001', 1, 'What is a "double play"?', '["When a batter hits the ball twice", "When a runner scores two runs", "When the defense gets two outs on one play", "When a pitcher throws two strikes in a row"]', '{"index": 2}', '', true),
('0000002a-0001-0001-0000-000000000002', '0000002a-0001-0000-0000-000000000002', 1, 'The most common double play starts with a ground ball. If there''s a runner on first, what typically happens?', '["The fielder throws to second for the force out, then second base throws to first for another force out", "Both runners go home", "The batter runs to second base", "The pitcher catches the ball"]', '{"index": 0}', '', true),
('0000002a-0001-0001-0000-000000000003', '0000002a-0001-0000-0000-000000000003', 1, 'What is a "stolen base"?', '["Taking a base that was removed from the field", "When a runner advances to the next base during a pitch, without the batter hitting the ball", "Running backwards around the bases", "When the defense loses track of the ball"]', '{"index": 1}', '', true),
('0000002a-0001-0001-0000-000000000004', '0000002a-0001-0000-0000-000000000004', 1, 'What does "caught stealing" mean?', '["The runner was caught taking a base that wasn''t theirs", "The batter was caught cheating", "A runner tried to steal a base but was tagged out before reaching it", "The umpire caught a mistake"]', '{"index": 2}', '', true),
('0000002a-0001-0001-0000-000000000005', '0000002a-0001-0000-0000-000000000005', 1, 'What is a "pickoff"?', '["When a pitcher or catcher throws to a base to try to get a runner out before they can return", "When a fielder picks up a ground ball", "When the batter picks which pitch to swing at", "Choosing a player in the draft"]', '{"index": 0}', '', true),
('0000002a-0001-0001-0000-000000000006', '0000002a-0001-0000-0000-000000000006', 1, 'What does it mean to "tag up"?', '["To tag a runner out", "On a fly ball, a runner returns to their base and can advance after the catch is made", "To switch players during the game", "To add a run to the scoreboard"]', '{"index": 1}', '', true),
('0000002a-0001-0001-0000-000000000007', '0000002a-0001-0000-0000-000000000007', 1, 'A "triple play" is very rare. What is it?', '["When a batter hits a triple", "When three runners score on one play", "When the defense gets three outs on one play", "When a pitcher strikes out three batters in a row"]', '{"index": 2}', '', true),
('0000002a-0001-0001-0000-000000000008', '0000002a-0001-0000-0000-000000000008', 1, 'Runners can attempt to steal a base as soon as the pitcher begins their motion to throw.', '["True", "False"]', '{"boolean": true}', '', true),
('0000002a-0001-0001-0000-000000000009', '0000002a-0001-0000-0000-000000000009', 1, 'There''s a runner on third base with less than 2 outs. The batter hits a deep fly ball that is caught. What can the runner on third do?', '["They are automatically out", "They can ''tag up'' (touch third base after the catch) and try to score", "They must stay at third base no matter what", "They must run to home immediately"]', '{"index": 1}', '', true);

-- ============================================================================
-- LESSON 11: Rookie Foundations Quiz (ORDER: 11)
-- ============================================================================

INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, code, items_per_session, required_completions)
VALUES (
    '00000002-0000-0000-0000-00000000000b',
    '22222222-2222-2222-2222-222222222222',
    'Rookie Foundations Quiz',
    'Test your knowledge of baseball fundamentals! Covers all Rookie lessons.',
    11, 6, 100, true, 'RFQ', 10, 3
);

-- Quiz Items
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty) VALUES
('0000002b-0001-0000-0000-000000000001', '00000002-0000-0000-0000-00000000000b', 'mcq', 'How many innings are in a standard professional baseball game?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('0000002b-0001-0000-0000-000000000002', '00000002-0000-0000-0000-00000000000b', 'mcq', 'How far apart are the bases in professional baseball?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('0000002b-0001-0000-0000-000000000003', '00000002-0000-0000-0000-00000000000b', 'mcq', 'What is "foul territory"?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('0000002b-0001-0000-0000-000000000004', '00000002-0000-0000-0000-00000000000b', 'mcq', 'What is the maximum number of runs that can score on a single home run?', '{"correct_index": 3}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('0000002b-0001-0000-0000-000000000005', '00000002-0000-0000-0000-00000000000b', 'mcq', 'What is a "full count"?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('0000002b-0001-0000-0000-000000000006', '00000002-0000-0000-0000-00000000000b', 'mcq', 'What is a "double" in baseball?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('0000002b-0001-0000-0000-000000000007', '00000002-0000-0000-0000-00000000000b', 'mcq', 'The pitcher and catcher together are called the:', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('0000002b-0001-0000-0000-000000000008', '00000002-0000-0000-0000-00000000000b', 'mcq', 'How many outfielders are on the field during a play?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('0000002b-0001-0000-0000-000000000009', '00000002-0000-0000-0000-00000000000b', 'mcq', 'What is a "force out"?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('0000002b-0001-0000-0000-000000000010', '00000002-0000-0000-0000-00000000000b', 'mcq', 'What is a "double play"?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('0000002b-0001-0000-0000-000000000011', '00000002-0000-0000-0000-00000000000b', 'mcq', 'The New York Yankees have a runner on second base. The batter hits a single to right field. What most likely happens?', '{"correct_index": 0}', '00000000-0000-0000-0000-000000000000', 'live', 2),
('0000002b-0001-0000-0000-000000000012', '00000002-0000-0000-0000-00000000000b', 'mcq', 'How many strikes equal a strikeout, and how many balls equal a walk?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('0000002b-0001-0000-0000-000000000013', '00000002-0000-0000-0000-00000000000b', 'binary', 'The designated hitter (DH) plays a defensive position in the field.', '{"correct_boolean": false}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('0000002b-0001-0000-0000-000000000014', '00000002-0000-0000-0000-00000000000b', 'mcq', 'How many outs does a team get before switching from batting to fielding?', '{"correct_index": 2}', '00000000-0000-0000-0000-000000000000', 'live', 1),
('0000002b-0001-0000-0000-000000000015', '00000002-0000-0000-0000-00000000000b', 'mcq', 'What is a "stolen base"?', '{"correct_index": 1}', '00000000-0000-0000-0000-000000000000', 'live', 1);

-- Quiz Item Variants
INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active) VALUES
('0000002b-0001-0001-0000-000000000001', '0000002b-0001-0000-0000-000000000001', 1, 'How many innings are in a standard professional baseball game?', '["6 innings", "7 innings", "9 innings", "10 innings"]', '{"index": 2}', '', true),
('0000002b-0001-0001-0000-000000000002', '0000002b-0001-0000-0000-000000000002', 1, 'How far apart are the bases in professional baseball?', '["60 feet", "75 feet", "90 feet", "100 feet"]', '{"index": 2}', '', true),
('0000002b-0001-0001-0000-000000000003', '0000002b-0001-0000-0000-000000000003', 1, 'What is "foul territory"?', '["The area between the bases", "The area outside the foul lines", "The pitcher''s mound", "The dugout area"]', '{"index": 1}', '', true),
('0000002b-0001-0001-0000-000000000004', '0000002b-0001-0000-0000-000000000004', 1, 'What is the maximum number of runs that can score on a single home run?', '["1 run", "2 runs", "3 runs", "4 runs (grand slam)"]', '{"index": 3}', '', true),
('0000002b-0001-0001-0000-000000000005', '0000002b-0001-0000-0000-000000000005', 1, 'What is a "full count"?', '["2 balls, 2 strikes", "3 balls, 2 strikes", "4 balls, 3 strikes", "0 balls, 0 strikes"]', '{"index": 1}', '', true),
('0000002b-0001-0001-0000-000000000006', '0000002b-0001-0000-0000-000000000006', 1, 'What is a "double" in baseball?', '["A hit where the batter reaches second base safely", "Two runs scored", "Two strikeouts", "A hit that bounces twice"]', '{"index": 0}', '', true),
('0000002b-0001-0001-0000-000000000007', '0000002b-0001-0000-0000-000000000007', 1, 'The pitcher and catcher together are called the:', '["Power duo", "Diamond pair", "Battery", "Throwing team"]', '{"index": 2}', '', true),
('0000002b-0001-0001-0000-000000000008', '0000002b-0001-0000-0000-000000000008', 1, 'How many outfielders are on the field during a play?', '["2", "4", "3", "5"]', '{"index": 2}', '', true),
('0000002b-0001-0001-0000-000000000009', '0000002b-0001-0000-0000-000000000009', 1, 'What is a "force out"?', '["Tagging a runner between bases", "Touching the base before a runner who must advance", "Catching a fly ball", "Striking out a batter"]', '{"index": 1}', '', true),
('0000002b-0001-0001-0000-000000000010', '0000002b-0001-0000-0000-000000000010', 1, 'What is a "double play"?', '["Hitting the ball twice", "Scoring two runs", "Getting two outs on one play", "Playing two positions"]', '{"index": 2}', '', true),
('0000002b-0001-0001-0000-000000000011', '0000002b-0001-0000-0000-000000000011', 1, 'The New York Yankees have a runner on second base. The batter hits a single to right field. What most likely happens?', '["The runner on second scores and the batter ends up on first", "The runner on second stays at second", "Both runners are out", "The inning ends"]', '{"index": 0}', '', true),
('0000002b-0001-0001-0000-000000000012', '0000002b-0001-0000-0000-000000000012', 1, 'How many strikes equal a strikeout, and how many balls equal a walk?', '["2 strikes, 3 balls", "3 strikes, 4 balls", "4 strikes, 4 balls", "3 strikes, 3 balls"]', '{"index": 1}', '', true),
('0000002b-0001-0001-0000-000000000013', '0000002b-0001-0000-0000-000000000013', 1, 'The designated hitter (DH) plays a defensive position in the field.', '["True", "False"]', '{"boolean": false}', '', true),
('0000002b-0001-0001-0000-000000000014', '0000002b-0001-0000-0000-000000000014', 1, 'How many outs does a team get before switching from batting to fielding?', '["1 out", "2 outs", "3 outs", "4 outs"]', '{"index": 2}', '', true),
('0000002b-0001-0001-0000-000000000015', '0000002b-0001-0000-0000-000000000015', 1, 'What is a "stolen base"?', '["Taking the actual base off the field", "Advancing to the next base during a pitch without the batter hitting the ball", "Running the wrong direction", "Hiding at a base"]', '{"index": 1}', '', true);

-- ============================================================================
-- END OF SEED DATA
-- ============================================================================

-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT 'Baseball Content Summary' as report;

SELECT
    'Sport' as type,
    name as name,
    id::text as id
FROM sports WHERE id = '02ba5eba-1100-0000-0000-000000000000'

UNION ALL

SELECT
    'Module' as type,
    title as name,
    id::text as id
FROM modules WHERE id = '22222222-2222-2222-2222-222222222222'

UNION ALL

SELECT
    'Lessons' as type,
    COUNT(*)::text as name,
    '' as id
FROM lessons WHERE module_id = '22222222-2222-2222-2222-222222222222'

UNION ALL

SELECT
    'Items' as type,
    COUNT(*)::text as name,
    '' as id
FROM items i
JOIN lessons l ON i.lesson_id = l.id
WHERE l.module_id = '22222222-2222-2222-2222-222222222222'

UNION ALL

SELECT
    'Item Variants' as type,
    COUNT(*)::text as name,
    '' as id
FROM item_variants iv
JOIN items i ON iv.item_id = i.id
JOIN lessons l ON i.lesson_id = l.id
WHERE l.module_id = '22222222-2222-2222-2222-222222222222';
