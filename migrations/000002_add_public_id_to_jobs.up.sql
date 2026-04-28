-- Add a public-facing random UUID.
-- This is what clients should use instead of the internal UUIDv7 ID.

ALTER TABLE jobs
ADD COLUMN public_id UUID NOT NULL UNIQUE DEFAULT uuidv4();