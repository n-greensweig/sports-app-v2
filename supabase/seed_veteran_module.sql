-- ============================================================================
-- Veteran Module - Seed Data
-- ============================================================================
-- Veteran is the SECOND module - intermediate concepts for users who have
-- completed or tested out of Rookie
--
-- Veteran covers: Penalties, Formations, Clock Management, Football Lingo,
-- League Structure, and Strategy Basics
--
-- Module ID: 33333333-3333-3333-3333-333333333333
-- ============================================================================

-- ============================================================================
-- STEP 1: Ensure Football sport exists (should already exist from Rookie)
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
-- VERIFICATION
-- ============================================================================

SELECT
    'Veteran Module' as entity,
    title,
    order_index
FROM modules
WHERE id = '33333333-3333-3333-3333-333333333333';
