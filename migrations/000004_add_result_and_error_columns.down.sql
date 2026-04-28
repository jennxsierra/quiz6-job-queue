-- Remove output tracking columns.

ALTER TABLE jobs
DROP COLUMN IF EXISTS error_msg,
DROP COLUMN IF EXISTS result;