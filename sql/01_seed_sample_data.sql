-- Insert 100,000 fake jobs for local development and demo data.
-- The table defaults handle id, public_id, created_at, and updated_at.

INSERT INTO jobs (
    status,
    progress,
    payload,
    result,
    error_msg
)
SELECT
    -- Cycle through a fixed mix of job states so the dataset stays predictable.
    s.status,

    -- Keep progress aligned with the current state.
    CASE s.status
        WHEN 'pending' THEN 0
        WHEN 'processing' THEN (random() * 99)::INTEGER
        WHEN 'done' THEN 100
        WHEN 'failed' THEN (random() * 99)::INTEGER
    END AS progress,

    -- Simulate an uploaded image payload for each fake job.
    jsonb_build_object(
        'original_filename', 'file_' || i || '.jpg',
        'stored_path', 'uploads/' || md5(i::text) || '.jpg',
        'mime_type', CASE
            WHEN random() > 0.2 THEN 'image/jpeg'
            ELSE 'image/png'
        END,
        'file_size', (random() * 10000000)::INTEGER
    ) AS payload,

    -- Only completed jobs get output files; other states keep an empty result.
    CASE s.status
        WHEN 'done' THEN jsonb_build_object(
            'grayscale_path', 'uploads/processed/gray_' || md5(i::text) || '.jpg',
            'blurred_path', 'uploads/processed/blur_' || md5(i::text) || '.jpg',
            'scaled_path', 'uploads/processed/scaled_' || md5(i::text) || '.jpg',
            'thumbnail_path', 'uploads/processed/thumb_' || md5(i::text) || '.jpg'
        )
        ELSE '{}'::jsonb
    END AS result,

    -- Only failed jobs carry an error message.
    CASE s.status
        WHEN 'failed' THEN 'ImageProcessingError: stage ' || (random() * 4)::INTEGER
        ELSE NULL
    END AS error_msg
-- Generate exactly 100,000 rows.
FROM generate_series(1, 100000) AS i
-- Derive the status from the row number so each state appears evenly.
CROSS JOIN LATERAL (
    SELECT (ARRAY['pending', 'processing', 'done', 'failed'])[((i - 1) % 4) + 1] AS status
) AS s;
