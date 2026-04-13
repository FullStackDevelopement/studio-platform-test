-- ============================================================================
-- Allow MP3 uploads: add audio/mpeg (and audio/mp3) to beat storage buckets
-- ============================================================================

UPDATE storage.buckets
SET allowed_mime_types = ARRAY(
  SELECT DISTINCT u
  FROM unnest(
    coalesce(allowed_mime_types, '{}'::text[])
    || ARRAY['audio/mpeg', 'audio/mp3']::text[]
  ) AS u
)
WHERE id IN ('beat-previews', 'beat-files');
