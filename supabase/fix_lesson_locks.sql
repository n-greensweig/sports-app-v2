-- Fix Lesson Locking Status
-- This script resets the lock status of all lessons to the correct initial state.

-- 1. Lock ALL lessons by default
UPDATE lessons 
SET is_locked = true;

-- 2. Unlock ONLY the first lesson of each module (order_index = 1)
UPDATE lessons 
SET is_locked = false 
WHERE order_index = 1;

-- 3. (Optional) If you want to keep lessons unlocked that users have already completed, 
-- you would need a more complex query involving user_progress. 
-- For now, this resets to a clean state where users must complete lessons in order.
