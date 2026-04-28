-- Add output tracking columns.
-- result stores variable output file paths using JSONB.
-- error_msg stores failure information when a job fails.

ALTER TABLE jobs
ADD COLUMN result JSONB NOT NULL DEFAULT '{}',
ADD COLUMN error_msg TEXT;