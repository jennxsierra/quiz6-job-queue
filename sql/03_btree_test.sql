-- Test B-Tree index usage with EXPLAIN ANALYZE.
-- Expected indexes: idx_jobs_status_created and idx_jobs_updated_at.

-- Should favor idx_jobs_status_created (status filter + created_at ordering).
EXPLAIN (ANALYZE, BUFFERS)
SELECT id, status, created_at
FROM jobs
WHERE status = 'processing'
ORDER BY created_at ASC
LIMIT 200;

-- Should favor idx_jobs_updated_at for recent-first reads.
EXPLAIN (ANALYZE, BUFFERS)
SELECT id, updated_at, status
FROM jobs
ORDER BY updated_at DESC
LIMIT 200;
