-- Verify that changing one seeded row refreshes updated_at.
-- Targets the 5th generated file: file_5.jpg.

BEGIN;

-- Before update.
SELECT
    public_id,
    payload->>'original_filename' AS filename,
    status,
    created_at,
    updated_at
FROM jobs
WHERE payload->>'original_filename' = 'file_5.jpg'
LIMIT 1;

-- Update status for the same row.
UPDATE jobs
SET status = 'processing'
WHERE payload->>'original_filename' = 'file_5.jpg';

-- After update.
SELECT
    public_id,
    payload->>'original_filename' AS filename,
    status,
    created_at,
    updated_at
FROM jobs
WHERE payload->>'original_filename' = 'file_5.jpg'
LIMIT 1;

ROLLBACK;
