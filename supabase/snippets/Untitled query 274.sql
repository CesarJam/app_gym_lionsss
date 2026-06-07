-- Borrar las políticas existentes en storage.objects para este bucket
DROP POLICY IF EXISTS "Permitir subida anonima" ON storage.objects;
DROP POLICY IF EXISTS "Public Access" ON storage.objects;

-- Asegurar que el bucket sea público
UPDATE storage.buckets SET public = true WHERE id = 'fotos-asesorados';