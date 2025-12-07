-- ============================================================================
-- Test-Out Feature - Database Migration
-- ============================================================================
-- Allows users to skip modules by passing a 25-question assessment (20/25 to pass)
-- - 2 attempts per 24-hour period, then cooldown
-- - On pass: Unlock all lessons in NEXT module
-- ============================================================================

-- ============================================================================
-- STEP 1: Create module_test_outs table (configuration per module)
-- ============================================================================

CREATE TABLE IF NOT EXISTS module_test_outs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    module_id UUID NOT NULL REFERENCES modules(id) ON DELETE CASCADE,
    passing_score INT NOT NULL DEFAULT 20,
    total_questions INT NOT NULL DEFAULT 25,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    UNIQUE(module_id)
);

-- Add comment for documentation
COMMENT ON TABLE module_test_outs IS 'Configuration for module test-out assessments that allow users to skip modules';
COMMENT ON COLUMN module_test_outs.passing_score IS 'Number of correct answers required to pass (default 20 out of 25)';
COMMENT ON COLUMN module_test_outs.total_questions IS 'Total questions shown in the test-out assessment';

-- ============================================================================
-- STEP 2: Create user_test_out_attempts table (tracks user attempts)
-- ============================================================================

CREATE TABLE IF NOT EXISTS user_test_out_attempts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    module_id UUID NOT NULL REFERENCES modules(id) ON DELETE CASCADE,
    score INT NOT NULL,
    passed BOOLEAN NOT NULL,
    attempted_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Index for efficient cooldown queries (user + module + time-ordered)
CREATE INDEX IF NOT EXISTS idx_test_out_attempts_user_module
ON user_test_out_attempts(user_id, module_id, attempted_at DESC);

-- Index for checking if user has passed
CREATE INDEX IF NOT EXISTS idx_test_out_attempts_passed
ON user_test_out_attempts(user_id, module_id) WHERE passed = true;

COMMENT ON TABLE user_test_out_attempts IS 'Records each test-out attempt by users, including score and pass/fail status';

-- ============================================================================
-- STEP 3: Create test_out_items table (questions for test-outs)
-- ============================================================================

CREATE TABLE IF NOT EXISTS test_out_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    module_id UUID NOT NULL REFERENCES modules(id) ON DELETE CASCADE,
    item_id UUID NOT NULL REFERENCES items(id) ON DELETE CASCADE,
    order_index INT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    UNIQUE(module_id, item_id)
);

-- Index for fetching items by module
CREATE INDEX IF NOT EXISTS idx_test_out_items_module
ON test_out_items(module_id, order_index);

COMMENT ON TABLE test_out_items IS 'Links items to module test-outs, creating the question pool for assessments';

-- ============================================================================
-- STEP 4: Row Level Security (RLS) Policies
-- ============================================================================

-- Enable RLS on all new tables
ALTER TABLE module_test_outs ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_test_out_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_out_items ENABLE ROW LEVEL SECURITY;

-- module_test_outs: Anyone can read (public content)
CREATE POLICY "Anyone can read module test-out configs"
ON module_test_outs FOR SELECT
USING (true);

-- user_test_out_attempts: Users can only see/insert their own attempts
CREATE POLICY "Users can read own test-out attempts"
ON user_test_out_attempts FOR SELECT
USING (auth.uid()::text = user_id::text);

CREATE POLICY "Users can insert own test-out attempts"
ON user_test_out_attempts FOR INSERT
WITH CHECK (auth.uid()::text = user_id::text);

-- test_out_items: Anyone can read (public content)
CREATE POLICY "Anyone can read test-out items"
ON test_out_items FOR SELECT
USING (true);

-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT
    'module_test_outs' as table_name,
    COUNT(*) as row_count
FROM module_test_outs
UNION ALL
SELECT
    'user_test_out_attempts' as table_name,
    COUNT(*) as row_count
FROM user_test_out_attempts
UNION ALL
SELECT
    'test_out_items' as table_name,
    COUNT(*) as row_count
FROM test_out_items;
