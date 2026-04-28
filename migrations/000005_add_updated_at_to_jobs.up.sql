-- Add updated_at so we can track when a job last changed.
-- This supports polling, monitoring, and finding stuck jobs.

ALTER TABLE jobs
ADD COLUMN updated_at TIMESTAMPTZ NOT NULL DEFAULT now();

-- Make existing rows consistent.
UPDATE jobs
SET updated_at = created_at;