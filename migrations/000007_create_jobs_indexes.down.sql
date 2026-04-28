-- Drop indexes created for the jobs table.

DROP INDEX IF EXISTS idx_jobs_result;
DROP INDEX IF EXISTS idx_jobs_payload;
DROP INDEX IF EXISTS idx_jobs_updated_at;
DROP INDEX IF EXISTS idx_jobs_status_created;