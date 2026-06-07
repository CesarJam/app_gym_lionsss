create table asesorados (
  id uuid default uuid_generate_v4() primary key,
  id_entrenador uuid references perfiles(id) on delete cascade not null,
  
  -- Estado y control del formulario
  token_registro uuid default uuid_generate_v4() unique,
  estado_registro text default 'pendiente', -- cambiará a 'completado' cuando el asesorado llene el formulario
  fecha_creacion timestamp with time zone default timezone('utc'::text, now()),
  
  -- Datos Básicos
  nombre_completo text not null,
  fecha_nacimiento date,
  correo text,
  peso_actual text,
  estatura text,
  
  -- Historial Médico y Físico
  cirugias_recientes text,
  enfermedades_cronicas text,
  limitaciones_fisicas text,
  
  -- Objetivos y Disponibilidad
  objetivo text,
  dias_entrenar text,
  tiempo_diario text,
  experiencia_gimnasio text,
  actividad_laboral text,
  
  -- Nutrición
  comidas_diarias text,
  preferencias_alimentos text,
  alimentos_restringidos text
);

-- Políticas de seguridad para que el entrenador solo vea a sus propios asesorados
alter table asesorados enable row level security;

create policy "Entrenadores ven y crean a sus propios asesorados"
  on asesorados for all
  using ( auth.uid() = id_entrenador );

-- Política pública para que el asesorado pueda actualizar su registro usando el token (sin iniciar sesión)
create policy "Asesorados actualizan su propio registro usando el token"
  on asesorados for update
  using ( true );