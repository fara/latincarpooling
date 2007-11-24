-- No existe el usuario
execute procedure spiu_vehiculo (665, 2, 'Fox', 'Azul', 'BQI854', 1, 10, 't', 4);
-- No existe el vehiculo
execute procedure spiu_vehiculo (666, 2, 'Fox', 'Azul', 'BQI854', 1, 10, 't', 4);
-- Crea ok
execute procedure spiu_vehiculo (666, 1, 'Fox', 'Azul', 'BQI854', 1, 10, 't', 4);
-- Actualiza ok
execute procedure spiu_vehiculo (666, 1, 'Fox', 'Azul Claro', 'BQI854', 1, 10, 't', 4);

-- Crea ok

execute procedure spiu_vehiculo (13, 1, 'F-100', 'Roja', 'NVV544', 1, 20, 't', 2);
execute procedure spiu_vehiculo (13, 2, 'Fiat 147', 'Azul', 'NVV544', 1, 16, 't', 4);

