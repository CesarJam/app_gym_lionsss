-- 1. Permitir que CUALQUIERA pueda ver las fotos (SELECT)
CREATE POLICY "Public Read Access"
ON storage.objects FOR SELECT
USING (bucket_id = 'fotos-asesorados');

-- 2. Permitir que CUALQUIERA pueda subir fotos (INSERT)
CREATE POLICY "Public Insert Access"
ON storage.objects FOR INSERT
TO anon
WITH CHECK (bucket_id = 'fotos-asesorados');