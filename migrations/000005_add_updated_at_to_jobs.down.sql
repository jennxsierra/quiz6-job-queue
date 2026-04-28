-- Remove the updated_at column.

ALTER TABLE jobs
DROP COLUMN IF EXISTS updated_at;