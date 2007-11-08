-- No existe el usuario destino
execute procedure spd_mensaje(665,666,10,666);

-- No existe el usuario remitente
execute procedure spd_mensaje(666,665,10,666);

-- No existe el mensaje
execute procedure spd_mensaje(666,666,50,666);

-- El mensaje no puede ser borrado. Debe ser el usuario destinatario para poder hacerlo
execute procedure spd_mensaje(666,666,1,111);

-- Ejecuta OK
execute procedure spd_mensaje(666,666,8,666);
