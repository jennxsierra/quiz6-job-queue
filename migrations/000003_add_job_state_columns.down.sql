-- Remove job state tracking columns.

ALTER TABLE jobs
DROP COLUMN IF EXISTS progress,
DROP COLUMN IF EXISTS status;