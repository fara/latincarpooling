-- No existe el usuario
execute procedure dbo.spiu_vehiculo (665, 2, 'Fox', 'Azul', 'BQI854', 1, 10, 't', 4);
-- No existe el vehiculo
execute procedure dbo.spiu_vehiculo (666, 2, 'Fox', 'Azul', 'BQI854', 1, 10, 't', 4);
-- Crea ok
execute procedure dbo.spiu_vehiculo (666, 1, 'Fox', 'Azul', 'BQI854', 1, 10, 't', 4);
-- Actualiza ok
execute procedure dbo.spiu_vehiculo (666, 1, 'Fox', 'Azul Claro', 'BQI854', 1, 10, 't', 4);