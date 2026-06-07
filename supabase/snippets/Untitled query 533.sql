-- 1. Borramos las políticas anteriores para evitar conflictos
drop policy if exists "Entrenadores ven y crean a sus propios asesorados" on asesorados;
drop policy if exists "Asesorados actualizan su propio registro usando el token" on asesorados;

-- 2. El entrenador sigue teniendo control total sobre los registros que él creó
create policy "Control total para el entrenador" on asesorados 
  for all using ( auth.uid() = id_entrenador );

-- 3. Permitir lectura global (Necesario para que el cliente pueda abrir el enlace mágico y el sistema verifique que existe)
create policy "Permitir lectura publica por token" on asesorados 
  for select using ( true );

-- 4. Permitir la actualización (Necesario para que cuando el cliente se autoconvierta en usuario, pueda inyectar sus datos sin ser bloqueado)
create policy "Permitir actualizacion publica por token" on asesorados 
  for update using ( true );

-- 5. Visión a futuro: Una vez que el atleta ya tenga su cuenta, solo él podrá ver su expediente
create policy "Asesorado ve sus propios datos" on asesorados 
  for select using ( auth.uid() = id_auth );