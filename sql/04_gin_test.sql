-- Test GIN index usage with EXPLAIN ANALYZE.
-- Expected indexes: idx_jobs_payload and idx_jobs_result.

-- JSONB containment query against payload.
EXPLAIN (ANALYZE, BUFFERS)
SELECT id, payload
FROM jobs
WHERE payload @> '{"mime_type": "image/jpeg"}'::jsonb
LIMIT 200;

-- JSONB key-existence query against payload.
EXPLAIN (ANALYZE, BUFFERS)
SELECT id
FROM jobs
WHERE payload ? 'stored_path'
LIMIT 200;

-- JSONB containment query against result for completed work.
EXPLAIN (ANALYZE, BUFFERS)
SELECT id, result
FROM jobs
WHERE result @> '{"thumbnail_path": "uploads/processed/thumb_d3d9446802a44259755d38e6d163e820.jpg"}'::jsonb
LIMIT 50;
