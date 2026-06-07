alter table asesorados 
add column id_auth uuid references perfiles(id);