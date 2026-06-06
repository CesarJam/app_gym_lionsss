-- 1. Crear la tabla de perfiles
create table public.perfiles (
  id uuid references auth.users on delete cascade primary key,
  nombre_completo text,
  rol text
);

-- 2. Habilitar que sea completamente pública por ahora (desactivar RLS internamente)
alter table public.perfiles disable row level security;