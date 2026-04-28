-- Remove the public-facing client ID.

ALTER TABLE jobs
DROP COLUMN IF EXISTS public_id;