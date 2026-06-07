-- 1. Permitir que cualquier persona pueda ver las fotos (necesario para el Dashboard y expedientes)
create policy "Cualquiera puede ver las fotos"
on storage.objects for select
using ( bucket_id = 'fotos-asesorados' );

-- 2. Permitir que usuarios autenticados puedan subir sus fotos
create policy "Usuarios autenticados pueden subir fotos"
on storage.objects for insert
with check ( 
  bucket_id = 'fotos-asesorados' 
  and auth.role() = 'authenticated' 
);

-- 3. Permitir que el usuario que subió la foto pueda actualizarla o borrarla (por si se equivoca)
create policy "Usuarios pueden actualizar sus propias fotos"
on storage.objects for update
using ( bucket_id = 'fotos-asesorados' and auth.uid() = owner );

create policy "Usuarios pueden borrar sus propias fotos"
on storage.objects for delete
using ( bucket_id = 'fotos-asesorados' and auth.uid() = owner );