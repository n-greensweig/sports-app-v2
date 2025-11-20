-- Quick Test Seed Script for SportsIQ
-- This adds minimal data to test the lesson flow
-- Run this in Supabase SQL Editor

-- 1. Get the existing Football sport ID (don't insert, just use what's there)
-- The existing ID is: 0105433b-5bdd-4093-b6b1-157a0c3c515e

-- 2. Insert Football Basics module (using existing sport ID)
INSERT INTO modules (id, sport_id, title, description, order_index, min_level, max_level, xp_reward, created_at, updated_at)
VALUES (
    '11111111-1111-1111-1111-111111111111'::uuid,
    '0105433b-5bdd-4093-b6b1-157a0c3c515e'::uuid,  -- Use existing Football sport ID
    'Football Basics',
    'Master the fundamentals of football',
    1,
    1,
    2,
    0,
    now(),
    now()
)
ON CONFLICT (id) DO UPDATE
SET title = EXCLUDED.title,
    description = EXCLUDED.description;

-- 3. Insert "Runs vs Passes" lesson
INSERT INTO lessons (id, module_id, title, description, order_index, est_minutes, xp_award, is_locked, created_at, updated_at)
VALUES (
    '00000001-0000-0000-0000-000000000001'::uuid,
    '11111111-1111-1111-1111-111111111111'::uuid,
    'Runs vs Passes',
    'Learn to identify the two main types of offensive plays',
    1,
    4,
    80,
    false,
    now(),
    now()
)
ON CONFLICT (id) DO UPDATE
SET title = EXCLUDED.title,
    description = EXCLUDED.description;

-- 4. Insert 3 sample questions for the lesson
-- Question 1: Run or Pass (handoff)
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
    '10000001-0000-0000-0000-000000000001'::uuid,
    '00000001-0000-0000-0000-000000000001'::uuid,
    'mcq',
    'Identify play type',
    '{"type": "mcq", "options": ["Run", "Pass"], "correct": 0}'::jsonb,
    1,
    'live',
    (SELECT id FROM users LIMIT 1), -- Use first user from users table
    now(),
    now()
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
    '20000001-0000-0000-0000-000000000001'::uuid,
    '10000001-0000-0000-0000-000000000001'::uuid,
    1,
    'The quarterback hands the ball to a running back who runs forward. What type of play is this?',
    '["Run", "Pass"]'::jsonb,
    '{"index": 0}'::jsonb,
    'This is a run play. When the ball is handed off or the QB runs with it, it''s a running play. A pass is when the QB throws the ball through the air.',
    true,
    now(),
    now()
)
ON CONFLICT (item_id, version) DO NOTHING;

-- Question 2: Pass play
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
    '10000002-0000-0000-0000-000000000001'::uuid,
    '00000001-0000-0000-0000-000000000001'::uuid,
    'mcq',
    'Identify play type',
    '{"type": "mcq", "options": ["Run", "Pass"], "correct": 1}'::jsonb,
    1,
    'live',
    (SELECT id FROM users LIMIT 1),
    now(),
    now()
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
    '20000002-0000-0000-0000-000000000001'::uuid,
    '10000002-0000-0000-0000-000000000001'::uuid,
    1,
    'The quarterback throws the ball to a receiver downfield. What type of play is this?',
    '["Run", "Pass"]'::jsonb,
    '{"index": 1}'::jsonb,
    'This is a pass play. When the QB throws the ball through the air to a teammate, it''s a passing play.',
    true,
    now(),
    now()
)
ON CONFLICT (item_id, version) DO NOTHING;

-- Question 3: Interception
INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, difficulty, status, author_id, created_at, updated_at)
VALUES (
    '10000003-0000-0000-0000-000000000001'::uuid,
    '00000001-0000-0000-0000-000000000001'::uuid,
    'mcq',
    'Understand interception',
    '{"type": "mcq", "options": ["Interception", "Fumble", "Sack", "Touchdown"], "correct": 0}'::jsonb,
    2,
    'live',
    (SELECT id FROM users LIMIT 1),
    now(),
    now()
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO item_variants (id, item_id, version, prompt_richtext, options_json, correct_answer_json, explanation_richtext, active, created_at, updated_at)
VALUES (
    '20000003-0000-0000-0000-000000000001'::uuid,
    '10000003-0000-0000-0000-000000000001'::uuid,
    1,
    'A defensive player catches a pass intended for the offense. What is this called?',
    '["Interception", "Fumble", "Sack", "Touchdown"]'::jsonb,
    '{"index": 0}'::jsonb,
    'An interception occurs when a defensive player catches a pass meant for an offensive player. This gives possession to the defense, who becomes the offense.',
    true,
    now(),
    now()
)
ON CONFLICT (item_id, version) DO NOTHING;

-- Verify the data was inserted
SELECT 'Sports:' as table_name, COUNT(*) as count FROM sports WHERE slug = 'football'
UNION ALL
SELECT 'Modules:', COUNT(*) FROM modules WHERE sport_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'::uuid
UNION ALL
SELECT 'Lessons:', COUNT(*) FROM lessons WHERE module_id = '11111111-1111-1111-1111-111111111111'::uuid
UNION ALL
SELECT 'Items:', COUNT(*) FROM items WHERE lesson_id = '00000001-0000-0000-0000-000000000001'::uuid
UNION ALL
SELECT 'Variants:', COUNT(*) FROM item_variants WHERE item_id IN (
    SELECT id FROM items WHERE lesson_id = '00000001-0000-0000-0000-000000000001'::uuid
);
