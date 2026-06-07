-- 1. Aseguramos que el bucket permita lecturas públicas
UPDATE storage.buckets SET public = true WHERE id = 'fotos-asesorados';

-- 2. Creamos la política de seguridad para permitir subidas (INSERT) a usuarios sin sesión (anon)
CREATE POLICY "Permitir subida anonima"
ON storage.objects FOR INSERT
TO anon
WITH CHECK ( bucket_id = 'fotos-asesorados' );