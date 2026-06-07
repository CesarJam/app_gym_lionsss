-- 1. Borramos todas las políticas actuales para evitar conflictos
DROP POLICY IF EXISTS "Public Read Access" ON storage.objects;
DROP POLICY IF EXISTS "Public Insert Access" ON storage.objects;
DROP POLICY IF EXISTS "Usuarios pueden borrar sus propias fotos" ON storage.objects;
DROP POLICY IF EXISTS "Usuarios pueden actualizar sus propias fotos" ON storage.objects;
DROP POLICY IF EXISTS "Usuarios autenticados pueden subir fotos" ON storage.objects;
DROP POLICY IF EXISTS "Cualquiera puede ver las fotos" ON storage.objects;
DROP POLICY IF EXISTS "Permitir subida anonima" ON storage.objects;

-- 2. Aseguramos que el bucket sea público
UPDATE storage.buckets SET public = true WHERE id = 'fotos-asesorados';

-- 3. Creamos la política de lectura pública (para todos)
CREATE POLICY "Public Read"
ON storage.objects FOR SELECT
USING (bucket_id = 'fotos-asesorados');

-- 4. Creamos la política de subida pública (para anon y autenticados)
CREATE POLICY "Public Insert"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'fotos-asesorados');