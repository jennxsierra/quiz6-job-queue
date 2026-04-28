-- Create indexes for common job queue queries.

-- Supports worker polling by status and created_at order.
CREATE INDEX IF NOT EXISTS idx_jobs_status_created
ON jobs (status, created_at);

-- Supports polling or filtering by recent changes.
CREATE INDEX IF NOT EXISTS idx_jobs_updated_at
ON jobs (updated_at DESC);

-- GIN index for searching inside the JSONB payload.
CREATE INDEX IF NOT EXISTS idx_jobs_payload
ON jobs USING GIN (payload);

-- GIN index for searching inside the JSONB result.
CREATE INDEX IF NOT EXISTS idx_jobs_result
ON jobs USING GIN (result);