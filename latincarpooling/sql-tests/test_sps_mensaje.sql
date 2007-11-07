-- No existe el usuario destino
execute procedure sps_mensaje(111, 666, 1);

-- No existe el usuario remitente
execute procedure sps_mensaje(666, 111, 1);

-- No existe el mensaje
execute procedure sps_mensaje(666, 666, 100);

-- Ejecuta OK
execute procedure sps_mensaje(666, 666, 1);