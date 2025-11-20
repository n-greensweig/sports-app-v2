-- SportsIQ Database Seed Script
-- Module 1: Football Basics
-- Generated: 2025-11-19

-- First, ensure we have the Football sport
-- Using a fixed UUID for consistency
INSERT INTO sports (id, slug, name, accent_color, order_index, is_active, created_at, updated_at)
VALUES (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'::uuid,
    'football',
    'Football',
    '#2E7D32',
    1,
    true,
    now(),
    now()
)
ON CONFLICT (slug) DO UPDATE
SET name = EXCLUDED.name,
    accent_color = EXCLUDED.accent_color,
    order_index = EXCLUDED.order_index;

-- Insert Module 1: Football Basics
INSERT INTO modules (id, sport_id, title, description, order_index, min_level, max_level, xp_reward, created_at, updated_at)
VALUES (
    '11111111-1111-1111-1111-111111111111'::uuid,
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'::uuid,
    'Football Basics',
    'Master the fundamentals of football - from basic rules to understanding game flow',
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

-- Note: This is a starter script. 
-- To complete the seed, we need to add:
-- 1. All 10 lessons
-- 2. All 80 items (questions)
-- 3. Item variants for each item
--
-- This would be a very long SQL file (~2000+ lines).
-- 
-- RECOMMENDATION: Use a script to convert the JSON files to SQL,
-- or use Supabase's bulk import feature with CSV/JSON.
