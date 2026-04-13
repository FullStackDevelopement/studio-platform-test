-- ============================================================================
-- Storage RLS: public read on beat-previews; uploads only for admin / engineer / beatmaker
-- ============================================================================

DROP POLICY IF EXISTS "beat-previews: auth insert own" ON storage.objects;
DROP POLICY IF EXISTS "beat-previews: auth update own" ON storage.objects;
DROP POLICY IF EXISTS "beat-previews: auth delete own" ON storage.objects;

DROP POLICY IF EXISTS "beat-files: auth insert own" ON storage.objects;
DROP POLICY IF EXISTS "beat-files: auth update own" ON storage.objects;
DROP POLICY IF EXISTS "beat-files: auth delete own" ON storage.objects;

CREATE OR REPLACE FUNCTION public.can_upload_beat_storage()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.profiles
    WHERE id = auth.uid()
      AND role IN ('admin', 'engineer', 'beatmaker')
  );
$$;

-- beat-previews: "beat-previews: public read" unchanged from 20260330_storage_buckets.sql

CREATE POLICY "beat-previews: roles insert own"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'beat-previews'
    AND public.can_upload_beat_storage()
    AND (storage.foldername(name))[1] = (SELECT auth.uid()::text)
  );

CREATE POLICY "beat-previews: roles update own"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'beat-previews'
    AND public.can_upload_beat_storage()
    AND (storage.foldername(name))[1] = (SELECT auth.uid()::text)
  )
  WITH CHECK (
    bucket_id = 'beat-previews'
    AND public.can_upload_beat_storage()
    AND (storage.foldername(name))[1] = (SELECT auth.uid()::text)
  );

CREATE POLICY "beat-previews: roles delete own"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'beat-previews'
    AND public.can_upload_beat_storage()
    AND (storage.foldername(name))[1] = (SELECT auth.uid()::text)
  );

CREATE POLICY "beat-files: roles insert own"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'beat-files'
    AND public.can_upload_beat_storage()
    AND (storage.foldername(name))[1] = (SELECT auth.uid()::text)
  );

CREATE POLICY "beat-files: roles update own"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'beat-files'
    AND public.can_upload_beat_storage()
    AND (storage.foldername(name))[1] = (SELECT auth.uid()::text)
  )
  WITH CHECK (
    bucket_id = 'beat-files'
    AND public.can_upload_beat_storage()
    AND (storage.foldername(name))[1] = (SELECT auth.uid()::text)
  );

CREATE POLICY "beat-files: roles delete own"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'beat-files'
    AND public.can_upload_beat_storage()
    AND (storage.foldername(name))[1] = (SELECT auth.uid()::text)
  );
