-- ============================================
-- Tester Isolation - Each tester sees only their runs
-- Run this in Supabase SQL Editor
-- ============================================

-- Add tester_phone column to test_runs
ALTER TABLE test_runs ADD COLUMN IF NOT EXISTS tester_phone text;

-- Index for fast filtering
CREATE INDEX IF NOT EXISTS idx_test_runs_tester_phone ON test_runs(tester_phone);
