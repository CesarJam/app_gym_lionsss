-- Convertimos las columnas a tipo numérico
alter table asesorados 
alter column peso_actual type numeric using nullif(regexp_replace(peso_actual, '[^0-9.]', '', 'g'), '')::numeric,
alter column estatura type numeric using nullif(regexp_replace(estatura, '[^0-9.]', '', 'g'), '')::numeric;