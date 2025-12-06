-- Test insert to debug items issue
-- Run this in Supabase SQL Editor to see specific errors

-- Step 1: Check if system user exists
SELECT id, email FROM users WHERE id = '00000000-0000-0000-0000-000000000000';

-- Step 2: Check if baseball sport exists
SELECT id, name FROM sports WHERE slug = 'baseball';

-- Step 3: Check if module exists
SELECT id, title FROM modules WHERE id = '22222222-2222-2222-2222-222222222222';

-- Step 4: Check if AB1 lesson exists
SELECT id, title FROM lessons WHERE id = '00000002-0000-0000-0000-000000000005';

-- Step 5: Try inserting a single item with explicit error handling
DO $$
BEGIN
    INSERT INTO items (id, lesson_id, type, base_prompt, answer_schema_json, author_id, status, difficulty)
    VALUES (
        '00000025-0001-0000-0000-000000000001',
        '00000002-0000-0000-0000-000000000005',
        'mcq',
        'What is a "strike" in baseball?',
        '{"correct_index": 1}',
        '00000000-0000-0000-0000-000000000000',
        'live',
        1
    );
    RAISE NOTICE 'Item insert succeeded';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Item insert failed: %', SQLERRM;
END $$;

-- Step 6: Check what items exist for AB1
SELECT id, base_prompt FROM items WHERE lesson_id = '00000002-0000-0000-0000-000000000005';
