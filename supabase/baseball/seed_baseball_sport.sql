-- ============================================================================
-- Baseball Sport & Rookie Module - Seed Data
-- ============================================================================
-- This file creates the Baseball sport and Rookie module (section)
-- Run this FIRST before any baseball lesson seeds
-- ============================================================================

-- ============================================================================
-- Baseball Sport ID: 02ba5eba-1100-0000-0000-000000000000
-- Rookie Module ID:  22222222-2222-2222-2222-222222222222
-- ============================================================================

-- ============================================================================
-- STEP 1: Create Baseball Sport
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
    description = EXCLUDED.description,
    is_active = EXCLUDED.is_active;


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
-- STEP 3: Ensure System User exists
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
-- VERIFICATION
-- ============================================================================

SELECT 'Baseball Sport' as entity, COUNT(*) as count
FROM sports WHERE slug = 'baseball'
UNION ALL
SELECT 'Rookie Module' as entity, COUNT(*) as count
FROM modules WHERE id = '22222222-2222-2222-2222-222222222222';
