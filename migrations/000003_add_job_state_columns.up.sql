-- Add state tracking columns.
-- status stores the current lifecycle state of the job.
-- progress stores completion percentage from 0 to 100.

ALTER TABLE jobs
ADD COLUMN status TEXT NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'processing', 'done', 'failed')),
ADD COLUMN progress INTEGER NOT NULL DEFAULT 0
    CHECK (progress BETWEEN 0 AND 100);